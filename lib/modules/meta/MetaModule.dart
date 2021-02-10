import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:html/dom.dart';
import 'package:watcher/watcher.dart';

import '../../core/config/ConfigurationLoader.dart';
import '../../core/config/modules/meta/MetaConfiguration.dart';
import '../../core/execution/Phase.dart';
import '../../core/log/LogLabel.dart';
import '../../util/ImageConverter.dart';
import '../../util/ModuleContent.dart';
import '../../util/Pubspec.dart';
import '../Module.dart';
import 'submodules/WebManifest.dart';
import 'submodules/WebManifestIcons.dart';

part './submodules/_PwaMetaData.dart';
part './submodules/_SeoMetaData.dart';
part './submodules/_SubModuleInterface.dart';

/// Module handeling creation of meta data
class MetaModule extends Module {
  /// the submodules of this module
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
  Phase get executionTime => Phase.preProcessing;
}
