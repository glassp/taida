import 'package:html/dom.dart';

class ModuleContent {
  static final List<Element> _headContents = [];
  static final List<Element> _bodyContents = [];
  static void registerContent(Element fragment,
      [bool includeInHtmlHead = true]) {
    if (includeInHtmlHead) {
      _headContents.add(fragment);
    } else {
      _bodyContents.add(fragment);
    }
  }

  static List<Element> get headContents => _headContents;
  static List<Element> get bodyContents => _bodyContents;
}
