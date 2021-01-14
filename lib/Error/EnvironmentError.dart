/// This is a [Error] that is thrown if the Environment does not meet the Programs criteria.
/// This should not be catched.
class EnvironmentError extends Error {
  final String message;

  EnvironmentError([this.message]);

  @override
  String toString() {
    if (message != null) {
      return 'EnvironmentError: ${Error.safeToString(message)}';
    }
    return 'EnvironmentError';
  }
}
