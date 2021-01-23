import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:taida/core/config/ConfigurationLoader.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/core/log/Logger.dart';
import 'package:taida/modules/Module.dart';
import 'package:taida/util/DirectoryCopy.dart';
import 'package:taida/util/ModuleContent.dart';
import 'package:watcher/watcher.dart';

part '_DOM.dart';

class HtmlModule extends Module {
  final String templatesDir;
  final String partialsDir;
  final String globalsDir;
  final String pagesDir;

  HtmlModule(
      this.templatesDir, this.partialsDir, this.globalsDir, this.pagesDir);
  factory HtmlModule.load() {
    var config = ConfigurationLoader.load();
    var templatesDir =
        '${config.projectRoot}/${config.moduleConfiguration['html']['templates_directory']}';
    return HtmlModule(
        templatesDir,
        '${templatesDir}/${config.moduleConfiguration['html']['partials_directory']}',
        '${templatesDir}/${config.moduleConfiguration['html']['globals_directory']}',
        '${templatesDir}/${config.moduleConfiguration['html']['pages_directory']}');
  }

  @override
  bool canHandleCommand(String command) {
    return command == 'build';
  }

  @override
  bool canRun(List<Module> queue) {
    var moduleDepenencies = ['scss', 'typescript', 'dart', 'javascript'];
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
    var source = Directory(templatesDir);
    var destination = Directory('${config.workingDirectory}/html/');
    Logger.debug('Copying files from ${source.path}/ to ${destination.path}');
    var copiedFiles = await DirectoryCopy.copy(source, destination);
    for (var file in copiedFiles) {
      await _DOM(file, this).buildPage();
    }
  }

  @override
  List<Watcher> get watchers => [DirectoryWatcher(templatesDir)];
}
