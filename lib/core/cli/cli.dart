import 'package:args/command_runner.dart';
import './commands/AnalyzeCommand.dart';
import './commands/BuildCommand.dart';
import './commands/FormatCommand.dart';
import './commands/ModuleCommand.dart';
import './commands/TestCommand.dart';

/// Main command that registers all commands and
CommandRunner runApp() {
  return CommandRunner('taida', 'Build System for WebApplications')
    ..addCommand(AnalyzeCommand())
    ..addCommand(BuildCommand())
    ..addCommand(FormatCommand())
    ..addCommand(TestCommand())
    ..addCommand(ModuleCommand());
}
