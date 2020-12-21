import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/core/log/Logger.dart';

/// Abstraction for a Module.
/// Every [Module] should expose a class named "TaidaModule" which will be loaded.
abstract class Module {
  /// Returns a [LogLabel] that is used when logging to the console using [Module.log()]
  LogLabel get logLabel;

  /// This is used to identify and compare [Module]s
  String get name;

  /// This is used to check if a [Module] can run its code at this point in time or not.
  /// The queue of pending modules is passed to `queue`
  /// The executed command is passed to `command`.
  bool canRun(
    List<Module> queue,
  );

  bool canHandleCommand(String command);

  /// Executes the Tasks for this [Module].
  /// The executed command is passed to `command`.
  void run(String command);

  /// Utility function to log messages.
  void log(String message) => Logger.log(logLabel, message);

  @override
  String toString() => name;

  @override
  bool operator ==(other) => name == other.name;
}