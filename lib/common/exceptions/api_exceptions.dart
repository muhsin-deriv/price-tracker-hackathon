class ApiDisconnectException implements Exception {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  ApiDisconnectException({
    this.error,
    this.message = '',
    this.stackTrace,
  }) : super();
}
