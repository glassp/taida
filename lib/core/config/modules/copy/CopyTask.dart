import 'dart:convert';

class CopyTask {
  final List<String> from;
  final String to;

  const CopyTask({this.from, this.to});

  @override
  String toString() => jsonEncode(toJson());

  factory CopyTask.fromJson(Map<String, dynamic> json) {
    return CopyTask(
      from: (json['from'] as List<dynamic>)
          ?.map<String>((e) => e.toString())
          ?.toList(),
      to: json['to'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
    };
  }
}
