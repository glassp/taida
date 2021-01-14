import 'dart:io';

import 'package:yaml/yaml.dart';

/// Path to the root of this library.
final TAIDA_LIBRARY_ROOT =
    Directory(Platform.script.path).absolute.parent.parent.path;
final TAIDA_LIBRARY_VERSION = loadYaml(
    File(TAIDA_LIBRARY_ROOT + '/pubspec.yaml').readAsStringSync())['version'];
