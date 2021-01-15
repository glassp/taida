import 'dart:io';

import 'package:taida/Exception/Failure/FailureException.dart';
import 'package:taida/_taida.dart';
import 'package:taida/core/log/LogLabel.dart';
import 'package:taida/core/log/Logger.dart';
import 'package:taida/taida.dart';

void main(List<String> arguments) async {
  var start = TAIDA_EXECUTION_START;
  try {
    await runApp().run(arguments);
    var config = ConfigurationLoader.load();
    if (!config.watch) {
      Logger.emptyLines();
      var diff = DateTime.now().difference(start);
      var timeDiff =
          '${diff.inHours}h ${diff.inMinutes}m ${diff.inSeconds}s ${diff.inMilliseconds}ms';

      Logger.log(LogLabel.success, 'Build completed successful in $timeDiff');
    }
  } on FailureException catch (e) {
    Logger.emptyLines();
    Logger.error(e.toString());
    exit(1);
  } on Exception {
    Logger.emptyLines();
    Logger.error(
        'Ran into an uncaught exception. If possible please report this error.');
    rethrow;
  } on Error {
    Logger.emptyLines();
    Logger.error('Ran into a fatal error. ');
    rethrow;
  }
}
