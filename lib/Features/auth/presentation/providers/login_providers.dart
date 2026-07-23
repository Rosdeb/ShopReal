import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/api_endpoints.dart';
import '../../../../core/services/api_exceptions.dart';
import '../../../../core/services/auth_api_service.dart';
import '../../../../core/services/network_info.dart';
import '../../../../core/services/token_service.dart';
import '../../data/models/login_response.dart';

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
          final newAccessToken = data['data']?['accessToken'] ?? data['accessToken'] ?? data['access_token'];
          final newRefreshToken = data['data']?['refreshToken'] ?? data['refreshToken'] ?? data['refresh_token'];

          if (newAccessToken != null && newAccessToken is String) {
            await tokenService.saveToken(newAccessToken);
            if (newRefreshToken != null && newRefreshToken is String) {
              await tokenService.saveRefreshToken(newRefreshToken);
            }
            return newAccessToken;
          }
        }
      } catch (e) {
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
final loginControllerProvider = StateNotifierProvider.autoDispose<LoginController, LoginState>((ref) {
  return LoginController(
    ref.watch(authApiServiceProvider),
    ref.watch(tokenServiceProvider),
  );
});

// --- CONTROLLER ---

class LoginController extends StateNotifier<LoginState> {
  final AuthApiService _authApiService;
  final TokenService _tokenService;

  LoginController(this._authApiService, this._tokenService) : super(const LoginInitial());

  Future<void> login({required String email, required String password}) async {
    state = const LoginLoading();

    final result = await _authApiService.login(email: email, password: password);

    await result.when(
      success: (data) async {
        try {
          // Save Access and Refresh Tokens securely
          await _tokenService.saveToken(data.response.tokens.access.token);
          await _tokenService.saveRefreshToken(data.response.tokens.refresh.token);

          // Save non-sensitive metadata (user_id, email, name, and avatar) to SharedPreferences
          await _tokenService.saveUserId(data.response.data.id);
          await _tokenService.saveUserEmail(data.response.data.email);
          await _tokenService.saveUserName(data.response.data.name);
          await _tokenService.saveUserAvatar(data.response.data.avatar);

          state = LoginSuccess(data);
        } catch (e) {
          state = LoginFailure(const UnknownException('Failed to save authentication session.'));
        }
      },
      failure: (error) async {
        state = LoginFailure(error);
      },
    );
  }

  void reset() => state = const LoginInitial();
}