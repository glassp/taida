import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/core/log/Logger.dart';
import 'package:taida/modules/Module.dart';
import 'package:taida/taida.dart';

class DartModule extends Module {
  @override
  bool canHandleCommand(String command) => true;

  @override
  bool canRun(List<Module> queue) => true;

  @override
  String get description => 'Compiles, formates and lints dart files';

  @override
  LogLabel get logLabel => LogLabel(
      name,
      AnsiPen()
        ..blue(bg: true)
        ..black());

  @override
  String get name => 'dart';

  void _build(Configuration config) async {
    for (var task in config.moduleConfiguration['dart']) {
      var outputFile = task['output'].replaceAll(RegExp(r'(\.dart)?\.js$'), '');
      var cacheBusterSuffix = config.enableCacheBuster ? '-${config.buildHash}' : '';
      Logger.verbose('Creating File ${config.projectRoot}/${outputFile}${cacheBusterSuffix}.dart.js');
      var process = await Process.run('dart', [
        'compile',
        'js',
        if (!config.debug) '-m',
        '-o',
        '${config.projectRoot}/${outputFile}${cacheBusterSuffix}.dart.js',
        '${config.projectRoot}/${task['entry']}'
      ]);
      print(process.exitCode);
      print(process.stderr);
    }
  }

  @override
  void run(String command) async {
    var config = ConfigurationLoader.load();
    var args = <String>[];
    var outputFile =
        '${config.projectRoot}/taida/${command}/dart-report-${config.buildHash}.txt';

    Logger.debug(
        'Running module dart with configuration ${config.moduleConfiguration['dart']} in ${command} mode');

    switch (command) {
      case 'build':
        _build(config);
        return;
      case 'analyze':
        args = [
          command,
          '--fatal-infos',
          config.projectRoot,
          '>${outputFile}',
          '2>&1'
        ];
        break;
      case 'format':
        args = [command, config.projectRoot];
        break;
      case 'test':
        args = [
          command,
          config.projectRoot,
          '--file-reporter',
          'expanded:${outputFile}'
        ];
        break;
      default:
        return;
    }

    var process = await Process.run('dart', args);
    if (process.exitCode != 0) {
      Logger.log(logLabel, 'Some test failed. See report at ${outputFile}');
    } else {
      Logger.log(logLabel, 'Task completed successfully');
    }
  }
}
