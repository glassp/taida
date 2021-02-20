// ignore_for_file: avoid_classes_with_only_static_members
import '../core/log/Logger.dart';
import 'Module.dart';
import 'copy/CopyModule.dart';
import 'dart/DartModule.dart';
import 'html/HtmlModule.dart';
import 'meta/MetaModule.dart';
import 'scss/ScssModule.dart';

/// Loads all Modules
class ModuleLoader {
  /// The default modules that are always present within taida.
  static final Map<String, Module> _registeredModules = <String, Module>{
    'copy': CopyModule(),
    'scss': ScssModule(),
    'dart': DartModule(),
    'html': HtmlModule(),
    'meta': MetaModule(),
  };
  static bool _sealed = false;

  /// returns list of registered modules
  static Map<String, Module> get registeredModules {
    if (!_sealed) {
      Logger.verbose('Sealing registered Modules...');
      _sealed = true;
    }
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

  /// Take a peek at the currently registered modules.
  /// The Map of peeked modules is a unmodifieable copy of the internally
  ///  used Map!
  static Map<String, String> peek() => Map.unmodifiable(_registeredModules);
}
