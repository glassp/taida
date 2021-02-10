// ignore_for_file: public_member_api_docs
import 'dart:convert';

class DartTask {
  final String entry;
  final String output;

  const DartTask({this.entry, this.output});

  @override
  String toString() => jsonEncode(toJson());

  factory DartTask.fromJson(Map<String, dynamic> json) {
    return DartTask(
      entry: json['entry'] as String,
      output: json['output'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entry': entry,
      'output': output,
    };
  }
}
