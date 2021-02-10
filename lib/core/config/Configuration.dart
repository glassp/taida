import 'dart:convert';

import '../../Exception/Configuration/InvalidConfigurationFormat.dart';
import '../../modules/ModuleLoader.dart';
import 'ModuleConfiguration.dart';

part 'Configuration.serialize.dart';

/// Data Class holding the Configuration Data
class Configuration {
  /// the project root of the current project
  final String projectRoot;
  /// the name of the output directory
  final String outputDirectoryName;
  /// if the debug mode was enabled
  final bool debug;
  /// if the watch mode was enabled
  final bool watch;
  /// if verbose logging was enabled
  final bool verbose;
  /// if the cache buster should be enabled
  final bool enableCacheBuster;
  /// path to the logFile
  final String logFile;
  /// the current build hash to be used by the cache buster
  final String buildHash;
  /// the configuration for the modules
  final ModuleConfiguration moduleConfiguration;

  /// the Constructor for this Configuration
  Configuration(
      {this.outputDirectoryName = 'build',
      this.debug = false,
      this.projectRoot = '',
      this.verbose = false,
      this.watch = false,
      this.enableCacheBuster = false,
      this.logFile = '',
      this.buildHash = '',
      this.moduleConfiguration});

  /// factory constructor that deserializes the configuration from json
  factory Configuration.fromJson(Map<String, dynamic> config) =>
      _Configuration.fromJson(config);

  @override
  String toString() => jsonEncode(toJson());
  /// transform the configuration to json
  Map<String, dynamic> toJson() => _Configuration.toJson(this);
  /// if the logger should log to the log file
  bool get logToFile => logFile?.isNotEmpty ?? false;
  /// the absolutepath to the working directory
  String get workingDirectory => '$projectRoot/taida/workDir';
  /// the absolute path to the output directory
  String get outputDirectory => '$projectRoot/$outputDirectoryName';
  /// a list of all modules currently registered
  List<String> get modules =>
      ModuleLoader.registeredModules.keys.toList(growable: false);
}
