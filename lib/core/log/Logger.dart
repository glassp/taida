// ignore_for_file: avoid_classes_with_only_static_members
import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import '../config/ConfigurationLoader.dart';
import './LogLabel.dart';

/// Basic logger that prints data to the console or logFile.
class Logger {
  /// flag to disable the logger completely
  static bool activated = true;

  /// writes the `message` to the given output location.
  static void _write(String message) {
    if (!activated) return;
    if (!ConfigurationLoader.isLoaded()) {
      print(message);
      return;
    }
    var config = ConfigurationLoader.load();
    if (config.logToFile) {
      ansiColorDisabled = true;
      var logFile = File('${config.projectRoot}/${config.logFile}');
      if (!logFile.existsSync()) logFile.createSync();
      logFile.writeAsStringSync('$message$endOfLineChar',
          mode: FileMode.append);
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

  /// returns the line ending
  static String get endOfLineChar => Platform.isWindows ? '\r\n' : '\n';
}
