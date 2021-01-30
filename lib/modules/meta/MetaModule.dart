import 'package:ansicolor/ansicolor.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/modules/Module.dart';
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
    for (var submodule in submodules) {
      await submodule.run(moduleConfiguration);
    }
  }

  @override
  List<Watcher> get watchers {
    var list = [];
    for (var submodule in submodules) {
      list.addAll(submodule.watchers);
    }
    return list;
  }
}
