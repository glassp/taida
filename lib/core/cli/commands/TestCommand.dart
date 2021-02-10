import '../BaseCommand.dart';

/// Command that invokes the test process
class TestCommand extends BaseCommand {
  @override
  String get description => 'Runs all test-cases of the project.';

  @override
  String get name => 'test';
}
