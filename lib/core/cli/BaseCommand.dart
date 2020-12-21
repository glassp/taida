import 'package:meta/meta.dart';
import 'package:taida/Exception/Module/NoRunnableModule.dart';
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
    var map = <String, dynamic>{};

    for (var option in argResults.options) {
      if (argResults.wasParsed(option)) {
        map.putIfAbsent(option, () => argResults[option]);
      }
    }

    return map;
  }

  /// Executes the command action on all Modules in the module queue
  void _execute() async {
    var queue = _createModuleQueue();
    while (queue?.isNotEmpty ?? false) {
      final shadow = List.from(queue);
      for (var module in shadow) {
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
        print('');
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

  /// Runs the command.
  /// This will read the configuration and execute each module with this config.
  void run() async {
    Logger.verbose('Reading configuration from terminal command.');
    var config = prepareConfigurationFromCli();
    ConfigurationLoader.cliOptions = config;
    Logger.verbose('Reading configuration from configuration file.');
    ConfigurationLoader.load();
    print('');
    await _execute();
  }
}