/// Base class for every failure that can come out of the network layer.
/// UI code should only ever branch on these — never on DioException directly.
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// No internet connection at all (checked before the request is even sent).
class OfflineException extends AppException {
  const OfflineException([super.message = 'No internet connection. Please check your network.']);
}

/// Request timed out (connect / send / receive).
class TimeoutException extends AppException {
  const TimeoutException([super.message = 'The request timed out. Please try again.']);
}

/// 422 (or 400 with field errors) — validation failed on the server.
/// [errors] is field -> list of messages, e.g. {"email": ["Email is already taken"]}
class ValidationException extends AppException {
  final Map<String, List<String>> errors;
  const ValidationException(this.errors, [super.message = 'Please fix the highlighted fields.']);

  /// Flattened list, handy for showing a snackbar/toast.
  List<String> get allMessages => errors.values.expand((e) => e).toList();

  /// First error for a given field, handy for inline form validation.
  String? fieldError(String field) => errors[field]?.first;
}

/// 401 — token missing/expired/invalid.
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Your session has expired. Please log in again.']);
}

/// 403 — authenticated but not allowed.
class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'You don\'t have permission to do that.']);
}

/// 404
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'The requested resource was not found.']);
}

/// 409 — conflict (duplicate entry, stale update, etc).
class ConflictException extends AppException {
  const ConflictException([super.message = 'This conflicts with existing data.']);
}

/// 429 — rate limited.
class RateLimitedException extends AppException {
  const RateLimitedException([super.message = 'Too many requests. Please slow down.']);
}

/// 5xx — something broke on the server.
class ServerException extends AppException {
  final int? statusCode;
  const ServerException(this.statusCode, [super.message = 'Something went wrong on our end. Please try again later.']);
}

/// Request was cancelled (e.g. user navigated away).
class RequestCancelledException extends AppException {
  const RequestCancelledException([super.message = 'Request was cancelled.']);
}

/// Response didn't parse the way we expected (bad JSON shape from backend).
class ParsingException extends AppException {
  const ParsingException([super.message = 'Could not read the server response.']);
}

/// Catch-all for anything that doesn't fit the above.
class UnknownException extends AppException {
  const UnknownException([super.message = 'An unexpected error occurred.']);
}


