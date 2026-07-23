/// Keep every path here so a backend route change is a one-line fix.
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://shopreal.xdtunnel.icu/api/v1';

  // Auth
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String register = '/auth/register';

  // Example resource
  static const String profile = '/user/self/in';
  static const String analysis = '/analyze';
  static const String notification = '/notification';
  static const String product_scan = '/products/scan';
  static const String get_product = '/products/{id}';
  static const String product_Analysis  = '/products/{id}/report';
  static const String product  = '/product'; //Query Parameters: q / query (String, required)


  static String userById(String id) => '/users/$id';
}
