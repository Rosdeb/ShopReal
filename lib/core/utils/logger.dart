import 'package:flutter/foundation.dart';

/// Logger utility for debugging
class Logger {
  Logger._(); // Private constructor to prevent instantiation

  /// Log debug message
  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[DEBUG]';
      debugPrint('$prefix $message');
    }
  }

  /// Log info message
  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[INFO]';
      debugPrint('$prefix $message');
    }
  }

  /// Log warning message
  static void warning(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[WARNING]';
      debugPrint('$prefix $message');
    }
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace, String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[ERROR]';
      debugPrint('$prefix $message');
      if (error != null) {
        debugPrint('$prefix Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('$prefix StackTrace: $stackTrace');
      }
    }
  }

  /// Log API request
  static void apiRequest(String method, String url, {Map<String, dynamic>? headers, dynamic body}) {
    if (kDebugMode) {
      debugPrint('[API REQUEST] $method $url');
      if (headers != null && headers.isNotEmpty) {
        debugPrint('[API REQUEST] Headers: $headers');
      }
      if (body != null) {
        debugPrint('[API REQUEST] Body: $body');
      }
    }
  }

  /// Log API response
  static void apiResponse(String method, String url, int statusCode, {dynamic body}) {
    if (kDebugMode) {
      debugPrint('[API RESPONSE] $method $url - Status: $statusCode');
      if (body != null) {
        debugPrint('[API RESPONSE] Body: $body');
      }
    }
  }

  /// Log API error
  static void apiError(String method, String url, dynamic error) {
    if (kDebugMode) {
      debugPrint('[API ERROR] $method $url');
      debugPrint('[API ERROR] Error: $error');
    }
  }
}
