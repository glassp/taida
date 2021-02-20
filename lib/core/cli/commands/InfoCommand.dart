import 'dart:io' show Platform;

import 'package:args/command_runner.dart';

import '../../../util/Pubspec.dart';
import '../../config/ConfigurationLoader.dart';
import '../../log/Logger.dart';
import '../cli.dart';

/// Command that prints information about taida
class InfoCommand extends Command {
  @override
  String get description => 'Prints version and usage information.';

  @override
  String get name => 'info';

  @override
  void run() async {
    Logger.activated = false;
    var version = "UNKNOWN";
    try {
      // Loading configuration so that we have access to Pubspec.taidaVersion
      ConfigurationLoader.load();
      version = Pubspec.taidaVersion;
    } on Exception {
      //ignore
    }
    print("Taida Version: $version");
    print("Dart Version: ${Platform.version}");
    print("");
    getCommandRunner().printUsage();
  }
}
