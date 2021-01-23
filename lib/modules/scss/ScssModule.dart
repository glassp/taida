import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:html/dom.dart';
import 'package:taida/Exception/Failure/FailureException.dart';
import 'package:taida/_taida.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/core/log/Logger.dart';
import 'package:taida/modules/Module.dart';
import 'package:taida/modules/html/ModuleContent.dart';
import 'package:taida/taida.dart';
import 'package:sass/sass.dart' as sass;
import 'package:watcher/watcher.dart';

class ScssModule extends Module {
  @override
  bool canHandleCommand(String command) {
    return 'build' == command || 'analyze' == command;
  }

  @override
  bool canRun(List<Module> queue) {
    return true;
  }

  @override
  LogLabel get logLabel => LogLabel(
      'SCSS',
      AnsiPen()
        ..magenta(bg: true)
        ..black());

  @override
  String get name => 'scss';

  @override
  void run(String command) async {
    var config = ConfigurationLoader.load();
    var moduleConfig = config.moduleConfiguration[name];
    Logger.debug(
        'Running module $name with configuration $moduleConfig in $command mode.');
    switch (command) {
      case 'build':
        await _build(config);
        break;
      case 'analyze':
        await _analyze(config);
        break;
      default:
        return;
    }
  }

  /// The code that gets executed for the build command
  void _build(Configuration config) async {
    var moduleConfig = config.moduleConfiguration[name];
    for (var task in moduleConfig) {
      var source = File('${config.projectRoot}/${task['entry']}');
      if (!await source.exists()) {
        Logger.warn('${source.path} does not exist. Skipping...');
        continue;
      }

      var css = sass.compile(task['entry']);
      var cacheBusterSuffix =
          config.enableCacheBuster ? '-${config.buildHash}' : '';
      var filename = task['output'].replaceAll(RegExp(r'\.css$'), '');
      var outputFile =
          File('${config.outputDirectory}/${filename}${cacheBusterSuffix}.css');

      if (!await outputFile.exists()) {
        Logger.verbose('Creating File ${outputFile.path}');
        await outputFile.create(recursive: true);
      }
      var element = Element.tag('link');
      element.attributes.addAll({
        'href': outputFile.absolute.path,
        'rel': 'stylesheet',
        'type': 'text/css',
        if (task.containsKey('media')) 'media': task['media']
      });
      ModuleContent.registerContent(element);
      await outputFile.writeAsString(css);
    }
  }

  /// The code that gets executed for the analyze command
  void _analyze(Configuration config) async {
    var stylelintConfig = config.projectRoot + '/.stylelintrc';
    if (!await File(stylelintConfig).exists()) {
      stylelintConfig = TAIDA_LIBRARY_ROOT + '/config/.stylelintrc.yaml';
    }
    Logger.log(logLabel, 'Using stylelint config from: ${stylelintConfig}');
    var analyzeDir = Directory(config.projectRoot + '/taida/analyze');
    if (!await analyzeDir.exists()) await analyzeDir.create(recursive: true);

    var process = await Process.run(
        'npx',
        [
          'stylelint',
          '--config',
          '${stylelintConfig}',
          '--output-file',
          '${config.projectRoot}/taida/analyze/stylelint-report-${config.buildHash}.txt',
          '${config.projectRoot}/assets/**/*.scss'
        ],
        workingDirectory: TAIDA_LIBRARY_ROOT);
    var exitcode = await process.exitCode;
    switch (exitcode) {
      case 0:
        return;
      case 1:
        Logger.error('Something went wrong while SCSS linted your files.');
        throw FailureException(await process.stderr.toString());
      case 2:
        Logger.log(logLabel,
            'Some stylelint rules failed. See report at ${config.projectRoot}/taida/analyze/stylelint-report-${config.buildHash}.txt');
        return;
      case 78:
        Logger.log(
            logLabel, 'Could not parse configuration ${stylelintConfig}.');
        throw FailureException(await process.stderr.toString());
    }
  }

  @override
  String get description => 'Compiles and lints scss/sass files';

  @override
  List<Watcher> get watchers {
    var config = ConfigurationLoader.load();
    return [
      DirectoryWatcher('${config.projectRoot}/assets/scss',
          pollingDelay: Duration(seconds: 5))
    ];
  }
}
