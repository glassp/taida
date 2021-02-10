import '../BaseCommand.dart';

/// Command that invokes the analyze process
class AnalyzeCommand extends BaseCommand {
  @override
  String get description =>
      'Runs analytical tools, tests and lints to ensure Code Quality.';

  @override
  String get name => 'analyze';
}
