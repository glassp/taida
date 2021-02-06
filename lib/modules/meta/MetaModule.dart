import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:html/dom.dart';
import 'package:taida/core/config/ConfigurationLoader.dart';
import 'package:taida/core/config/modules/meta/MetaConfiguration.dart';
import 'package:taida/core/execution/Phase.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/modules/Module.dart';
import 'package:taida/modules/meta/submodules/WebManifest.dart';
import 'package:taida/modules/meta/submodules/WebManifestIcons.dart';
import 'package:taida/util/ImageConverter.dart';
import 'package:taida/util/ModuleContent.dart';
import 'package:taida/util/Pubspec.dart';
import 'package:watcher/watcher.dart';

part './submodules/_PwaMetaData.dart';
part './submodules/_SeoMetaData.dart';
part './submodules/_SubModuleInterface.dart';

class MetaModule extends Module {
  final submodules = <_SubModuleInterface>[_PwaMetaData(), _SeoMetaData()];
  @override
  bool canHandleCommand(String command) => command == 'build';

  @override
  bool canRun(List<Module> queue) => true;

  @override
  String get description => 'Creates meta data';

  @override
  LogLabel get logLabel => LogLabel(name, AnsiPen()..yellow(bg: true));

  @override
  String get name => 'meta';

  @override
  void run(String command) async {
    var config = ConfigurationLoader.load();
    for (var submodule in submodules) {
      await submodule.run(config.moduleConfiguration.meta);
    }
  }

  @override
  List<Watcher> get watchers {
    var list = <Watcher>[];
    for (var submodule in submodules) {
      list.addAll(submodule.watchers);
    }
    return list;
  }

  @override
  bool get isConfigured {
    var config = ConfigurationLoader.load();
    return null != config.moduleConfiguration.meta;
  }

  @override
  Phase get executionTime => Phase.PREPROCESSING;
}
