import '../api_client.dart';
import '../api_endpoints.dart';
import '../api_result.dart';

/// Example of a feature-level service. Every real service in the app
/// follows this exact shape: thin wrapper around ApiClient + a parser.
class AuthApiService {
  final ApiClient _client;
  AuthApiService(this._client);

  Future<ApiResult<LoginResponse>> login({
    required String email,
    required String password,
  }) {
    return _client.post<LoginResponse>(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
      parser: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;

  LoginResponse({required this.accessToken, required this.refreshToken, required this.userId});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
        userId: json['user_id'] as String,
      );
}

/* ---------------------------------------------------------------------
   USAGE FROM A CONTROLLER (GetX) OR NOTIFIER (Riverpod) — same either way:

   final result = await authApiService.login(email: email, password: password);

   result.when(
     success: (data) {
       // save tokens, navigate, update state
     },
     failure: (error) {
       switch (error) {
         case ValidationException e:
           showFieldErrors(e.errors);       // e.g. e.fieldError('email')
         case OfflineException e:
           showSnackbar(e.message);         // "No internet connection..."
         case UnauthorizedException e:
           showSnackbar(e.message);
         case ServerException e:
           showSnackbar(e.message);
         default:
           showSnackbar(error.message);
       }
     },
   );
   --------------------------------------------------------------------- */
