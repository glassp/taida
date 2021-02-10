// ignore_for_file: public_member_api_docs
import 'dart:convert';

import 'OpenGraph.dart';
import 'RelatedApplications.dart';
import 'Twitter.dart';

class MetaConfiguration {
  final String tilecolor;
  final String shortName;
  final String startUrl;
  final String display;
  final String faviconImage;
  final String previewImage;
  final List<String> keywords;
  final Twitter twitter;
  final OpenGraph openGraph;
  final List<RelatedApplications> relatedApplications;

  const MetaConfiguration({
    this.tilecolor,
    this.shortName,
    this.startUrl,
    this.display,
    this.faviconImage,
    this.previewImage,
    this.keywords,
    this.twitter,
    this.openGraph,
    this.relatedApplications,
  });

  @override
  String toString() => jsonEncode(toJson());

  factory MetaConfiguration.fromJson(Map<String, dynamic> json) {
    return MetaConfiguration(
      tilecolor: json['tilecolor'] as String,
      shortName: json['short_name'] as String,
      startUrl: json['start_url'] as String,
      display: json['display'] as String,
      faviconImage: json['favicon_image'] as String,
      previewImage: json['preview_image'] as String,
      keywords: (json['keywords'] as List<dynamic>)
          ?.map<String>((e) => e.toString())
          ?.toList(),
      twitter: json['twitter'] == null
          ? null
          : Twitter.fromJson(json['twitter'] as Map<String, dynamic>),
      openGraph: json['open_graph'] == null
          ? null
          : OpenGraph.fromJson(json['open_graph'] as Map<String, dynamic>),
      relatedApplications: (json['related_applications'] as List<dynamic>)
          ?.map<RelatedApplications>((e) {
        return e == null
            ? null
            : RelatedApplications.fromJson(e as Map<String, dynamic>);
      })?.toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tilecolor': tilecolor,
      'short_name': shortName,
      'start_url': startUrl,
      'display': display,
      'favicon_image': faviconImage,
      'preview_image': previewImage,
      'keywords': keywords,
      'twitter': twitter?.toJson(),
      'open_graph': openGraph?.toJson(),
      'related_applications':
          relatedApplications?.map((e) => e?.toJson())?.toList(),
    };
  }
}
