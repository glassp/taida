class WebManifestRelatedApplication {
  final String platform;
  final String url;

  const WebManifestRelatedApplication({this.platform, this.url});

  @override
  String toString() {
    return 'RelatedApplications(platform: $platform, url: $url)';
  }

  factory WebManifestRelatedApplication.fromJson(Map<String, dynamic> json) {
    return WebManifestRelatedApplication(
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
