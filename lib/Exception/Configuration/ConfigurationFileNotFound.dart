import '../BaseException.dart';

/// Exception that is thrown if the configuration cannot be found
class ConfigurationNotFoundException extends BaseException {
  /// Constructor that creates a Exception with given message
  ConfigurationNotFoundException(String message) : super(message);
}
