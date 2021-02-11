// ignore_for_file: avoid_classes_with_only_static_members
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

import '../../Exception/Configuration/ConfigurationFileNotFound.dart';
import '../../Exception/Configuration/UnknownConfigurationFormat.dart';
import '../log/LogLabel.dart';
import '../log/Logger.dart';
import '../parse/AbstractConfigParser.dart';
import '../parse/JsonConfigParser.dart';
import '../parse/YamlConfigParser.dart';
import 'Configuration.dart';

/// Class for loading the Configuration
/// Should only ever be used in a static context to obtain the configuration.
/// Caches the Configurtion after initial fetching.
@sealed
abstract class ConfigurationLoader {
  static Configuration _instance;
  static Map<String, dynamic> _cliOptions;
  static String _projectRoot;
  static final String _workingDirectory = '/taida/workDir';

  /// list of possible configuration file names
  static final List<String> possibleConfigFiles = <String>[
    'taida.yaml',
    'taida.yml',
    'taida.json'
  ];

  @internal

  /// sets the cli options if they were not set
  // ignore: avoid_setters_without_getters
  static set cliOptions(Map<String, dynamic> options) {
    _cliOptions ??= options;
  }

  /// returns a [Configuration] either from the cache or
  /// a newly created instance,
  static Configuration load() => _instance ?? _createConfiguration();

  /// checks if a [Configuration] exists in the cache
  static bool isLoaded() => null != _instance;

  /// creates a [Configuration] by parsing it from the config file
  static Configuration _createConfiguration() {
    var configPath = _findConfigurationFile();
    Logger.log(LogLabel.config, 'Reading configuration from $configPath');
    var ext = configPath.split('.').last;
    var path = '$_projectRoot$_workingDirectory/taida.config.$ext';
    if (!File(path).existsSync()) File(path).createSync(recursive: true);

    // copy contents to temporary config file
    File(path).writeAsStringSync(File(configPath).readAsStringSync());

    var parser = _getParserForFileType(path);
    var configMap = parser.parse();
    configMap = configMap['taida'];

    // Init cliOptions if not yet done
    cliOptions = <String, dynamic>{};
    _cliOptions.putIfAbsent('taida', () => <String, dynamic>{});
    (_cliOptions['taida'] as Map<String, dynamic>)
        .putIfAbsent('project_root', () => _projectRoot);
    (_cliOptions['taida'] as Map<String, dynamic>).putIfAbsent(
        'build_hash',
        () => sha256
            .convert(utf8.encode(DateTime.now().toIso8601String()))
            .toString()
            .substring(0, 8));

    for (var key in configMap?.keys) {
      (_cliOptions['taida'] as Map<String, dynamic>)
          .putIfAbsent(key, () => configMap[key]);
    }
    var configuration = Configuration.fromJson(_cliOptions);
    _instance = configuration;
    Logger.debug('Using configuration: \n$configuration');
    return configuration;
  }

  /// search for the configuration file in the current working dir.
  static String _findConfigurationFile() {
    var cwd = Directory.current.absolute;
    var fileNames = cwd.listSync().map((file) => file.path);

    for (var fileName in fileNames) {
      fileName = fileName.split('/').last;
      if (possibleConfigFiles.contains(fileName)) {
        _projectRoot = cwd.path;
        return '$_projectRoot/$fileName';
      }
    }

    throw ConfigurationNotFoundException('''
Configuration file not found. Run this tool from your project root. 
Current directory is ${cwd.absolute.path}''');
  }

  /// return a Parser for given FileType
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
        'No suitable Parser found for "$path"');
  }
}
