import 'package:dio/dio.dart';
import 'api_exceptions.dart';
import 'api_result.dart';
import 'auth_interceptor.dart';
import 'logging_interceptor.dart';
import 'network_info.dart';

/// Central place every network call in the app goes through.
///
/// - Checks connectivity before firing a request -> OfflineException
/// - Converts every DioException into a typed AppException
/// - Parses field-level validation errors (422) into ValidationException
/// - Returns ApiResult<T> so callers never need try/catch
class ApiClient {
  ApiClient._internal(this._dio, this._networkInfo);

  static ApiClient? _instance;

  /// Call once at app startup (e.g. in main() or a service locator setup).
  factory ApiClient.init({
    required String baseUrl,
    required NetworkInfo networkInfo,
    Future<String?> Function()? getAccessToken,
    Future<String?> Function()? refreshAccessToken,
    Future<void> Function()? onRefreshFailed,
    Map<String, dynamic>? defaultHeaders,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 20),
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        sendTimeout: connectTimeout,
        headers: defaultHeaders ?? {'Accept': 'application/json'},
      ),
    );

    if (getAccessToken != null && refreshAccessToken != null && onRefreshFailed != null) {
      dio.interceptors.add(AuthInterceptor(
        dio,
        getAccessToken: getAccessToken,
        refreshAccessToken: refreshAccessToken,
        onRefreshFailed: onRefreshFailed,
      ));
    }
    dio.interceptors.add(LoggingInterceptor());

    _instance = ApiClient._internal(dio, networkInfo);
    return _instance!;
  }

  /// Access after init() has been called once.
  static ApiClient get instance {
    if (_instance == null) {
      throw StateError('ApiClient.init() must be called before ApiClient.instance is used.');
    }
    return _instance!;
  }

  final Dio _dio;
  final NetworkInfo _networkInfo;

  /// Expose raw Dio only for edge cases (file upload progress, etc.)
  Dio get raw => _dio;

  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) parser,
    CancelToken? cancelToken,
  }) =>
      _request(() => _dio.get(path, queryParameters: queryParameters, cancelToken: cancelToken), parser);

  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) parser,
    CancelToken? cancelToken,
  }) =>
      _request(() => _dio.post(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken), parser);

  Future<ApiResult<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) parser,
    CancelToken? cancelToken,
  }) =>
      _request(() => _dio.put(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken), parser);

  Future<ApiResult<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) parser,
    CancelToken? cancelToken,
  }) =>
      _request(() => _dio.patch(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken), parser);

  Future<ApiResult<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) parser,
    CancelToken? cancelToken,
  }) =>
      _request(() => _dio.delete(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken), parser);

  /// Multipart upload helper (POST).
  Future<ApiResult<T>> upload<T>(
    String path, {
    required FormData formData,
    required T Function(dynamic json) parser,
    void Function(int sent, int total)? onSendProgress,
    CancelToken? cancelToken,
  }) =>
      _request(
        () => _dio.post(path, data: formData, onSendProgress: onSendProgress, cancelToken: cancelToken),
        parser,
      );

  /// Multipart upload helper (PATCH) — used for profile updates.
  Future<ApiResult<T>> uploadPatch<T>(
    String path, {
    required FormData formData,
    required T Function(dynamic json) parser,
    void Function(int sent, int total)? onSendProgress,
    CancelToken? cancelToken,
  }) =>
      _request(
        () => _dio.patch(path, data: formData, onSendProgress: onSendProgress, cancelToken: cancelToken),
        parser,
      );

  // ---- core plumbing ----

  Future<ApiResult<T>> _request<T>(
    Future<Response> Function() call,
    T Function(dynamic json) parser,
  ) async {
    if (!await _networkInfo.isConnected) {
      return ApiFailure<T>(const OfflineException());
    }

    try {
      final response = await call();
      try {
        return ApiSuccess<T>(parser(response.data));
      } catch (_) {
        return ApiFailure<T>(const ParsingException());
      }
    } on DioException catch (e) {
      return ApiFailure<T>(_mapDioException(e));
    } catch (_) {
      return ApiFailure<T>(const UnknownException());
    }
  }

  AppException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const OfflineException();
      case DioExceptionType.cancel:
        return const RequestCancelledException();
      case DioExceptionType.badResponse:
        return _mapStatusCode(e);
      case DioExceptionType.badCertificate:
        return const UnknownException('Security certificate error.');
      case DioExceptionType.unknown:
        return const UnknownException();
    }
  }

  AppException _mapStatusCode(DioException e) {
    final statusCode = e.response?.statusCode;
    final body = e.response?.data;

    switch (statusCode) {
      case 400:
      case 422:
        return _mapValidationError(body);
      case 401:
        return const UnauthorizedException();
      case 403:
        return const ForbiddenException();
      case 404:
        return const NotFoundException();
      case 409:
        return const ConflictException();
      case 429:
        return const RateLimitedException();
      default:
        if (statusCode != null && statusCode >= 500) {
          return ServerException(statusCode, _extractMessage(body) ?? 'Server error ($statusCode).');
        }
        return UnknownException(_extractMessage(body) ?? 'Unexpected error ($statusCode).');
    }
  }

  /// Adjust this to your backend's actual error shape.
  /// Handles two common shapes out of the box:
  ///   { "message": "...", "errors": { "email": ["..."] } }
  ///   { "message": "...", "errors": { "email": "..." } }
  ValidationException _mapValidationError(dynamic body) {
    final message = _extractMessage(body) ?? 'Validation failed.';
    final Map<String, List<String>> fieldErrors = {};

    if (body is Map && body['errors'] is Map) {
      (body['errors'] as Map).forEach((key, value) {
        if (value is List) {
          fieldErrors[key.toString()] = value.map((v) => v.toString()).toList();
        } else if (value != null) {
          fieldErrors[key.toString()] = [value.toString()];
        }
      });
    }

    return ValidationException(fieldErrors, message);
  }

  String? _extractMessage(dynamic body) {
    if (body is Map) {
      final msg = body['message'] ?? body['error'] ?? body['detail'];
      if (msg is String) return msg;
    }
    return null;
  }
}
