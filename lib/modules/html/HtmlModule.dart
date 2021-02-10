import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:watcher/watcher.dart';

import '../../core/config/ConfigurationLoader.dart';
import '../../core/execution/Phase.dart' as execution;
import '../../core/log/LogLabel.dart';
import '../../core/log/Logger.dart';
import '../../util/DirectoryCopy.dart';
import '../../util/ImageConverter.dart';
import '../../util/ModuleContent.dart';
import '../Module.dart';

part '_DOM.dart';

/// Module handeling html file creation
class HtmlModule extends Module {
  @override
  bool canHandleCommand(String command) {
    return command == 'build';
  }

  @override
  bool canRun(List<Module> queue) {
    var moduleDepenencies = [
      'scss',
      'typescript',
      'dart',
      'javascript',
      'meta'
    ];
    return !queue.any((module) => moduleDepenencies.contains(module.name));
  }

  @override
  String get description => 'Builds the HTML and generates layout files.';

  @override
  LogLabel get logLabel => LogLabel(
      name,
      AnsiPen()
        ..yellow(bg: true)
        ..black());

  @override
  String get name => 'HTML';

  @override
  void run(String command) async {
    return await _build();
  }

  void _build() async {
    var config = ConfigurationLoader.load();
    var source = Directory(config.moduleConfiguration.html.templatesDirectory);
    var destination = Directory('${config.workingDirectory}/html');
    Logger.debug('Copying files from ${source.path}/ to ${destination.path}');
    var copiedFiles = await DirectoryCopy.copy(source, destination);
    for (var file in copiedFiles) {
      await _DOM(file, this).buildPage();
    }
  }

  @override
  List<Watcher> get watchers {
    var config = ConfigurationLoader.load();
    return [
      DirectoryWatcher(config.moduleConfiguration.html.templatesDirectory)
    ];
  }

  @override
  bool get isConfigured {
    var config = ConfigurationLoader.load();
    return null != config.moduleConfiguration.html;
  }

  @override
  execution.Phase get executionTime => execution.Phase.emit;
}
