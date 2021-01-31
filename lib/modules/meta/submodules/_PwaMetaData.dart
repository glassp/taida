part of '../MetaModule.dart';

class _PwaMetaData implements _SubModuleInterface {
  @override
  void run(dynamic moduleConfiguration) async {
    var mapping = await _createMapping(moduleConfiguration);
    for (final key in mapping.keys) {
      if (mapping[key] == null || mapping[key].isEmpty) continue;
      var element = Element.tag('meta');
      element.attributes.putIfAbsent('name', () => key);
      element.attributes.putIfAbsent('content', () => mapping[key]);
      ModuleContent.registerContent(element);
    }
    var webManifestIcons = await _createFavicon();
    await _createBrowserConfig();
    await _createManifest(webManifestIcons, moduleConfiguration);
  }

  @override
  // TODO: implement watchers
  List<Watcher> get watchers => [];

  Future<Map<String, String>> _createMapping(
      dynamic moduleConfiguration) async {
    var mapping = <String, String>{};
    mapping.putIfAbsent('application-name', () => Pubspec.load().name);
    mapping.putIfAbsent(
        'msapplication-TileColor', () => moduleConfiguration['tilecolor']);
    mapping.putIfAbsent('mobile-web-app-capable', () => 'yes');
    mapping.putIfAbsent('apple-mobile-web-app-capable', () => 'yes');
    mapping.putIfAbsent('apple.mobile-web-app-status-bar-style',
        () => moduleConfiguration['tilecolor']);
    return mapping;
  }

  void _createManifest(List<WebManifestIcon> webManifestIcons,
      dynamic moduleConfiguration) async {
    var relatedApplications = <WebManifestRelatedApplication>[];
    for (var config in moduleConfiguration['related_applications']) {
      var app = WebManifestRelatedApplication(
          platform: config['platform'], url: config['url']);
      relatedApplications.add(app);
    }
    var manifest = WebManifest(
        name: Pubspec.load().name,
        shortName: moduleConfiguration['short_name'],
        startUrl: moduleConfiguration['start_url'],
        display: moduleConfiguration['display'],
        backgroundColor: moduleConfiguration['tileColor'],
        icons: webManifestIcons,
        relatedApplications: relatedApplications);
    var config = ConfigurationLoader.load();
    for (final file in [
      File('${config.outputDirectory}/manifest.json'),
      File('${config.outputDirectory}/manifest.webmanifest')
    ]) {
      if (!await file.exists()) await file.create(recursive: true);
      await file.writeAsString(manifest.toString());
      var element = Element.tag('link');
      element.attributes.putIfAbsent('rel', () => 'manifest');
      element.attributes.putIfAbsent('href', () => file.path);
      ModuleContent.registerContent(element);
    }
  }

  void _createBrowserConfig() async {
    
  }

  Future<List<WebManifestIcon>> _createFavicon() async {
    // TODO create link tag from favicon
    // TODO create meta tag msapplication-square{70x70, 150x150, 310x310}logo from config favicon
    return [];
  }
}
