import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:messageapp/Features/auth/data/models/login_response.dart';
import '../../../../core/services/AppleSign.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/api_endpoints.dart';
import '../../../../core/services/api_exceptions.dart';
import '../../../../core/services/auth_api_service.dart';
import '../../../../core/services/googleSign.dart';
import '../../../../core/services/network_info.dart';
import '../../../../core/services/token_service.dart';

// --- STATES ---

sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final LoginResponse data;
  const LoginSuccess(this.data);
}

/// Email/password login succeeded but account is not verified yet.
class LoginNeedsVerification extends LoginState {
  final String email;
  const LoginNeedsVerification(this.email);
}

/// Registration succeeded — navigate to OTP verification.
class RegisterSuccess extends LoginState {
  final String email;
  const RegisterSuccess(this.email);
}

/// OTP verification succeeded — navigate back to login.
class VerifySuccess extends LoginState {
  const VerifySuccess();
}

class LoginFailure extends LoginState {
  final AppException error;
  const LoginFailure(this.error);
}

/// Provider for TokenService (which wraps Secure Storage and SharedPreferences)
final tokenServiceProvider = Provider<TokenService>((ref) {
  return TokenService.instance;
});

/// Provider for Network connectivity status
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});

/// Lazily initialized ApiClient that retrieves tokens dynamically from TokenService
final apiClientProvider = Provider<ApiClient>((ref) {
  final tokenService = ref.watch(tokenServiceProvider);

  return ApiClient.init(
    baseUrl: ApiEndpoints.baseUrl,
    networkInfo: ref.watch(networkInfoProvider),
    getAccessToken: () async => tokenService.accessToken,
    refreshAccessToken: () async {
      final refreshToken = tokenService.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) return null;

      try {
        // Instantiate a separate Dio client to avoid interceptor recursion
        final dio = Dio();
        final response = await dio.post(
          '${ApiEndpoints.baseUrl}${ApiEndpoints.refreshToken}',
          data: {
            'refreshToken': refreshToken,
          },
        );

        if (response.statusCode == 200) {
          final data = response.data;
          final newAccessToken = data['data']?['accessToken'] ??
              data['response']?['tokens']?['access']?['token'] ??
              data['accessToken'] ??
              data['access_token'];
          final newRefreshToken = data['data']?['refreshToken'] ??
              data['response']?['tokens']?['refresh']?['token'] ??
              data['refreshToken'] ??
              data['refresh_token'];

          if (newAccessToken != null && newAccessToken is String) {
            await tokenService.saveToken(newAccessToken);
            if (newRefreshToken != null && newRefreshToken is String) {
              await tokenService.saveRefreshToken(newRefreshToken);
            }
            return newAccessToken;
          }
        }
      } catch (_) {
        // Silently swallow refresh errors to let onRefreshFailed execute
      }
      return null;
    },
    onRefreshFailed: () async {
      await tokenService.clearTokens();
    },
  );
});

/// API service layer provider
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService(ref.watch(apiClientProvider));
});

/// Controller StateNotifierProvider to manage the Login State
final loginControllerProvider =
    StateNotifierProvider.autoDispose<LoginController, LoginState>((ref) {
  return LoginController(
    ref.watch(authApiServiceProvider),
    ref.watch(tokenServiceProvider),
  );
});

// --- CONTROLLER ---

class LoginController extends StateNotifier<LoginState> {
  final AuthApiService _authApiService;
  final TokenService _tokenService;

  LoginController(this._authApiService, this._tokenService)
      : super(const LoginInitial());

  Future<void> login({required String email, required String password}) async {
    state = const LoginLoading();

    final result =
        await _authApiService.login(email: email, password: password);

    await result.when(
      success: (data) async {
        if (!data.response.data.isEmailVerified) {
          state = LoginNeedsVerification(email);
          return;
        }
        await _persistSession(data);
      },
      failure: (error) async {
        state = LoginFailure(error);
      },
    );
  }

  Future<void> signWithGoogle() async {
    state = const LoginLoading();
    try {
      final result = await GoogleSignInService.signInWithGoogle();
      if (result == null) {
        state = const LoginInitial();
        return;
      }

      final idToken = result['idToken'] as String?;
      if (idToken == null || idToken.isEmpty) {
        state = const LoginFailure(
          UnknownException('Google ID token is missing. Please try again.'),
        );
        return;
      }

      final fcmToken = await _safeFcmToken();
      final apiResult = await _authApiService.loginWithGoogle(
        oAuthToken: idToken,
        fcmToken: fcmToken,
      );

      await apiResult.when(
        success: (data) async => _persistSession(data),
        failure: (error) async {
          state = LoginFailure(error);
        },
      );
    } catch (e) {
      state = LoginFailure(
        UnknownException(e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  Future<void> signInWithApple() async {
    state = const LoginLoading();
    try {
      final result = await AppleSignInService.signInWithApple();
      if (result == null) {
        state = const LoginInitial();
        return;
      }

      final identityToken = result['identityToken'] as String?;
      if (identityToken == null || identityToken.isEmpty) {
        state = const LoginFailure(
          UnknownException('Apple identity token is missing. Please try again.'),
        );
        return;
      }

      final fcmToken = await _safeFcmToken();
      final apiResult = await _authApiService.loginWithApple(
        oAuthToken: identityToken,
        fcmToken: fcmToken,
      );

      await apiResult.when(
        success: (data) async => _persistSession(data),
        failure: (error) async {
          state = LoginFailure(error);
        },
      );
    } catch (e) {
      state = LoginFailure(
        UnknownException(e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const LoginLoading();

    final result = await _authApiService.register(
      email: email,
      password: password,
      name: name,
    );

    await result.when(
      success: (data) async {
        // Optionally persist tokens if backend returns them with register.
        try {
          final loginResponse = LoginResponse.fromJson(data);
          await _saveTokensAndUser(loginResponse);
        } catch (_) {
          // Register often returns no session tokens — OTP verify is next.
        }
        state = RegisterSuccess(email);
      },
      failure: (error) async {
        state = LoginFailure(error);
      },
    );
  }

  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    state = const LoginLoading();

    final result = await _authApiService.verifyAccount(
      email: email,
      code: code,
    );

    await result.when(
      success: (_) async {
        state = const VerifySuccess();
      },
      failure: (error) async {
        state = LoginFailure(error);
      },
    );
  }

  Future<void> resendCode({required String email}) async {
    final result = await _authApiService.resendOtp(email: email);
    result.when(
      success: (_) {},
      failure: (error) {
        state = LoginFailure(error);
      },
    );
  }

  Future<void> _persistSession(LoginResponse data) async {
    try {
      await _saveTokensAndUser(data);
      state = LoginSuccess(data);
    } catch (_) {
      state = const LoginFailure(
        UnknownException('Failed to save authentication session.'),
      );
    }
  }

  Future<void> _saveTokensAndUser(LoginResponse data) async {
    await _tokenService.saveToken(data.response.tokens.access.token);
    await _tokenService.saveRefreshToken(data.response.tokens.refresh.token);
    await _tokenService.saveUserId(data.response.data.id);
    await _tokenService.saveUserEmail(data.response.data.email);
    await _tokenService.saveUserName(data.response.data.name);
    await _tokenService.saveUserAvatar(data.response.data.avatar);
  }

  Future<String?> _safeFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (_) {
      return null;
    }
  }

  void reset() => state = const LoginInitial();
}
