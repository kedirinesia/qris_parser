class QrisError implements Exception {
  final String message;
  QrisError(this.message);

  @override
  String toString() => 'QrisError: $message';
}

class InvalidFormatError extends QrisError {
  InvalidFormatError(super.message);
}

class InvalidCrcError extends QrisError {
  InvalidCrcError(super.message);
}
