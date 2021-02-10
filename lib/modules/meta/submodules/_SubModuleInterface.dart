part of '../MetaModule.dart';

abstract class _SubModuleInterface {
  void run(MetaConfiguration moduleConfiguration);

  /// Returns a list of [Watcher] that check for changes and are 
  /// used to rerun the tasks in the module.
  List<Watcher> get watchers;
}
