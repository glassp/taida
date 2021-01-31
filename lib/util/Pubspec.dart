import 'dart:convert';
import 'dart:io';

import 'package:taida/_taida.dart';
import 'package:yaml/yaml.dart';

class Pubspec {
  static Pubspec _instance;
  final String name;
  final String description;
  final String version;

  Pubspec({
    this.name,
    this.description,
    this.version,
  });

  factory Pubspec.fromJson(Map<String, dynamic> json) {
    return Pubspec(
      name: json['name'] as String,
      description: json['description'] as String,
      version: json['version'] as String,
    );
  }

  factory Pubspec.load() {
    if (null != _instance) return _instance;
    var json = jsonDecode(jsonEncode(loadYaml(
        File('${TAIDA_LIBRARY_ROOT}/pubspec.yaml').readAsStringSync())));
    var instance = Pubspec.fromJson(json);
    _instance = instance;
    return _instance;
  }
}
