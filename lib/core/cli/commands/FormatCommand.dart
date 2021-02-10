import '../BaseCommand.dart';

/// Command that invokes the format process
class FormatCommand extends BaseCommand {
  @override
  String get description => 'Runs various formaters';

  @override
  String get name => 'format';
}
