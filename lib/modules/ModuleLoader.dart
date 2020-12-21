import 'package:taida/core/log/Logger.dart';
import 'package:taida/modules/Module.dart';
import 'package:taida/modules/copy/CopyModule.dart';

class ModuleLoader {
  static Map<String, Module> get registeredModules {
    Logger.verbose('Registering Modules...');
    return {
      'copy': CopyModule(),
    };
  }
}
