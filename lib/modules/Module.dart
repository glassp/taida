import 'package:taida/core/execution/Phase.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/core/log/Logger.dart';
import 'package:watcher/watcher.dart';

/// Abstraction for a Module.
/// Every [Module] should expose a class named "TaidaModule" which will be loaded.
abstract class Module {
  /// Returns a [LogLabel] that is used when logging to the console using [Module.log()]
  LogLabel get logLabel;

  /// This is used to identify and compare [Module]s
  String get name;

  /// This is used by the module command to display a list of [Modules] and their description
  String get description;

  /// This is used to check if a [Module] can run its code at this point in time or not.
  /// The queue of pending modules is passed to `queue`
  /// The executed command is passed to `command`.
  @Deprecated('Replaced by executionTime')
  bool canRun(
    List<Module> queue,
  );

  /// returns the phase the module should be executed in
  Phase get executionTime;

  /// checks if the [Module] can handle the given `command`
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

  /// Returns a list of [Watcher] that check for changes and are used to rerun the tasks in the module.
  List<Watcher> get watchers;

  bool get isConfigured;
}
