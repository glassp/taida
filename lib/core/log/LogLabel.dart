import 'package:ansicolor/ansicolor.dart';

/// Used to prettify the Logs
class LogLabel {
  final String message;
  final AnsiPen style;

  const LogLabel(this.message, this.style);

  @override
  String toString() => '${style.write(message.padRight(15).padLeft(16))} ';

  static LogLabel get success =>
      LogLabel('Success', AnsiPen()..green(bg: true));

  static LogLabel get config =>
      LogLabel('Configuration', AnsiPen()..cyan(bg: true));

  static LogLabel get error =>
      LogLabel('Error', AnsiPen()..xterm(88, bg: true));

  static LogLabel get warning => LogLabel(
      'Warning',
      AnsiPen()
        ..yellow(bg: true)
        ..black());

  static LogLabel get debug =>
      LogLabel('Debug', AnsiPen()..xterm(236, bg: true));

  static LogLabel get verbose => LogLabel(
      'Verbose',
      AnsiPen()
        ..white(bg: true)
        ..black());
}
