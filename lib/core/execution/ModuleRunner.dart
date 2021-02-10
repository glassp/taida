import 'dart:async';
import 'dart:io';

import 'package:watcher/watcher.dart';

import '../../Error/EnvironmentError.dart';
import '../../Exception/Module/ExecutionException.dart';
import '../../_taida.dart';
import '../../modules/Module.dart';
import '../../modules/ModuleLoader.dart';
import '../../util/Pubspec.dart';
import '../config/ConfigurationLoader.dart';
import '../execution/Phase.dart';
import '../log/LogLabel.dart';
import '../log/Logger.dart';

/// Runner that executes all modules
class ModuleRunner {
  /// List of modules that have to be run
  final List<Module> queue = [];

  /// Watchers that trigger a reexecution
  final Map<Watcher, Module> _watchers = {};

  /// stream subscribers that listen on the watchers
  final List<StreamSubscription> _streamSubscribers = [];

  /// create a queue of modules that have to run
  void createModuleQueue() {
    var registeredModules = ModuleLoader.registeredModules;

    for (var module
        in registeredModules.values.toSet().toList(growable: false)) {
      queue.add(module);
      for (var watcher in module.watchers) {
        _watchers.putIfAbsent(watcher, () => module);
      }
    }
  }

  /// execute all modules with given command
  void run(String command) async {
    await createModuleQueue();
    var config = ConfigurationLoader.load();
    for (var phase in Phase.values) {
      Logger.debug('Running phase $phase');
      for (var module in List<Module>.unmodifiable(queue)) {
        if (module.executionTime.index == phase.index) {
          await module.run(command);
          queue.remove(module);
        }
      }
    }
    if (queue.isNotEmpty) {
      throw ExecutionException('Not all Modules could be run.');
    }
    if (config.watch && _streamSubscribers.isEmpty) {
      Logger.verbose('Starting to watch files as defined by modules');
      for (var watcher in _watchers.keys) {
        var subscriber = watcher.events.listen((event) {
          Logger.verbose('Terminating file watchers and reruning pipeline');
          for (var subscription in _streamSubscribers) {
            subscription.cancel();
          }
          _streamSubscribers.clear();
          run(command);
        });
        _streamSubscribers.add(subscriber);
      }
      ProcessSignal.sigint.watch().listen((_) {
        Logger.emptyLines();
        Logger.verbose('SIGINT detected. Terminating all watcher');
        for (var subscription in _streamSubscribers) {
          subscription.cancel();
        }
        _streamSubscribers.clear();
        Logger.verbose('Terminated all watchers. Now terminating program');
        var config = ConfigurationLoader.load();
        Logger.verbose('Removing temporary files');
        Directory(config.workingDirectory).deleteSync(recursive: true);
        Logger.emptyLines();
        var diff = DateTime.now().difference(TAIDA_EXECUTION_START);
        var timeDiff = '''${diff.inHours}h ${diff.inMinutes}m
            ${diff.inSeconds}s ${diff.inMilliseconds}ms''';

        Logger.log(LogLabel.success, 'Build completed successful in $timeDiff');
        exit(0);
      });
    }
  }

  /// checks if the dependencies were installed for this library version
  Future<bool> _npmDependenciesAreOutdated() async {
    var installVersionFile = File('$TAIDA_LIBRARY_ROOT/installVersion.txt');
    if (!await installVersionFile.exists()) return true;
    var installVersion = await installVersionFile.readAsString();
    return installVersion != Pubspec.taidaVersion;
  }

  /// checks if the npm dependencies are up-to-date and reinstalls
  /// them if necessary
  void installRequiredNpmDependencies() async {
    var process = await Process.run('node', ['-v']);
    var nodeInstalled = (await process.exitCode) == 0;

    if (!nodeInstalled) {
      throw EnvironmentError(
          'NodeJS/ npm must be in your path to use this tool.');
    }

    var nodeModulesDir = Directory('$TAIDA_LIBRARY_ROOT/node_modules');
    if (await _npmDependenciesAreOutdated()) {
      if (await nodeModulesDir.exists()) {
        await nodeModulesDir.delete(recursive: true);
      }
    }
    if (await nodeModulesDir.exists()) return;

    Logger.verbose(
        'Installing node dependencies to $TAIDA_LIBRARY_ROOT/node_modules');
    await Process.run('npm', ['install'], workingDirectory: TAIDA_LIBRARY_ROOT);
    await (await File('$TAIDA_LIBRARY_ROOT/installVersion.txt').create())
        .writeAsString(Pubspec.taidaVersion);
  }
}
