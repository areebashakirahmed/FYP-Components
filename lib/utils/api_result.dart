/// Generic result class for API calls
/// Handles both success and error states
class ApiResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  ApiResult._({this.data, this.error, required this.isSuccess});

  factory ApiResult.success(T data) {
    return ApiResult._(data: data, isSuccess: true);
  }

  factory ApiResult.failure(String error) {
    return ApiResult._(error: error, isSuccess: false);
  }

  /// Map the result to another type
  ApiResult<R> map<R>(R Function(T data) mapper) {
    if (isSuccess && data != null) {
      return ApiResult.success(mapper(data as T));
    }
    return ApiResult.failure(error ?? 'Unknown error');
  }

  /// Execute callback based on result state
  void when({
    required void Function(T data) success,
    required void Function(String error) failure,
  }) {
    if (isSuccess && data != null) {
      success(data as T);
    } else {
      failure(error ?? 'Unknown error');
    }
  }
}

/// API Exception for handling errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
