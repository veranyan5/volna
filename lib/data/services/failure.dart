class Failure {
  final String message;
  final int? code;

  Failure(this.message, {this.code});

  @override
  String toString() => 'Failure(code: $code, message: $message)';
}