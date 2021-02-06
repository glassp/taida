part of '../MetaModule.dart';

class _PwaMetaData implements _SubModuleInterface {
  @override
  void run(MetaConfiguration moduleConfiguration) async {
    var mapping = await _createMapping(moduleConfiguration);
    for (final key in mapping.keys) {
      if (mapping[key] == null || mapping[key].isEmpty) continue;
      var element = Element.tag('meta');
      element.attributes.putIfAbsent('name', () => key);
      element.attributes.putIfAbsent('content', () => mapping[key]);
      ModuleContent.registerContent(element);
    }
    var webManifestIcons = await _createFavicon();
    await _createBrowserConfig(webManifestIcons, moduleConfiguration);
    await _createManifest(webManifestIcons, moduleConfiguration);
  }

  @override
  List<Watcher> get watchers {
    var config = ConfigurationLoader.load();
    var favicon =
        '${config.projectRoot}/${config.moduleConfiguration.meta.faviconImage}';
    var preview =
        '${config.projectRoot}/${config.moduleConfiguration.meta.previewImage}';
    return [FileWatcher(favicon), FileWatcher(preview)];
  }

  Future<Map<String, String>> _createMapping(
      MetaConfiguration moduleConfiguration) async {
    var mapping = <String, String>{};
    mapping.putIfAbsent('application-name', () => Pubspec.load().name);
    mapping.putIfAbsent(
        'msapplication-TileColor', () => moduleConfiguration.tilecolor);
    mapping.putIfAbsent('mobile-web-app-capable', () => 'yes');
    mapping.putIfAbsent('apple-mobile-web-app-capable', () => 'yes');
    mapping.putIfAbsent('apple.mobile-web-app-status-bar-style',
        () => moduleConfiguration.tilecolor);
    return mapping;
  }

  void _createManifest(List<WebManifestIcon> webManifestIcons,
      MetaConfiguration moduleConfiguration) async {
    var config = ConfigurationLoader.load();
    var manifest = WebManifest(
        name: Pubspec.load().name,
        shortName: moduleConfiguration.shortName,
        startUrl: moduleConfiguration.startUrl,
        display: moduleConfiguration.display,
        backgroundColor: moduleConfiguration.tilecolor,
        icons: webManifestIcons
            .map<WebManifestIcon>((icon) => icon.copyWith(
                src: icon.src.replaceFirst(config.outputDirectory, '')))
            .toList(),
        relatedApplications: moduleConfiguration.relatedApplications);
    for (final file in [
      File('${config.outputDirectory}/manifest.json'),
      File('${config.outputDirectory}/manifest.webmanifest')
    ]) {
      if (!await file.exists()) await file.create(recursive: true);
      await file.writeAsString(manifest.toString());
      var element = Element.tag('link');
      element.attributes.putIfAbsent('rel', () => 'manifest');
      element.attributes.putIfAbsent(
          'href', () => file.path.replaceFirst(config.outputDirectory, ''));
      ModuleContent.registerContent(element);
    }
  }

  void _createBrowserConfig(List<WebManifestIcon> webManifestIcons,
      MetaConfiguration moduleConfiguration) async {
    var config = ConfigurationLoader.load();
    var tags = <String>[];
    for (var icon in webManifestIcons) {
      for (var usage in icon.usage) {
        if (!usage.startsWith('square') && !usage.startsWith('wide')) continue;
        var tag =
            '<${usage}logo src="${icon.src.replaceFirst(config.outputDirectory, '')}"/>';
        tags.add(tag);
      }
    }
    var content =
        '<?xml version="1.0" encoding="utf-8"?><browserconfig><msapplication><tile>${tags.join()}<TileColor>${moduleConfiguration.tilecolor}</TileColor></tile></msapplication></browserconfig>';
    var outputFile = File('${config.outputDirectory}/browserconfig.xml');
    if (!await outputFile.exists()) await outputFile.create(recursive: true);
    await outputFile.writeAsString(content);
    var element = Element.tag('meta');
    element.attributes.putIfAbsent('name', () => 'msapplication-config');
    element.attributes.putIfAbsent('content',
        () => outputFile.path.replaceFirst(config.outputDirectory, ''));
    ModuleContent.registerContent(element);
  }

  Future<List<WebManifestIcon>> _createFavicon() async {
    var config = ConfigurationLoader.load();
    var icons = <WebManifestIcon>[
      WebManifestIcon(height: 32, width: 32, usage: ['icon']),
      WebManifestIcon(height: 76, width: 76, usage: ['icon', 'square70x70']),
      WebManifestIcon(height: 96, width: 96, usage: ['icon']),
      WebManifestIcon(height: 128, width: 128, usage: ['apple-touch-icon']),
      WebManifestIcon(
          height: 144, width: 144, usage: ['msapplication-TileImage']),
      WebManifestIcon(height: 180, width: 180, usage: ['apple-touch-icon']),
      WebManifestIcon(height: 196, width: 196, usage: ['icon']),
      WebManifestIcon(height: 270, width: 270, usage: ['square270x270']),
      WebManifestIcon(height: 310, width: 310, usage: ['square310x310']),
      WebManifestIcon(height: 150, width: 310, usage: ['wide310x150']),
    ];
    var webManifestIcons = <WebManifestIcon>[];
    var formats = <String>['avif', 'webp', 'jpeg'];
    var converter = ImageConverter(File(
        '${config.projectRoot}/${config.moduleConfiguration.meta.faviconImage}'));
    for (var icon in icons) {
      for (var format in formats) {
        var binaryData =
            await converter.convertTo(format, icon.height, icon.width);
        var outputFile = File(
            '${config.outputDirectory}/assets/favicon/favicon-${icon.width}x${icon.height}.${format}');
        if (!await outputFile.exists()) {
          await outputFile.create(recursive: true);
        }
        await outputFile.writeAsBytes(binaryData);
        for (var tag in icon.usage) {
          Element element;
          if (tag == 'icon' || tag == 'apple-touch-icon') {
            element = Element.tag('link');
            element.attributes.putIfAbsent('rel', () => tag);
            element.attributes.putIfAbsent('href',
                () => outputFile.path.replaceFirst(config.outputDirectory, ''));
            element.attributes
                .putIfAbsent('sizes', () => icon.toJson()['sizes']);
            element.attributes.putIfAbsent('type', () => 'image/${format}');
          } else if (tag == 'msapplication-TileImage') {
            element = Element.tag('meta');
            element.attributes.putIfAbsent('name', () => tag);
            element.attributes.putIfAbsent('content',
                () => outputFile.path.replaceFirst(config.outputDirectory, ''));
          }
          if (element != null) ModuleContent.registerContent(element);
          webManifestIcons.add(WebManifestIcon(
              usage: [tag],
              src: outputFile.path,
              height: icon.height,
              width: icon.width,
              type: 'image/${format}'));
        }
      }
    }
    return webManifestIcons;
  }
}
