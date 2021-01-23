import 'dart:io';

import 'package:taida/core/log/Logger.dart';

class DirectoryCopy {
  /// Recursive copy of all Dirs and Files in `source` to `destination`.
  /// Also returns a list of all files that have been copied
  static Future<List<File>> copy(
      Directory source, Directory destination) async {
    if (!await source.exists()) {
      Logger.warn('${source.path} does not exist. Skipping...');
      return [];
    }
    var files = <File>[];
    var elements = source.listSync();
    for (var entity in elements) {
      var name = entity.path.split('/').last;
      if (entity is Directory) {
        Logger.verbose(
            'Copying file ${source.path}/$name to ${destination.path}/$name');
        var subdir = Directory(destination.path + '/' + name);
        await subdir.create(recursive: true);
        var results = await copy(entity, subdir);
        files.addAll(results);
      } else if (entity is File) {
        if (!await destination.exists()) {
          await destination.create(recursive: true);
        }
        Logger.verbose(
            'Copying file ${source.path}/$name to ${destination.path}/$name');
        var file = File(destination.path + '/' + name);
        files.add(file);
        await entity.copy(file.path);
      }
    }
    return files;
  }
}
