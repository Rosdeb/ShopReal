/// Keep every path here so a backend route change is a one-line fix.
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.yourapp.com/v1';

  // Auth
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String register = '/auth/register';

  // Example resource
  static const String profile = '/users/me';
  static String userById(String id) => '/users/$id';
}
