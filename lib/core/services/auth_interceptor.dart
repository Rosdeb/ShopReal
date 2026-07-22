import 'package:dio/dio.dart';

/// Attaches the auth token to every request and transparently refreshes it
/// on a 401, retrying the original request once.
///
/// Plug in your own token storage (flutter_secure_storage recommended) and
/// your own refresh-token API call where marked below.
class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final Future<String?> Function() getAccessToken;
  final Future<String?> Function() refreshAccessToken;
  final Future<void> Function() onRefreshFailed; // e.g. force logout

  bool _isRefreshing = false;
  final List<void Function(String?)> _pendingRequests = [];

  AuthInterceptor(
    this._dio, {
    required this.getAccessToken,
    required this.refreshAccessToken,
    required this.onRefreshFailed,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isRetry = err.requestOptions.extra['retried'] == true;

    if (!isUnauthorized || isRetry) {
      handler.next(err);
      return;
    }

    // Queue concurrent 401s while one refresh call is in flight.
    if (_isRefreshing) {
      _pendingRequests.add((newToken) async {
        if (newToken == null) {
          handler.next(err);
        } else {
          handler.resolve(await _retry(err.requestOptions, newToken));
        }
      } as void Function(String?));
      return;
    }

    _isRefreshing = true;
    try {
      final newToken = await refreshAccessToken();
      _isRefreshing = false;

      if (newToken == null) {
        await onRefreshFailed();
        for (final cb in _pendingRequests) {
          cb(null);
        }
        _pendingRequests.clear();
        handler.next(err);
        return;
      }

      for (final cb in _pendingRequests) {
        cb(newToken);
      }
      _pendingRequests.clear();

      handler.resolve(await _retry(err.requestOptions, newToken));
    } catch (_) {
      _isRefreshing = false;
      await onRefreshFailed();
      for (final cb in _pendingRequests) {
        cb(null);
      }
      _pendingRequests.clear();
      handler.next(err);
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions, String newToken) {
    requestOptions.headers['Authorization'] = 'Bearer $newToken';
    requestOptions.extra['retried'] = true;
    return _dio.fetch(requestOptions);
  }
}
