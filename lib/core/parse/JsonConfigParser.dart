import 'dart:convert';
import 'dart:io';

import 'package:taida/core/parse/AbstractConfigParser.dart';

class JsonConfigParser extends AbstractConfigParser {
  JsonConfigParser(String configPath) : super(configPath);

  @override
  Map<String, dynamic> parse() {
    var json = File(configPath).readAsStringSync();
    return jsonDecode(json);
  }
}