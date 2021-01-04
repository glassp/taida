import 'dart:io';

import 'package:meta/meta.dart';
import 'package:taida/Exception/Configuration/ConfigurationFileNotFound.dart';
import 'package:taida/Exception/Configuration/UnknownConfigurationFormat.dart';
import 'package:taida/core/config/Configuration.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/core/log/Logger.dart';
import 'package:taida/core/parse/AbstractConfigParser.dart';
import 'package:taida/core/parse/JsonConfigParser.dart';
import 'package:taida/core/parse/YamlConfigParser.dart';

/// Class for loading the Configuration
/// Should only ever be used in a static context to obtain the configuration.
/// Caches the Configurtion after initial fetching.
@sealed
abstract class ConfigurationLoader {
  static Configuration _instance;
  static Map<String, dynamic> _cliOptions;
  static String _projectRoot;
  static final String _workingDirectory = '/taida/workDir';
  static final List<String> possibleConfigFiles = <String>[
    'taida.yaml',
    'taida.yml',
    'taida.json'
  ];

  static set cliOptions(options) {
    _cliOptions ??= options;
  }

  static Configuration load() => _instance ?? _createConfiguration();
  static bool isLoaded() => null != _instance;

  static Configuration _createConfiguration() {
    var configPath = _findConfigurationFile();
    Logger.log(LogLabel.config, 'Reading configuration from $configPath');
    var path =
        '${_projectRoot}${_workingDirectory}/taida.config.${configPath.split('.').last}';
    if (!File(path).existsSync()) File(path).createSync(recursive: true);

    // copy contents to temporary config file
    File(path).writeAsStringSync(File(configPath).readAsStringSync());

    var parser = _getParserForFileType(path);
    var configMap = parser.parse();
    configMap =configMap['taida'];
    _cliOptions['taida']['project_root'] = _projectRoot;

    for (var key in configMap.keys) {
      _cliOptions['taida'].putIfAbsent(key, () => configMap[key]);
    }
    var configuration = Configuration.fromMap(_cliOptions);
    _instance = configuration;
    Logger.debug('Using configuration: \n$configuration');
    return configuration;
  }

  static String _findConfigurationFile() {
    var cwd = Directory.current.absolute;
    var fileNames = cwd.listSync().map((file) => file.path);

    for (var fileName in fileNames) {
      fileName = fileName.split('/').last;
      if (possibleConfigFiles.contains(fileName)) {
        _projectRoot = cwd.path;
        return '${_projectRoot}/${fileName}';
      }
    }

    throw ConfigurationNotFoundException('''
Configuration file not found. Run this tool from your project root. 
Current directory is ${cwd.absolute.path}''');
  }

  static AbstractConfigParser _getParserForFileType(String path) {
    var parsers = <AbstractConfigParser>[
      YamlConfigParser(path),
      JsonConfigParser(path),
    ];
    var filetype = path.split('.').last;

    for (var parser in parsers) {
      if (parser.runtimeType
          .toString()
          .toLowerCase()
          .contains(filetype.toLowerCase())) {
        return parser;
      }
    }

    throw UnknownConfigurationFormatException(
        'No suitable Parser found for "${path}');
  }
}
