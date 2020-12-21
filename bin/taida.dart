import 'dart:io';

import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/core/log/Logger.dart';
import 'package:taida/taida.dart';

void main(List<String> arguments) async {
  var start = DateTime.now();
  try {
    await runApp().run(arguments);
    var diff = DateTime.now().difference(start);
    var timeDiff =
        '${diff.inHours}h ${diff.inMinutes}m ${diff.inSeconds}s ${diff.inMilliseconds}ms';
    Logger.log(LogLabel.success, 'Build completed successful in $timeDiff');
  } on Exception {
    Logger.error(
        'Ran into an uncaught exception. If possible please report this error.');
    rethrow;
  } on Error {
    Logger.error(
        'Ran into a fatal error. This is thrown intentionally because some functionallity is not supposed to be used in this version.');
    rethrow;
    exit(1);
  }
}
