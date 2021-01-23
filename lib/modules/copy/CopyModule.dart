import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:taida/core/config/ConfigurationLoader.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/core/log/Logger.dart';
import 'package:taida/modules/Module.dart';
import 'package:taida/modules/copy/DirectoryCopy.dart';
import 'package:watcher/watcher.dart';

class CopyModule extends Module {
  @override
  bool canRun(List<Module> queue) {
    return true;
  }

  @override
  LogLabel get logLabel => LogLabel(name, AnsiPen()..magenta(bg: true));

  @override
  String get name => 'copy';

  @override
  void run(String command) async {
    if (command != 'build') return;
    var config = ConfigurationLoader.load();
    var moduleConfig = config.moduleConfiguration['copy'];
    Logger.debug('Running Module $name with configuration $moduleConfig');
    for (var task in moduleConfig) {
      var destination = Directory(config.outputDirectory + '/' + task['to']);
      for (var from in task['from']) {
        var source = Directory(config.projectRoot + '/' + from);
        await DirectoryCopy.copy(source, destination);
      }
    }
  }

  @override
  bool canHandleCommand(String command) => 'build' == command;

  @override
  String get description => 'Copies static assets to the output directory';

  @override
  List<Watcher> get watchers => [];
}
