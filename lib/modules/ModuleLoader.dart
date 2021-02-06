import 'package:taida/core/log/Logger.dart';
import 'package:taida/modules/Module.dart';
import 'package:taida/modules/copy/CopyModule.dart';
import 'package:taida/modules/dart/DartModule.dart';
import 'package:taida/modules/html/HtmlModule.dart';
import 'package:taida/modules/meta/MetaModule.dart';
import 'package:taida/modules/scss/ScssModule.dart';

class ModuleLoader {
  /// The default modules that are always present within taida.
  static final Map<String, Module> _registeredModules = <String, Module>{
    'copy': CopyModule(),
    'scss': ScssModule(),
    'dart': DartModule(),
    'html': HtmlModule.load(),
    'meta': MetaModule(),
  };
  static bool _sealed = false;
  static Map<String, Module> get registeredModules {
    Logger.verbose('Sealing registered Modules...');
    _sealed = true;
    return Map<String, Module>.from(_registeredModules);
  }

  /// Registed a external Module
  static void register(Module module) {
    if (_sealed) {
      Logger.error(
          'Modules cannot be modified anymore. They were already sealed');
      return;
    }
    Logger.verbose('Registering Module ${module.name}...');
    _registeredModules.putIfAbsent(module.name, () => module);
  }

  /// Remove a registered Module
  static void unregister(Module module) {
    if (_sealed) {
      Logger.error(
          'Modules cannot be modified anymore. They were already sealed');
      return;
    }
    Logger.verbose('Unregistering Module ${module.name}...');
    _registeredModules.remove(module.name);
  }
}
