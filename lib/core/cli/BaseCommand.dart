import 'dart:io';

import 'package:meta/meta.dart';
import 'package:taida/Error/EnvironmentError.dart';
import 'package:taida/Exception/Module/NoRunnableModule.dart';
import 'package:taida/_taida.dart';
import 'package:taida/core/config/Configuration.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/modules/Module.dart';
import 'package:taida/modules/ModuleLoader.dart';
import 'package:args/command_runner.dart';
import 'package:taida/core/config/ConfigurationLoader.dart';
import 'package:taida/core/log/Logger.dart';

/// Abstraction for the Commands that can be invoked for the taida command.
abstract class BaseCommand extends Command {
  BaseCommand() {
    argParser
      ..addFlag('debug',
          abbr: 'd', defaultsTo: false, help: 'Enables debug information.')
      ..addFlag('verbose',
          abbr: 'v',
          negatable: false,
          defaultsTo: false,
          help:
              'Provides additional information to the debug information. Requires debug to be true.');
  }

  /// Parses the options passed to the CLI  and returns it as a key value map, where the keys SHOULD be snake_case.
  @protected
  Map<String, dynamic> prepareConfigurationFromCli() {
    var map = <String, dynamic>{'taida': <String, dynamic>{}};

    for (var option in argResults.options) {
      map['taida'].putIfAbsent(option, () => argResults[option]);
    }

    return map;
  }

  /// checks if the node_modules dir exists and if not it will run npm install
  /// Throws [EnvironmentError] if node/npm is not installed.
  void _install(Configuration config) async {
    var process = await Process.start('node', ['-v']);
    var nodeInstalled = (await process.exitCode) == 0;
    await process.kill();

    if (!nodeInstalled) {
      throw EnvironmentError(
          'NodeJS/ npm must be in your path to use this tool.');
    }

    var nodeModulesDir = Directory(TAIDA_LIBRARY_ROOT + '/node_modules');
    if (await _isOutdated()) {
      await nodeModulesDir.delete(recursive: true);
    }
    if (await nodeModulesDir.exists()) return;

    Logger.verbose(
        'Installing node dependencies to ${TAIDA_LIBRARY_ROOT}/node_modules');
    await Process.run('npm', ['install'], workingDirectory: TAIDA_LIBRARY_ROOT);
    await (await File(TAIDA_LIBRARY_ROOT + '/installVersion.txt').create()).writeAsString(TAIDA_LIBRARY_VERSION);
  }

  Future<bool> _isOutdated() async {
    var installVersionFile = File(TAIDA_LIBRARY_ROOT + '/installVersion.txt');
    if (!await installVersionFile.exists()) return true;
    var installVersion = await installVersionFile.readAsString();
    return installVersion != TAIDA_LIBRARY_VERSION;
  }

  /// Executes the command action on all Modules in the module queue
  void _execute() async {
    var queue = _createModuleQueue();
    while (queue?.isNotEmpty ?? false) {
      final shadow = List<Module>.from(queue);
      for (var module in shadow) {
        Logger.emptyLines();
        Logger.verbose('Try running Module $module...');
        // check if module has can execute at all for action.
        if (!module.canHandleCommand(name)) {
          queue.remove(module);
          continue;
        }
        if (module.canRun(List.of(queue))) {
          Logger.verbose('Running Module $module...');
          await module.run(name);
          Logger.verbose('module finished running');
          queue.remove(module);
        }
      }
      if (shadow.toString() == queue.toString()) {
        // no modification happend in the loop => infinite loop would occur
        throw NoRunnableModuleException('No module can be run anymore.');
      }
    }
  }

  /// Creates the run Queue of all Modules if they're defined in the config
  List<Module> _createModuleQueue() {
    var config = ConfigurationLoader.load();
    var queue = <Module>[];
    var registeredModules = ModuleLoader.registeredModules;

    // add all Modules only once
    for (String module in config.modules.toSet().toList()) {
      if (registeredModules.containsKey(module)) {
        queue.add(registeredModules[module]);
      }
    }
    return queue;
  }

  @override
  @nonVirtual
  void run() async {
    Logger.log(LogLabel.config, 'Reading configuration from terminal command.');
    var cliConfig = prepareConfigurationFromCli();
    ConfigurationLoader.cliOptions = cliConfig;
    var config = ConfigurationLoader.load();

    var buildFile = File('${config.projectRoot}/taida/build.hash');
    if (!await buildFile.exists()) await buildFile.create();
    await buildFile.writeAsString(config.buildHash);

    Logger.emptyLines();
    Logger.verbose('Removing old output');

    var outputDir =
        Directory('${config.projectRoot}/${config.outputDirectory}');
    if (outputDir.existsSync()) outputDir.deleteSync(recursive: true);
    await _install(config);
    await _execute();
    Logger.verbose('Removing temporary files');
    Directory('${config.projectRoot}/taida/workDir')
        .deleteSync(recursive: true);
  }
}
