// ignore_for_file: public_member_api_docs
import 'dart:convert';

import '../../../core/config/modules/meta/RelatedApplications.dart';

import 'WebManifestIcons.dart';

class WebManifest {
  final String name;
  final String shortName;
  final String startUrl;
  final String display;
  final String backgroundColor;
  final String description;
  final List<WebManifestIcon> icons;
  final List<RelatedApplications> relatedApplications;

  const WebManifest({
    this.name,
    this.shortName,
    this.startUrl,
    this.display,
    this.backgroundColor,
    this.description,
    this.icons,
    this.relatedApplications,
  });

  @override
  String toString() => jsonEncode(toJson());

  factory WebManifest.fromJson(Map<String, dynamic> json) {
    return WebManifest(
      name: json['name'] as String,
      shortName: json['short_name'] as String,
      startUrl: json['start_url'] as String,
      display: json['display'] as String,
      backgroundColor: json['background_color'] as String,
      description: json['description'] as String,
      icons: (json['icons'] as List<WebManifestIcon>)?.map((e) {
        return e == null
            ? null
            : WebManifestIcon.fromJson(e as Map<String, dynamic>);
      })?.toList(),
      relatedApplications:
          (json['related_applications'] as List<RelatedApplications>)?.map((e) {
        return e == null
            ? null
            : RelatedApplications.fromJson(e as Map<String, dynamic>);
      })?.toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'short_name': shortName,
      'start_url': startUrl,
      'display': display,
      'background_color': backgroundColor,
      'description': description,
      'icons': icons?.map((e) => e?.toJson())?.toList(),
      'related_applications':
          relatedApplications?.map((e) => e?.toJson())?.toList(),
    };
  }
}
