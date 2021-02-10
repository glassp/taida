import '../BaseException.dart';

/// Exception that will halt the further Execution and 
/// print the provided Message.
/// Throwing this also causes the Program to terminate with exit code 1.
class FailureException extends BaseException {
  /// Constructor that creates a Exception with given message
  FailureException(String message) : super(message);
}
