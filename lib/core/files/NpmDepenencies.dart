import 'dart:convert';
import 'dart:io';

import '../../_taida.dart';

/// npm dependencies installer
class NpmDependencies {
  /// the package.json content
  final packageJson = {
    "dependencies": {
      "prettier": "2.2.1",
      "sharp": "0.27.1",
      "stylelint": "13.8.0",
      "stylelint-config-standard": "20.0.0",
      "stylelint-config-prettier": "8.0.2",
      "stylelint-scss": "3.18.0"
    }
  };

  /// creates the package.json file with the data from `packageJson`
  void createPackageJson() async {
    var file = File('$TAIDA_LIBRARY_ROOT/package.json');
    if (!await file.exists()) await file.create();
    await file.writeAsString(jsonEncode(packageJson));
  }
}
