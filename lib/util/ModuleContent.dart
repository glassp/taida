// ignore_for_file: avoid_classes_with_only_static_members
import 'package:html/dom.dart';

/// The output of each module is registered here
class ModuleContent {
  static final List<Element> _headContents = [];
  static final List<Element> _bodyContents = [];

  /// register the output for a module
  static void registerContent(Element fragment,
      {bool includeInHtmlHead = true}) {
    if (includeInHtmlHead) {
      _headContents.add(fragment);
    } else {
      _bodyContents.add(fragment);
    }
  }

  /// return the list of contents in the head part of a file
  static List<Element> get headContents => _headContents;

  /// return the list of contents in the body part of a file
  static List<Element> get bodyContents => _bodyContents;
}
