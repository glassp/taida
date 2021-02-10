/// This is a [Error] that is thrown if the Environment does
/// not meet the Programs criteria.
/// This should not be catched.
class EnvironmentError extends Error {
  /// The message of this Error to be printed
  final String message;

  /// Constructor that creates a Error with given message
  EnvironmentError([this.message]);

  @override
  String toString() {
    if (message != null) {
      return 'EnvironmentError: ${Error.safeToString(message)}';
    }
    return 'EnvironmentError';
  }
}
