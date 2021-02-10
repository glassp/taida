import 'dart:convert';
import 'dart:io';

import './AbstractConfigParser.dart';

/// Parser for config jsons
class JsonConfigParser extends AbstractConfigParser {
  /// constructor that creates a parser for given configPath
  /// and replaces environment variables on-the-fly
  JsonConfigParser(String configPath) : super(configPath);

  @override
  Map<String, dynamic> parse() {
    var json = File(configPath).readAsStringSync();
    return jsonDecode(json);
  }
}
