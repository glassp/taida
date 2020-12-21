import 'package:taida/core/cli/BaseCommand.dart';

class BuildCommand extends BaseCommand {
  @override
  String get description => 'Builds the code depending on the build mode.';

  @override
  String get name => 'build';

  BuildCommand() : super() {
    argParser
      ..addFlag('watch',
          abbr: 'w',
          defaultsTo: false,
          help: 'Enables the usage of a FileWatcher');
  }
}
