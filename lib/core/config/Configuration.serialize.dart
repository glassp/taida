part of 'Configuration.dart';

/// Logic for serializing the Configuration
abstract class _Configuration {
  static Configuration fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('taida')) {
      throw InvalidConfigurationFormatException(
          'Configuration is not formated properly. Missing global "taida" key.');
    }

    json = json['taida'];
    return Configuration(
      projectRoot: json['project_root'] as String,
      outputDirectoryName: json['output_dir'] as String ?? 'build',
      enableCacheBuster: json['enable_cache_buster'] as bool ?? false,
      logFile: json['log_file'] as String,
      debug: json['debug'] as bool ?? false,
      verbose: json['verbose'] as bool ?? false,
      watch: json['watch'] as bool ?? false,
      buildHash: json['build_hash'] as String,
      moduleConfiguration: json['module_config'] == null
          ? null
          : ModuleConfiguration.fromJson(
              json['module_config'] as Map<String, dynamic>),
    );
  }

  static Map<String, dynamic> toJson(Configuration config) {
    return {
      'project_root': '"${config.projectRoot}"',
      'output_dir': '"${config.outputDirectory}"',
      'enable_cache_buster': config.enableCacheBuster,
      'log_file': '"${config.logFile ?? ''}"',
      'debug': config.debug,
      'verbose': config.verbose,
      'watch': config.watch,
      'build_hash': '"${config.buildHash}"',
      'module_config_': config.moduleConfiguration.toJson(),
      '\$workingDirectory': '"${config.workingDirectory}"',
      '\$logToFile': config.logToFile,
      '\$outputDirectory': '"${config.outputDirectory}"',
      '\$modules': '${config.modules}',
    };
  }
}
