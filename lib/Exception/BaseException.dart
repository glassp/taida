/// Abstraction for Exceptions.
abstract class BaseException implements Exception {
  /// The message of this Exception to be printed
  final String message;

  /// Constructor that creates a Exception with given message
  BaseException([this.message]);

  @override
  String toString() {
    Object message = this.message;
    if (message == null) return 'Exception';
    return 'Exception: $message';
  }
}
