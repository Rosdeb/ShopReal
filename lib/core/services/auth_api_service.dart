
import 'package:messageapp/core/services/api_client.dart';
import '../../Features/auth/data/models/login_response.dart';
import 'api_endpoints.dart';
import 'api_result.dart';
import 'package:messageapp/core/services/api_client.dart';
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
      parser: (json) => LoginResponse.fromJson(json),
    );
  }
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
