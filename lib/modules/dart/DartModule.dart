import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:html/dom.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/core/log/Logger.dart';
import 'package:taida/modules/Module.dart';
import 'package:taida/util/ModuleContent.dart';
import 'package:taida/taida.dart';
import 'package:watcher/watcher.dart';

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
    for (var task in moduleConfiguration) {
      var outputFile = task['output'].replaceAll(RegExp(r'(\.dart)?\.js$'), '');
      var cacheBusterSuffix =
          config.enableCacheBuster ? '-${config.buildHash}' : '';
      Logger.verbose(
          'Creating File ${config.outputDirectory}/${outputFile}${cacheBusterSuffix}.dart.js');
      await Process.run('dart', [
        'compile',
        'js',
        if (!config.debug) '-m',
        '-o',
        '${config.outputDirectory}/${outputFile}${cacheBusterSuffix}.dart.js',
        '${config.projectRoot}/${task['entry']}'
      ]);
      var element = Element.tag('script');
      element.attributes.addAll({
        'src':
            '${config.outputDirectory}/${outputFile}${cacheBusterSuffix}.dart.js',
        'type': 'application/javascript'
      });
      ModuleContent.registerContent(element, false);
    }
  }

  @override
  void run(String command) async {
    var config = ConfigurationLoader.load();
    var args = <String>[];
    var outputFile =
        '${config.projectRoot}/taida/${command}/dart-report-${config.buildHash}.txt';

    Logger.debug(
        'Running module dart with configuration ${moduleConfiguration} in ${command} mode');

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

  @override
  List<Watcher> get watchers {
    var config = ConfigurationLoader.load();
    return [
      DirectoryWatcher('${config.projectRoot}/assets/dart',
          pollingDelay: Duration(seconds: 5))
    ];
  }
}
