import '../BaseException.dart';

@Deprecated('This will be removed as of version 1.1.0')

/// Exception that is thrown if the module run queue is blocking execution
class NoRunnableModuleException extends BaseException {
  /// Constructor that creates a Exception with given message
  NoRunnableModuleException(String message) : super(message);
}
