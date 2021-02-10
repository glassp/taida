// ignore_for_file: public_member_api_docs
import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

import '../core/config/ConfigurationLoader.dart';


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

  /// This will load the pubspec.yaml within the projectRoot
  /// WARNING: Cannot be used before configuration was loaded
  factory Pubspec.load() {
    if (null != _instance) return _instance;
    if (!ConfigurationLoader.isLoaded()) {
      throw UnsupportedError(
          'Cannot load Pubspec information before loading configuration');
    }
    var config = ConfigurationLoader.load();
    var json = jsonDecode(jsonEncode(loadYaml(
        File('${config.projectRoot}/pubspec.yaml').readAsStringSync())));
    var instance = Pubspec.fromJson(json);
    _instance = instance;
    return _instance;
  }

  /// returns the version of this package if embeded into another
  /// WARNING: Cannot be used before Configuration was loaded
  static String get taidaVersion {
    if (!ConfigurationLoader.isLoaded()) {
      throw UnsupportedError(
          'Cannot load Pubspec information before loading configuration');
    }
    var config = ConfigurationLoader.load();
    var json = jsonDecode(jsonEncode(loadYaml(
        File('${config.projectRoot}/pubspec.lock').readAsStringSync())));
    return json['packages']['taida']['version'];
  }
}
