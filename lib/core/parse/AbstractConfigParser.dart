import 'dart:io';

/// Interface for parsing configurations from a Config file
abstract class AbstractConfigParser {
  final String configPath;

  AbstractConfigParser(this.configPath) {
    var _config = File(configPath).readAsStringSync();
    _config = _replaceEnvironmentVariables(_config);
    File(configPath).writeAsStringSync(_config);
  }

  static String _replaceEnvironmentVariables(String config) {
    var valueFromEnvironmentKey =
        (String key) => String.fromEnvironment(key, defaultValue: key);
    return config.replaceAllMapped(r'^%env\(([a-zA-Z]+)\)%$',
        (match) => valueFromEnvironmentKey(match.group(1)));
  }

  Map<String, dynamic> parse();
}
