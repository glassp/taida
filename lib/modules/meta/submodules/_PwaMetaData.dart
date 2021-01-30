part of '../MetaModule.dart';

class _PwaMetaData implements _SubModuleInterface {
  @override
  void run(dynamic moduleConfiguration) {
    // TODO create meta tag from pubspec.name
    // TODO create meta tag from config tilecolor
    // TODO create meta tag msapplication-square{70x70, 150x150, 310x310}logo from config favicon
    // TODO create link tag from favicon
    // TODO create meta tag {'', apple}-mobile-web-app-capable = yes
    // TODO create meta tag app-mobile-web-app-status-bar-style from config tilecolor
    // TODO create link tag for manifest.{json, webmanifest}
    // TODO create meta tag msapplication-config for browserconfig.xml
  }

  @override
  // TODO: implement watchers
  List<Watcher> get watchers => [];
}
