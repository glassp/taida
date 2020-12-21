import 'dart:convert';
import 'dart:io';

import 'package:taida/core/parse/AbstractConfigParser.dart';
import 'package:yaml/yaml.dart';

class YamlConfigParser extends AbstractConfigParser {
  YamlConfigParser(String configPath) : super(configPath);

  @override
  Map<String, dynamic> parse() {
    var yaml = File(configPath).readAsStringSync();
    return jsonDecode(jsonEncode(loadYaml(yaml)));
  }
}