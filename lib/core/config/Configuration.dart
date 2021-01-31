import 'package:taida/Exception/Configuration/InvalidConfigurationFormat.dart';
import 'package:taida/modules/ModuleLoader.dart';

part 'Configuration.serialize.dart';

/// Data Class holding the Configuration Data
class Configuration {
  final String projectRoot;
  final String outputDirectoryName;
  final bool debug;
  final bool watch;
  final bool verbose;
  final bool enableCacheBuster;
  final String logFile;
  final String buildHash;
  final Map<String, dynamic> moduleConfiguration;

  Configuration(
      {this.outputDirectoryName = 'build',
      this.debug = false,
      this.projectRoot = '',
      this.verbose = false,
      this.watch = false,
      this.enableCacheBuster = false,
      this.logFile = '',
      this.buildHash = '',
      this.moduleConfiguration = const {}});
  factory Configuration.fromMap(Map<String, dynamic> config) =>
      _Configuration.fromMap(config);

  @override
  String toString() => _Configuration.configAsString(this);
  bool get logToFile => logFile?.isNotEmpty == false;
  String get workingDirectory => '${projectRoot}/taida/workDir';
  String get outputDirectory => '${projectRoot}/${outputDirectoryName}';
  List<String> get modules =>
      ModuleLoader.registeredModules.keys.toList(growable: false);
}
