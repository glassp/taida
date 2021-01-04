import 'dart:io';

import 'package:taida/core/config/ConfigurationLoader.dart';
import 'package:taida/core/log/LogLabel.dart';

/// Basic logger that prints data to the console or logFile.
class Logger {
  static void _write(String message) {
    if (!ConfigurationLoader.isLoaded()) {
      print(message);
      return;
    }
    var config = ConfigurationLoader.load();
    if (config.logToFile) {
      var logFile = File(config.projectRoot + '/' + config.logFile);
      logFile.openWrite(mode: FileMode.append)
        ..write(message)
        ..flush()
        ..close();
    } else {
      print(message);
    }
  }

  static void log(LogLabel label, String message) {
    var time = '[${DateTime.now().toIso8601String().padRight(26, ' ')}] ';
    _write(time + label.toString() + message);
  }

  static void debug(String message) {
    if (ConfigurationLoader.isLoaded() &&
        ConfigurationLoader.load().debug) {
      log(LogLabel.debug, message);
    }
  }
  static void emptyLines([int lines = 0]) {
    print('\n'*lines);
  }
  static void error(String message) => log(LogLabel.error, message);
  static void warn(String message) => log(LogLabel.warning, message);
  static void verbose(String message) {
    if (ConfigurationLoader.isLoaded() && ConfigurationLoader.load().verbose) {
      log(LogLabel.verbose, message);
    }
  }
}
