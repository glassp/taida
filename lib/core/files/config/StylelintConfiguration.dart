import 'dart:io';

import '../../../_taida.dart';

/// the fallbacl stylelint configuration
class StylelintConfiguration {
  /// the stylelintrc config
  String stylelintrc = """
extends:
  - stylelint-config-standard
  - stylelint-config-prettier
rules:
  indentation: 4
""";

  /// creates the .stylelintrc.yaml file
  void createStylelintrcYaml() async {
    var file = File('$TAIDA_LIBRARY_ROOT/config/.stylelint.yaml');
    if (!await file.exists()) await file.create(recursive: true);
    await file.writeAsString(stylelintrc);
  }
}
