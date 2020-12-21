import 'package:taida/core/cli/BaseCommand.dart';

class TestCommand extends BaseCommand {
  @override
  String get description => 'Runs all test-cases of the project.';

  @override
  String get name => 'test';
}
