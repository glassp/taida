import 'dart:convert';

class RelatedApplications {
  final String platform;
  final String url;

  const RelatedApplications({this.platform, this.url});

  @override
  String toString() => jsonEncode(toJson());

  factory RelatedApplications.fromJson(Map<String, dynamic> json) {
    return RelatedApplications(
      platform: json['platform'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'url': url,
    };
  }
}
