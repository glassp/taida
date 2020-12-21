import 'dart:io';

import 'package:taida/Exception/UnknownConfigurationFormat.dart';
import 'package:taida/core/config/Configuration.dart';
import 'package:taida/core/parse/AbstractConfigParser.dart';
import 'package:taida/core/parse/JsonConfigParser.dart';
import 'package:taida/core/parse/YamlConfigParser.dart';

abstract class ConfigurationLoader {
  static Configuration _instance;
  String _projectRoot;
  final String _workingDirectory = '/taida/workDir';
  final List<String> possibleConfigFiles = <String>[
    'taida.yaml', 'taida.yml', 'taida.json'
  ];

  Configuration load() => _instance ?? _createConfiguration();

  Configuration _createConfiguration() {
    var configPath = _findConfigurationFile();
    var path = '${_projectRoot}${_workingDirectory}/taida.config';
    if (!File(path).existsSync()) File(path).createSync(recursive: true);

    // copy contents to temporary config file
    File(path).writeAsStringSync(File(configPath).readAsStringSync());

    // TODO (EPIC CLI) pass cli options to config file

    var parser = _getParserForFileType(path);
    var configMap = parser.parse();
    return Configuration.fromMap(configMap);
  }

  String _findConfigurationFile() {
    var cwd = Directory.current.absolute;
    var fileNames = cwd.listSync().map((file) => file.path);

    for (var fileName in fileNames) {
      if (possibleConfigFiles.contains(fileName.split('/').last)) {
        _projectRoot = cwd.path;
        return '${_projectRoot}/${fileName}';
      }
      throw FileSystemException('Configuration file not found. Run this tool from your project root.');
    }

    return '';
  }

  AbstractConfigParser _getParserForFileType(String path) {
    var parsers = <AbstractConfigParser>[
      YamlConfigParser(path),
      JsonConfigParser(path),
    ];
    var filetype = path.split('.').last;

    for (var parser in parsers) {
      if (parser.runtimeType.toString().contains(filetype)) {
        return parser;
      }
    }
    
    throw UnknownConfigurationFormatException('No suitable Parser found for "${path}');
  }
}