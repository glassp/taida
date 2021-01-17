part of 'Configuration.dart';

/// Logic for serializing the Configuration
class _Configuration {
  static Configuration fromMap(Map<String, dynamic> map) {
    if (!map.containsKey('taida')) {
      throw InvalidConfigurationFormatException(
          'Configuration is not formated properly. Missing global "taida" key.');
    }

    map = map['taida'];
    return Configuration(
        outputDirectory: map['output_dir'],
        debug: map['debug'],
        projectRoot: map['project_root'],
        verbose: map['verbose'],
        watch: map['watch'] ?? false,
        enableCacheBuster: map['enable_cache_buster'] ?? false,
        logFile: map['log_file'],
        buildHash: map['build_hash'],
        modules: map['modules'],
        moduleConfiguration: map['module_config']);
  }

  static String configAsString(Configuration config) {
    return {
      'output_dir': '"${config.outputDirectory}"',
      'debug': config.debug,
      'project_root': '"${config.projectRoot}"',
      '\$workingDirectory': '"${config.workingDirectory}"',
      'verbose': config.verbose,
      'watch': config.watch,
      'enable_cache_buster': config.enableCacheBuster,
      'log_file': '"${config.logFile ?? ''}"',
      '\$logToFile': config.logToFile,
      'build_hash': '"${config.buildHash}"',
      'modules': config.modules.toString(),
      'module_config': {
        for (var key in config.moduleConfiguration.keys)
          '$key': '${config.moduleConfiguration[key]}',
      }.toString()
    }.toString();
  }
}
