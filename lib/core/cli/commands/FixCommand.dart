import 'package:taida/core/cli/BaseCommand.dart';

class FixCommand extends BaseCommand {
  @override
  String get description =>
      'Fixes problems detected by `taida analyze` as good as possible.';

  @override
  String get name => 'fix';
}
