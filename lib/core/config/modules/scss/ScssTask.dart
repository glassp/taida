import 'dart:convert';

class ScssTask {
  final String entry;
  final String output;
  final String media;

  const ScssTask({
    this.entry,
    this.output,
    this.media,
  });

  @override
  String toString() => jsonEncode(toJson());

  factory ScssTask.fromJson(Map<String, dynamic> json) {
    return ScssTask(
      entry: json['entry'] as String,
      output: json['output'] as String,
      media: json['media'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entry': entry,
      'output': output,
      'media': media,
    };
  }
}
