import 'package:taida/core/cli/BaseCommand.dart';

class AnalyzeCommand extends BaseCommand {
  @override
  String get description =>
      'Runs analytical tools, tests and lints to ensure Code Quality.';

  @override
  String get name => 'analyze';
}
