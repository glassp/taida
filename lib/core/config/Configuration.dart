import 'package:taida/Exception/Configuration/InvalidConfigurationFormat.dart';

part 'Configuration.serialize.dart';

/// Data Class holding the Configuration Data
class Configuration {
  final String projectRoot;
  final String outputDirectory;
  final bool debug;
  final bool watch;
  final bool verbose;
  final bool enableCacheBuster;
  final String logFile;
  final String buildHash;
  final List<dynamic> modules;
  final Map<String, dynamic> moduleConfiguration;

  Configuration(
      {this.outputDirectory = 'build',
      this.debug = false,
      this.projectRoot = '',
      this.verbose = false,
      this.watch = false,
      this.enableCacheBuster = false,
      this.logFile = '',
      this.buildHash = '',
      this.modules = const [],
      this.moduleConfiguration = const {}});
  factory Configuration.fromMap(Map<String, dynamic> config) =>
      _Configuration.fromMap(config);

  @override
  String toString() => _Configuration.configAsString(this);
  bool get logToFile => logFile?.isNotEmpty == false;
}
