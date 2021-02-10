import 'dart:io';

/// Interface for parsing configurations from a Config file
abstract class AbstractConfigParser {
  /// psth to the configurtion
  final String configPath;

  /// constructor that creates a parser for given configPath
  /// and replaces environment variables on-the-fly
  AbstractConfigParser(this.configPath) {
    var _config = File(configPath).readAsStringSync();
    _config = _replaceEnvironmentVariables(_config);
    File(configPath).writeAsStringSync(_config);
  }

  static String _replaceEnvironmentVariables(String config) {
    return config.replaceAllMapped(r'^%env\(([a-zA-Z]+)\)%$',
        (match) => _valueFromEnvironmentKey(match.group(1)));
  }

  static String _valueFromEnvironmentKey(String key) =>
      String.fromEnvironment(key, defaultValue: key);

  /// parse the configurstion
  Map<String, dynamic> parse();
}
