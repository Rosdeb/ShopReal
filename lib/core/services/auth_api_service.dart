import 'package:messageapp/Features/auth/data/models/login_response.dart';
import 'api_client.dart';
import 'api_endpoints.dart';
import 'api_result.dart';

class AuthApiService {
  final ApiClient _client;
  AuthApiService(this._client);

  Future<ApiResult<LoginResponse>> login({
    required String email,
    required String password,
  }) {
    return _client.post<LoginResponse>(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
      parser: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResult<LoginResponse>> loginWithOAuth({
    required String provider,
    required String oAuthToken,
    String? fcmToken,
  }) {
    return _client.post<LoginResponse>(
      ApiEndpoints.loginOAuth,
      data: {
        'provider': provider,
        'oAuthToken': oAuthToken,
        if (fcmToken != null && fcmToken.isNotEmpty) 'fcmToken': fcmToken,
      },
      parser: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResult<LoginResponse>> loginWithGoogle({
    required String oAuthToken,
    String? fcmToken,
  }) {
    return loginWithOAuth(
      provider: 'google',
      oAuthToken: oAuthToken,
      fcmToken: fcmToken,
    );
  }

  Future<ApiResult<LoginResponse>> loginWithApple({
    required String oAuthToken,
    String? fcmToken,
  }) {
    return loginWithOAuth(
      provider: 'apple',
      oAuthToken: oAuthToken,
      fcmToken: fcmToken,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> register({
    required String email,
    required String password,
    String? name,
  }) {
    return _client.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: {
        'email': email,
        'password': password,
        if (name != null && name.isNotEmpty) 'name': name,
        'role': 'user',
      },
      parser: (json) => json is Map<String, dynamic>
          ? json
          : <String, dynamic>{'raw': json},
    );
  }

  Future<ApiResult<Map<String, dynamic>>> verifyAccount({
    required String email,
    required String code,
  }) {
    return _client.post<Map<String, dynamic>>(
      ApiEndpoints.verifyAccount,
      data: {
        'email': email,
        'code': code,
      },
      parser: (json) => json is Map<String, dynamic>
          ? json
          : <String, dynamic>{'raw': json},
    );
  }

  Future<ApiResult<Map<String, dynamic>>> resendOtp({
    required String email,
  }) {
    return _client.post<Map<String, dynamic>>(
      ApiEndpoints.resendOtp,
      data: {'email': email},
      parser: (json) => json is Map<String, dynamic>
          ? json
          : <String, dynamic>{'raw': json},
    );
  }

  Future<ApiResult<Map<String, dynamic>>> forgotPassword({
    required String email,
  }) {
    return _client.post<Map<String, dynamic>>(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
      parser: (json) => json is Map<String, dynamic>
          ? json
          : <String, dynamic>{'raw': json},
    );
  }

  Future<ApiResult<Map<String, dynamic>>> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) {
    return _client.post<Map<String, dynamic>>(
      ApiEndpoints.resetPassword,
      data: {
        'email': email,
        'otp': otp,
        'password': password,
      },
      parser: (json) => json is Map<String, dynamic>
          ? json
          : <String, dynamic>{'raw': json},
    );
  }

  Future<ApiResult<Map<String, dynamic>>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    return _client.post<Map<String, dynamic>>(
      ApiEndpoints.changePassword,
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
      parser: (json) => json is Map<String, dynamic>
          ? json
          : <String, dynamic>{'raw': json},
    );
  }

  Future<ApiResult<Map<String, dynamic>>> logout({String? refreshToken}) {
    return _client.post<Map<String, dynamic>>(
      ApiEndpoints.logout,
      data: {
        if (refreshToken != null && refreshToken.isNotEmpty)
          'refreshToken': refreshToken,
      },
      parser: (json) => json is Map<String, dynamic>
          ? json
          : <String, dynamic>{'raw': json},
    );
  }
}
