import 'dart:io';

import 'package:taida/Exception/Failure/FailureException.dart';
import 'package:taida/_taida.dart';
import 'package:taida/core/config/ConfigurationLoader.dart';
import 'package:taida/core/log/Logger.dart';

class ImageConverter {
  final File sourceFile;

  ImageConverter(this.sourceFile);

  /// Converts the data of the file to the given `format`, `height` and `width` and returns the binary data.
  Future<List<int>> convertTo(String format, [int height, int width]) async {
    if (!await _temporaryFile.exists()) {
      await _temporaryFile.create(recursive: true);
    } else {
      await _temporaryFile.writeAsString('',
          flush: true); // Enforce file to be empty
    }
    var process = await Process.run(
      'node',
      [
        '-e',
        buildConvertScript(sourceFile.absolute.path, height, width, format)
      ],
      workingDirectory: TAIDA_LIBRARY_ROOT,
    );
    if (await process.exitCode != 0) {
      Logger.error(process.stderr);
      Logger.emptyLines();
      throw FailureException(
          'Error in image convertion. Failed to convert ${sourceFile.path}');
    }
    return await _temporaryFile.readAsBytes();
  }

  File get _temporaryFile {
    var config = ConfigurationLoader.load();
    return File('${config.workingDirectory}/imageConverter/image.temp');
  }

  String buildConvertScript(
          String filename, int height, int width, String format) =>
      '''
      const sharp = require("sharp");
      let inputFile = "${filename}"
      let outputFile = "${_temporaryFile.absolute.path}"
      let format = "${format}"
      let height = "${height}" == 'null' ? null : Number.parseInt("${height}") || null
      let width = "${width}" == 'null' ? null : Number.parseInt("${width}") || null
      sharp(inputFile)
      .resize(width, height)
      .toFormat(format)
      .toFile(outputFile)
      .then((_) => process.exit(0))
      .catch((e) => {
          console.error(e)
          process.exit(1)
      })
    ''';
}
