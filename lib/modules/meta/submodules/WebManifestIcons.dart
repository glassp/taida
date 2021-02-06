class WebManifestIcon {
  final String src;
  final int height;
  final int width;
  final String type;
  final List<String> usage;

  const WebManifestIcon({
    this.height,
    this.width,
    this.src,
    this.type,
    this.usage,
  });

  @override
  String toString() => toJson.toString();
  String get sizes => '${width}x${height}';

  factory WebManifestIcon.fromJson(Map<String, dynamic> json) {
    return WebManifestIcon(
      src: json['src'] as String,
      height: int.parse(json['sizes'].split('x')[1]),
      width: int.parse(json['sizes'].split('x')[0]),
      type: json['type'] as String,
      usage: <String>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'src': src,
      'sizes': '${sizes}',
      'type': type,
    };
  }

  WebManifestIcon copyWith({
    int height,
    int width,
    String src,
    String type,
    List<String> usage,
  }) {
    return WebManifestIcon(
        height: height ?? this.height,
        width: width ?? this.width,
        src: src ?? this.src,
        type: type ?? this.type,
        usage: usage ?? this.usage);
  }
}
