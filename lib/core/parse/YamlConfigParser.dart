import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

import './AbstractConfigParser.dart';

/// parser for config yamls
class YamlConfigParser extends AbstractConfigParser {
  /// constructor that creates a parser for given configPath
  /// and replaces environment variables on-the-fly
  YamlConfigParser(String configPath) : super(configPath);

  @override
  Map<String, dynamic> parse() {
    var yaml = File(configPath).readAsStringSync();
    return jsonDecode(jsonEncode(loadYaml(yaml)));
  }
}
