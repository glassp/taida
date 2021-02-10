import 'package:ansicolor/ansicolor.dart';

/// Used to prettify the Logs
class LogLabel {
  /// the title of the loglabel
  final String title;
  /// the styling of the label
  final AnsiPen style;

  /// constructs a label
  const LogLabel(this.title, this.style);

  @override
  String toString() => '${style.write(title.padRight(15).padLeft(16))} ';

  /// utility getter for success label
  static LogLabel get success =>
      LogLabel('Success', AnsiPen()..green(bg: true));

  /// utility getter for config label
  static LogLabel get config =>
      LogLabel('Configuration', AnsiPen()..cyan(bg: true));

  /// utility getter for error label
  static LogLabel get error =>
      LogLabel('Error', AnsiPen()..xterm(88, bg: true));

  /// utility getter for warning label
  static LogLabel get warning => LogLabel(
      'Warning',
      AnsiPen()
        ..yellow(bg: true)
        ..black());

  /// utility getter for debug label
  static LogLabel get debug =>
      LogLabel('Debug', AnsiPen()..xterm(236, bg: true));

  /// utility getter for verbose label
  static LogLabel get verbose => LogLabel(
      'Verbose',
      AnsiPen()
        ..white(bg: true)
        ..black());
}
