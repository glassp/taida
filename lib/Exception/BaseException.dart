/// Abstraction for Exceptions.
abstract class BaseException implements Exception {
  final String message;

  BaseException([this.message]);

  @override
  String toString() {
    Object message = this.message;
    if (message == null) return 'Exception';
    return 'Exception: $message';
  }
}
