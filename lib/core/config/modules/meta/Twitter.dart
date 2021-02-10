// ignore_for_file: public_member_api_docs
import 'dart:convert';

class Twitter {
  final String type;
  final String creator;
  final String site;

  const Twitter({
    this.type,
    this.creator,
    this.site,
  });

  @override
  String toString() => jsonEncode(toJson());

  factory Twitter.fromJson(Map<String, dynamic> json) {
    return Twitter(
      type: json['type'] as String,
      creator: json['creator'] as String,
      site: json['site'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'creator': creator,
      'site': site,
    };
  }
}
