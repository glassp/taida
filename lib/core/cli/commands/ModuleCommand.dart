import 'package:args/command_runner.dart';
import '../../../modules/ModuleLoader.dart';

/// Command that lists all registered modules
class ModuleCommand extends Command {
  @override
  String get description => 'Lists all Modules that are available';

  @override
  String get name => 'modules';

  @override
  void run() {
    print('Module\tDescription');
    print('------------------------------------------------------------');
    for (var module in ModuleLoader.registeredModules.values) {
      print('${module.name}\t${module.description}');
    }
  }
}
