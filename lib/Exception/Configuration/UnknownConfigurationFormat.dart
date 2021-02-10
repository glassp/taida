import '../BaseException.dart';

/// Exception that is thrown if the configuration has a unknown file format
class UnknownConfigurationFormatException extends BaseException {
  /// Constructor that creates a Exception with given message
  UnknownConfigurationFormatException(String message) : super(message);
}
