import 'dart:convert';

class OpenGraph {
  final String type;
  final String site;

  const OpenGraph({this.type, this.site});

  @override
  String toString() => jsonEncode(toJson());

  factory OpenGraph.fromJson(Map<String, dynamic> json) {
    return OpenGraph(
      type: json['type'] as String,
      site: json['site'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'site': site,
    };
  }
}
