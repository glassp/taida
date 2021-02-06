import 'dart:async';
import 'dart:io';

import 'package:taida/Error/EnvironmentError.dart';
import 'package:taida/Exception/Module/ExecutionException.dart';
import 'package:taida/_taida.dart';
import 'package:taida/core/config/ConfigurationLoader.dart';
import 'package:taida/core/execution/Phase.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/core/log/Logger.dart';
import 'package:taida/modules/Module.dart';
import 'package:taida/modules/ModuleLoader.dart';
import 'package:watcher/watcher.dart';

class ModuleRunner {
  final List<Module> queue = [];
  final Map<Watcher, Module> _watchers = {};
  final List<StreamSubscription> _streamSubscribers = [];

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
          _streamSubscribers.forEach((subscription) => subscription.cancel());
          _streamSubscribers.clear();
          run(command);
        });
        _streamSubscribers.add(subscriber);
      }
      ProcessSignal.sigint.watch().listen((_) {
        Logger.emptyLines();
        Logger.verbose('SIGINT detected. Terminating all watcher');
        _streamSubscribers.forEach((subscription) => subscription.cancel());
        _streamSubscribers.clear();
        Logger.verbose('Terminated all watchers. Now terminating program');
        var config = ConfigurationLoader.load();
        Logger.verbose('Removing temporary files');
        Directory(config.workingDirectory).deleteSync(recursive: true);
        Logger.emptyLines();
        var diff = DateTime.now().difference(TAIDA_EXECUTION_START);
        var timeDiff =
            '${diff.inHours}h ${diff.inMinutes}m ${diff.inSeconds}s ${diff.inMilliseconds}ms';

        Logger.log(LogLabel.success, 'Build completed successful in $timeDiff');
        exit(0);
      });
    }
  }

  /// checks if the dependencies were installed for this library version
  Future<bool> _npmDependenciesAreOutdated() async {
    var installVersionFile = File(TAIDA_LIBRARY_ROOT + '/installVersion.txt');
    if (!await installVersionFile.exists()) return true;
    var installVersion = await installVersionFile.readAsString();
    return installVersion != TAIDA_LIBRARY_VERSION;
  }

  /// checks if the npm dependencies are up-to-date and reinstalls them if necessary
  void installRequiredNpmDependencies() async {
    var process = await Process.run('node', ['-v']);
    var nodeInstalled = (await process.exitCode) == 0;

    if (!nodeInstalled) {
      throw EnvironmentError(
          'NodeJS/ npm must be in your path to use this tool.');
    }

    var nodeModulesDir = Directory(TAIDA_LIBRARY_ROOT + '/node_modules');
    if (await _npmDependenciesAreOutdated()) {
      await nodeModulesDir.delete(recursive: true);
    }
    if (await nodeModulesDir.exists()) return;

    Logger.verbose(
        'Installing node dependencies to ${TAIDA_LIBRARY_ROOT}/node_modules');
    await Process.run('npm', ['install'], workingDirectory: TAIDA_LIBRARY_ROOT);
    await (await File(TAIDA_LIBRARY_ROOT + '/installVersion.txt').create())
        .writeAsString(TAIDA_LIBRARY_VERSION);
  }
}
