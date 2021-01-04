import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/core/log/Logger.dart';
import 'package:taida/modules/Module.dart';
import 'package:taida/taida.dart';
import 'package:sass/sass.dart' as sass;

class ScssModule extends Module {
  @override
  bool canHandleCommand(String command) {
      return 'build' == command;
    }
  
    @override
    bool canRun(List<Module> queue) {
      return true;
    }
  
    @override
    LogLabel get logLabel => LogLabel('SCSS', AnsiPen()..magenta(bg: true));
  
    @override
    String get name => 'scss';
  
    @override
    void run(String command) async {
      // TODO add watch mode
      var config = ConfigurationLoader.load();
      var moduleConfig = config.moduleConfiguration[name];
      Logger.debug('Running module $name with configuration $moduleConfig');
      for (var task in moduleConfig) {
        var source = File('${config.projectRoot}/${task['entry']}');
        if (!await source.exists()) {
          Logger.warn('${source.path} does not exist. Skipping...');
          continue;
        }
        var css = sass.compile(task['entry']);
        var outputFile = File('${config.projectRoot}/${task['output']}');
        if (!await outputFile.exists()) {
          Logger.verbose('Creating File ${outputFile.path}');
          await outputFile.create(recursive: true);
        }
        await outputFile.writeAsString(css);
      }
  }

}