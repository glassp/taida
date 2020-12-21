import 'package:taida/Exception/Configuration/InvalidConfigurationFormat.dart';

part 'Configuration.serialize.dart';

/// Data Class holding the Configuration Data
class Configuration {
  final String projectRoot;
  final String outputDirectory;
  final bool debug;
  final bool watch;
  final bool verbose;
  final String logFile;
  final List<dynamic> modules;
  final Map<String, dynamic> moduleConfiguration;

  Configuration(
      {this.outputDirectory = 'build',
      this.debug,
      this.projectRoot,
      this.verbose,
      this.watch,
      this.logFile = '',
      this.modules = const [],
      this.moduleConfiguration = const {}});
  factory Configuration.fromMap(Map<String, dynamic> config) =>
      _Configuration.fromMap(config);

  @override
  String toString() => _Configuration.configAsString(this);
  bool get logToFile => logFile?.isNotEmpty == false;
}
