import 'dart:io';

import '../../../_taida.dart';

/// the fallback prettier configuration
class PrettierConfiguration {
  /// config as map
  final Map<String, String> prettierrc = {
    "tabWidth": "4",
    "singleQuote": "true",
    "quoteProps": "consistent",
    "jsxSingleQuote": "true",
    "trailingComma": "es5",
    "bracketSpacing": "false",
    "arrowParens": "always",
    "endOfLine": "lf"
  };

  /// creates the .prettierrc.yaml file
  void createPrettierrcYaml() async {
    var file = File('$TAIDA_LIBRARY_ROOT/config/.prettierrc.yaml');
    if (!await file.exists()) await file.create(recursive: true);
    for (var entry in prettierrc.entries) {
      await file.writeAsString("${entry.key}: ${entry.value}",
          mode: FileMode.append);
    }
  }

  /// creates the .prettierignore file
  void createPrettierIgnore() async {
    var file = File('$TAIDA_LIBRARY_ROOT/config/.prettierignore');
    if (!await file.exists()) await file.create(recursive: true);
  }
}
