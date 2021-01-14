import 'package:args/command_runner.dart';
import 'package:taida/core/cli/commands/AnalyzeCommand.dart';
import 'package:taida/core/cli/commands/BuildCommand.dart';
import 'package:taida/core/cli/commands/FixCommand.dart';
import 'package:taida/core/cli/commands/ModuleCommand.dart';
import 'package:taida/core/cli/commands/TestCommand.dart';

/// Main command that registers all commands and
CommandRunner runApp() {
  return CommandRunner('taida', 'Build System for WebApplications')
    ..addCommand(AnalyzeCommand())
    ..addCommand(BuildCommand())
    ..addCommand(FixCommand())
    ..addCommand(TestCommand())
    ..addCommand(ModuleCommand());
}
