import '../BaseException.dart';

/// Exception that is thrown if the configuration format/syntax is not valid
class InvalidConfigurationFormatException extends BaseException {
  /// Constructor that creates a Exception with given message
  InvalidConfigurationFormatException(String message) : super(message);
}
