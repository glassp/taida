import 'package:taida/Exception/BaseException.dart';

/// Exception that will halt the further Execution and print the provided Message.
/// Throwing this also causes the Program to terminate with exit code 1.
class FailureException extends BaseException {
  FailureException(String message) : super(message);
}
