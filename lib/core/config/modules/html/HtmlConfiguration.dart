// ignore_for_file: public_member_api_docs
import 'dart:convert';

class HtmlConfiguration {
  final String templatesDirectory;
  final String pagesDirectory;
  final String partialsDirectory;

  const HtmlConfiguration({
    this.templatesDirectory,
    this.pagesDirectory,
    this.partialsDirectory,
  });

  @override
  String toString() => jsonEncode(toJson());

  factory HtmlConfiguration.fromJson(Map<String, dynamic> json) {
    return HtmlConfiguration(
      templatesDirectory: json['templates_directory'] as String,
      pagesDirectory: json['pages_directory'] as String,
      partialsDirectory: json['partials_directory'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'templates_directory': templatesDirectory,
      'pages_directory': pagesDirectory,
      'partials_directory': partialsDirectory,
    };
  }
}
