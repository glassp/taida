import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:taida/taida.dart';

import './commands/AnalyzeCommand.dart';
import './commands/BuildCommand.dart';
import './commands/FormatCommand.dart';
import './commands/InfoCommand.dart';
import './commands/ModuleCommand.dart';
import './commands/TestCommand.dart';

/// Main command that registers all commands and
CommandRunner getCommandRunner() {
  var runner = CommandRunner('taida', 'Build System for WebApplications')
    ..addCommand(AnalyzeCommand())
    ..addCommand(BuildCommand())
    ..addCommand(FormatCommand())
    ..addCommand(TestCommand())
    ..addCommand(ModuleCommand())
    ..addCommand(InfoCommand());
  runner.argParser.addFlag('version',
      negatable: false,
      help: 'Prints version information and prevents command execution');
  return runner;
}

/// executes the correct command based on the arguments
void runApp(List<String> arguments) async {
  if (arguments.contains("--help") || arguments.contains("-h")) {
    await getCommandRunner().run(arguments);
    exit(0);
  }
  if (arguments.contains("help")) {
    var args = arguments.sublist(arguments.indexOf("help") + 1);
    Command command;
    if (args != null && args.isNotEmpty) {
      command = getCommandRunner().commands[args[0]];
      args = args.sublist(1);
    }
    if (command == null) {
      await runApp(['--help']);
      exit(0);
    }
    for (var arg in args) {
      final subcommand = command.subcommands[arg];
      if (subcommand == null) break;
      command = subcommand;
    }
    command.printUsage();
    exit(0);
  }

  if (arguments.contains('--version') || arguments.isEmpty) {
    await getCommandRunner().run(['info']);
    exit(0);
  }
  await getCommandRunner().run(arguments);
}
