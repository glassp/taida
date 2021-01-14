import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:taida/core/config/ConfigurationLoader.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/core/log/Logger.dart';
import 'package:taida/modules/Module.dart';

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
      var destination = Directory(config.projectRoot + '/' + task['to']);
      for (var from in task['from']) {
        var source = Directory(config.projectRoot + '/' + from);
        await _copy(source, destination);
      }
    }
  }

  /// Recursive copy of all Dirs and Files in `source` to `destination`
  void _copy(Directory source, Directory destination) async {
    if (!await source.exists()) {
      Logger.warn('${source.path} does not exist. Skipping...');
      return;
    }
    var elements = source.listSync();
    for (var entity in elements) {
      var name = entity.path.split('/').last;
      if (entity is Directory) {
        Logger.verbose(
            'Copying file ${source.path}/$name to ${destination.path}/$name');
        var subdir = Directory(destination.path + '/' + name);
        await subdir.create(recursive: true);
        await _copy(entity, subdir);
      } else if (entity is File) {
        if (!await destination.exists()) {
          await destination.create(recursive: true);
        }
        Logger.verbose(
            'Copying file ${source.path}/$name to ${destination.path}/$name');
        var file = File(destination.path + '/' + name);
        await entity.copy(file.path);
      }
    }
  }

  @override
  bool canHandleCommand(String command) => 'build' == command;

  @override
  String get description => 'Copies static assets to the output directory';
}
