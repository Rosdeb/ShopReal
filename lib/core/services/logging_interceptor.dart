import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

/// Minimal, dependency-free request/response logger. Only prints in debug mode.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(' [${options.method}] ${options.uri}');
      if (options.data != null) debugPrint('   body: ${_safeEncode(options.data)}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(' [${response.statusCode}] ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(' [${err.response?.statusCode}] ${err.requestOptions.uri} — ${err.message}');
      if (err.response?.data != null) debugPrint('   response: ${_safeEncode(err.response!.data)}');
    }
    handler.next(err);
  }

  String _safeEncode(dynamic data) {
    try {
      return jsonEncode(data);
    } catch (_) {
      return data.toString();
    }
  }
}
