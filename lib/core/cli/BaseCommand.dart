import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:taida/core/execution/ModuleRunner.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/modules/Module.dart';
import 'package:args/command_runner.dart';
import 'package:taida/core/config/ConfigurationLoader.dart';
import 'package:taida/core/log/Logger.dart';
import 'package:watcher/watcher.dart';

/// Abstraction for the Commands that can be invoked for the taida command.
abstract class BaseCommand extends Command {
  final Map<Watcher, Module> _watchers = {};
  final List<StreamSubscription> _streamSubscribers = [];

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

  @override
  @nonVirtual
  void run() async {
    var runner = ModuleRunner();
    Logger.log(LogLabel.config, 'Reading configuration from terminal command.');
    var cliConfig = prepareConfigurationFromCli();
    ConfigurationLoader.cliOptions = cliConfig;
    var config = ConfigurationLoader.load();

    var buildFile = File('${config.projectRoot}/taida/build.hash');
    if (!await buildFile.exists()) await buildFile.create();
    await buildFile.writeAsString(config.buildHash);

    if (name == 'build') {
      Logger.emptyLines();
      Logger.verbose('Removing old output');

      var outputDir = Directory(config.outputDirectory);
      if (await outputDir.exists()) await outputDir.delete(recursive: true);
    }
    await runner.installRequiredNpmDependencies();
    await runner.run(name);
    if (!config.watch) {
      Logger.verbose('Removing temporary files');
      Directory('${config.projectRoot}/taida/workDir')
          .deleteSync(recursive: true);
    }
  }
}
