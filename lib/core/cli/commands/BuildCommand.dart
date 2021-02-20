import '../BaseCommand.dart';

/// Command that invokes the build process
class BuildCommand extends BaseCommand {
  @override
  String get description => 'Builds the code depending on the build mode.';

  @override
  String get name => 'build';

  /// Constructor that creates this command
  BuildCommand() : super() {
    argParser
      ..addFlag('a11y',
          abbr: 'a',
          defaultsTo: false,
          help: 'Automatically adds checka11y.css to the html outout',
          negatable: false)
      ..addFlag('watch',
          abbr: 'w',
          defaultsTo: false,
          help: 'Enables the usage of a FileWatcher',
          negatable: false);
  }
}
