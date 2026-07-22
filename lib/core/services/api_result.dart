import 'api_exceptions.dart';

/// Every service method returns this instead of throwing.
/// Forces the UI layer to explicitly handle both branches.
sealed class ApiResult<T> {
  const ApiResult();

  bool get isSuccess => this is ApiSuccess<T>;
  bool get isFailure => this is ApiFailure<T>;

  /// Pattern-match helper — cleanest way to consume a result.
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  }) {
    final self = this;
    if (self is ApiSuccess<T>) return success(self.data);
    if (self is ApiFailure<T>) return failure(self.error);
    throw StateError('Unreachable');
  }

  /// Returns data on success, null on failure.
  T? get dataOrNull => this is ApiSuccess<T> ? (this as ApiSuccess<T>).data : null;
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiFailure<T> extends ApiResult<T> {
  final AppException error;
  const ApiFailure(this.error);
}
