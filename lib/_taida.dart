// ignore_for_file: non_constant_identifier_names
// all identifiers in this file are pseudo-constants
import 'dart:io';

/// Path to the root of this library.
final TAIDA_LIBRARY_ROOT =
    Directory(Platform.script.path).absolute.parent.parent.path;

/// the start time of the execution of taida
final TAIDA_EXECUTION_START = DateTime.now();
