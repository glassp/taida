import 'dart:io';

/// Path to the root of this library.
final TAIDA_LIBRARY_ROOT =
    Directory(Platform.script.path).absolute.parent.parent.path;
final TAIDA_EXECUTION_START = DateTime.now();
