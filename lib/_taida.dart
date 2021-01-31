import 'dart:io';

import 'package:taida/util/Pubspec.dart';

/// Path to the root of this library.
final TAIDA_LIBRARY_ROOT =
    Directory(Platform.script.path).absolute.parent.parent.path;
final TAIDA_LIBRARY_VERSION = Pubspec.load().version;
final TAIDA_EXECUTION_START = DateTime.now();
