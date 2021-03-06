// ignore_for_file: public_member_api_docs
import 'dart:convert';

import './modules/copy/CopyTask.dart';
import './modules/dart/DartTask.dart';
import './modules/html/HtmlConfiguration.dart';
import './modules/meta/MetaConfiguration.dart';
import './modules/scss/ScssTask.dart';

/// wrapper for the module configurstions
class ModuleConfiguration {
  final List<CopyTask> copy;
  final List<ScssTask> scss;
  final List<DartTask> dart;
  final HtmlConfiguration html;
  final MetaConfiguration meta;

  const ModuleConfiguration({
    this.copy,
    this.scss,
    this.dart,
    this.html,
    this.meta,
  });

  @override
  String toString() => jsonEncode(toJson);

  factory ModuleConfiguration.fromJson(Map<String, dynamic> json) {
    return ModuleConfiguration(
      copy: json['copy']?.map<CopyTask>((e) {
        return e == null ? null : CopyTask.fromJson(e as Map<String, dynamic>);
      })?.toList(),
      scss: json['scss']?.map<ScssTask>((e) {
        return e == null ? null : ScssTask.fromJson(e as Map<String, dynamic>);
      })?.toList(),
      dart: json['dart']?.map<DartTask>((e) {
        return e == null ? null : DartTask.fromJson(e as Map<String, dynamic>);
      })?.toList(),
      html: json['html'] == null
          ? null
          : HtmlConfiguration.fromJson(json['html'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : MetaConfiguration.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'copy': copy?.map((e) => e?.toJson())?.toList(),
      'scss': scss?.map((e) => e?.toJson())?.toList(),
      'dart': dart?.map((e) => e?.toJson())?.toList(),
      'html': html?.toJson(),
      'meta': meta?.toJson(),
    };
  }
}
