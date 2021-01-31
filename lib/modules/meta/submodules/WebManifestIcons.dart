class WebManifestIcon {
  final String src;
  final String sizes;
  final String type;

  const WebManifestIcon({
    this.src,
    this.sizes,
    this.type,
  });

  @override
  String toString() => toJson.toString();

  factory WebManifestIcon.fromJson(Map<String, dynamic> json) {
    return WebManifestIcon(
      src: json['src'] as String,
      sizes: json['sizes'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'src': src,
      'sizes': sizes,
      'type': type,
    };
  }
}
