part of '../MetaModule.dart';

class _SeoMetaData implements _SubModuleInterface {
  @override
  void run(MetaConfiguration moduleConfiguration) async {
    var config = ConfigurationLoader.load();
    String previewImagePath;
    if (moduleConfiguration.previewImage != null) {
      var previewImagePath =
          '${config.projectRoot}/${moduleConfiguration.previewImage}';
      var converter = ImageConverter(File(previewImagePath));
      var binaryImage = await converter.convertTo('jpeg', 627, 1200);
      var previewImage =
          await File('${config.outputDirectory}/assets/previewImage.jpeg')
              .create(recursive: true);
      await previewImage.writeAsBytes(binaryImage);
    } else {}
    var mapping = _createMapping(moduleConfiguration, previewImagePath);
    for (final key in mapping.keys) {
      if (mapping[key] == null || mapping[key].isEmpty) continue;
      var element = Element.tag('meta');
      element.attributes.putIfAbsent('name', () => key);
      element.attributes.putIfAbsent('content', () => mapping[key]);
      ModuleContent.registerContent(element);
    }
    ModuleContent.registerContent(Element.html('<meta charset="UTF-8">'));
    ModuleContent.registerContent(Element.html(
        '<meta http-equiv="content-type" content="text/html; charset=utf-8">'));
  }

  @override
  List<Watcher> get watchers {
    var config = ConfigurationLoader.load();
    var previewImagePath =
        '${config.projectRoot}/${config.moduleConfiguration.meta.previewImage}';
    return [FileWatcher(previewImagePath)];
  }

  Map<String, String> _createMapping(
      MetaConfiguration moduleConfiguration, String previewImagePath) {
    var config = ConfigurationLoader.load();
    var mapping = <String, String>{};
    mapping.putIfAbsent('twitter:card', () => moduleConfiguration.twitter.type);
    mapping.putIfAbsent(
        'twitter:creator', () => moduleConfiguration.twitter.creator);
    mapping.putIfAbsent('twitter:site', () => moduleConfiguration.twitter.site);
    mapping.putIfAbsent(
        'og:site_name', () => moduleConfiguration.openGraph.site);
    mapping.putIfAbsent('og:type', () => moduleConfiguration.openGraph.type);
    mapping.putIfAbsent(
        'keywords', () => moduleConfiguration.keywords.join(', '));
    if (previewImagePath != null) {
      mapping.putIfAbsent('og:image',
          () => previewImagePath.replaceFirst(config.outputDirectory, ''));
      mapping.putIfAbsent('twitter:image',
          () => previewImagePath.replaceFirst(config.outputDirectory, ''));
    }
    return mapping;
  }
}
