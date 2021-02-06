import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:taida/core/config/ConfigurationLoader.dart';
import 'package:taida/core/log/LogLabel.dart';

/// Basic logger that prints data to the console or logFile.
class Logger {
  /// writes the `message` to the given output location.
  static void _write(String message) {
    if (!ConfigurationLoader.isLoaded()) {
      print(message);
      return;
    }
    var config = ConfigurationLoader.load();
    if (config.logToFile) {
      ansiColorDisabled = true;
      var logFile = File(config.projectRoot + '/' + config.logFile);
      if (!logFile.existsSync()) logFile.createSync();
      logFile.writeAsStringSync('${message}${EOL}', mode: FileMode.append);
    } else {
      print(message);
    }
  }

  /// logs the message with time and given loglabel.
  static void log(LogLabel label, String message) {
    var time = '[${DateTime.now().toIso8601String().padRight(26, ' ')}] ';
    _write(time + label.toString() + message);
  }

  /// logs a debug message that will be ignored if debug mode is turned off
  static void debug(String message) {
    if (ConfigurationLoader.isLoaded() && ConfigurationLoader.load().debug) {
      log(LogLabel.debug, message);
    }
  }

  /// logs the given number of lines.
  /// if `lines` is smaller that 1 it will only print the line once.
  static void emptyLines([int lines = 0]) {
    if (lines < 0) lines = 0;
    _write('\n' * lines.abs());
  }

  /// logs an error message
  static void error(String message) => log(LogLabel.error, message);

  /// logs a warning
  static void warn(String message) => log(LogLabel.warning, message);

  /// logs a verbose message.
  /// if verbose logs are truned off this will be ignored.
  static void verbose(String message) {
    if (ConfigurationLoader.isLoaded() && ConfigurationLoader.load().verbose) {
      log(LogLabel.verbose, message);
    }
  }

  static String get EOL => Platform.isWindows ? '\r\n' : '\n';
}
