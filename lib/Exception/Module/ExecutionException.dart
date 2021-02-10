import '../BaseException.dart';

/// Exception that is thrown if there was a error within the module execution
class ExecutionException extends BaseException {
  /// Constructor that creates a Exception with given message
  ExecutionException(String message) : super(message);
}
