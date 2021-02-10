part of 'HtmlModule.dart';

/// class for preprocessing the html file.
/// Should only be invoked by [HtmlModule._build()]
class _DOM {
  final File file;
  final HtmlModule module;

  _DOM(this.file, this.module);

  /// recursively replaces all taida tags
  void _replaceTaidaTags() async {
    var config = ConfigurationLoader.load();
    var tree = parse(await file.readAsString());
    for (var tag in tree.querySelectorAll('taida')) {
      var sourcePath = resolvePath(tag.attributes['src']);
      if (sourcePath.startsWith(config.workingDirectory)) {
        sourcePath = sourcePath.replaceFirst('${config.workingDirectory}/html/',
            config.moduleConfiguration.html.templatesDirectory);
      }
      if (!sourcePath.endsWith('.html')) {
        sourcePath = '$sourcePath.html';
      }
      var selector = tag.attributes['selector'] ?? 'body';
      var sourceFile = File(sourcePath);
      var dom = parse(await sourceFile.readAsString());
      var element = dom.querySelector(selector);
      if (config.debug) {
        var comment = Comment('SOURCE: ${sourceFile.absolute.path}');
        tag.parent.insertBefore(comment, tag);
      }
      if (element.children.length > 1) {
        tag.replaceWith(Element.tag('div'));
        for (var node in element.children) {
          tag.append(node);
        }
      } else {
        tag.replaceWith(element.firstChild);
      }
    }
    await file.writeAsString(tree.outerHtml);
    if (tree.querySelectorAll('taida').isNotEmpty) {
      _replaceTaidaTags();
    }
  }

  /// replace <seo> tags with corresponding meta tags
  void _replaceSeoTags() async {
    var tree = parse(await file.readAsString());
    for (var tag in tree.querySelectorAll('seo')) {
      var type = tag.attributes['type'];
      var content = tag.text;
      for (var prefix in ['', 'twitter:', 'og:']) {
        if (prefix == '' && type == 'title') {
          var title = Element.tag('title');
          title.text = content;
          tree.head.append(title);
        }
        var element = Element.tag('meta');
        element.attributes.putIfAbsent('name', () => '$prefix$type');
        element.attributes.putIfAbsent('content', () => content);
        tree.head.append(element);
      }
      tag.remove();
    }
    await file.writeAsString(tree.outerHtml);
  }

  double _convertSize(String size) {
    if (size == null || size.isEmpty) return 0;
    var number = double.tryParse(size.replaceAll(RegExp(r'[a-zA-Z]'), '')) ?? 0;
    var format = size.replaceAll(RegExp(r'[0-9\.]'), '');
    if (format == 'px') return number;
    if (format == 'rem') {
      return number * 16;
    }
    return 0;
  }

  void _replaceImageTags() async {
    var tree = parse(await file.readAsString());
    var config = ConfigurationLoader.load();
    for (var tag in tree.querySelectorAll('img')) {
      if (tag.parent.localName == 'picture') continue;
      if (!tag.attributes.containsKey('src') &&
          !tag.attributes.containsKey('height') &&
          !tag.attributes.containsKey('width')) continue;
      var path = tag.attributes['src'];
      var resolvedPath = resolvePath(path);
      if (path == resolvedPath && !path.startsWith(config.projectRoot)) {
        if (path.startsWith('/')) path = path.replaceFirst('/', '');
        path = '${config.outputDirectory}/$path';
      }
      var sourceFile = File(path);
      var converter = ImageConverter(sourceFile);
      var heightString = tag.attributes['height'];
      var widthString = tag.attributes['width'];
      var height = _convertSize(heightString);
      var width = _convertSize(widthString);
      var elements = <Element>[];
      var extensions = <String>['avif', 'webp', 'jpeg'];
      var breadcrumb = path.split('.');
      breadcrumb.removeLast();
      path = breadcrumb.join('.');
      if (height <= 1 || width <= 1) continue;
      for (var ext in extensions) {
        var file = File('$path-${height.ceil()}x${width.ceil()}.$ext');
        if (!await file.exists()) {
          var data =
              await converter.convertTo(ext, height.ceil(), width.ceil());
          await file.create();
          await file.writeAsBytes(data);
        }
        Element element;
        if (ext == 'jpeg') {
          element = Element.tag('img');
          element.attributes.putIfAbsent(
              'src', () => file.path.replaceFirst(config.outputDirectory, ''));
          element.attributes.putIfAbsent('height', () => height.toString());
          element.attributes.putIfAbsent('width', () => width.toString());
          element.attributes.putIfAbsent('loading', () => 'lazy');
          element.attributes.putIfAbsent('alt', () => tag.attributes['alt']);
        } else {
          element = Element.tag('source');
          element.attributes.putIfAbsent('type', () => 'image/$ext');
          element.attributes.putIfAbsent('srcset',
              () => file.path.replaceFirst(config.outputDirectory, ''));
        }
        elements.add(element);
      }
      var element = Element.tag('picture');
      for (var e in elements) {
        element.append(e);
      }
      tag.replaceWith(element);
    }
    await file.writeAsString(tree.outerHtml);
  }

  /// replaces all <react> tags with generic divs
  /// also adds a comment in debug modue to get a better
  ///  understanding of where component mounts
  void _replaceReactTags() async {
    var config = ConfigurationLoader.load();
    var content = await file.readAsString();
    if (config.debug) {
      var tree = parse(content);
      for (var tag in tree.querySelectorAll('react')) {
        var comment = Comment('Mountpoint for React');
        tag.parent.insertBefore(comment, tag);
      }
      content = tree.outerHtml;
    }
    content.replaceAll('<react', '<div');
    await file.writeAsString(content);
  }

  /// removes any html comment
  void _removeComments() async {
    var text =
        (await file.readAsString()).replaceAll(RegExp(r'^<--.*-->$'), '');
    await file.writeAsString(text);
  }

  /// returns the relative filepath to the workingDirectory
  String _relativeFilePath() {
    var path = file.path;
    var config = ConfigurationLoader.load();
    return path.replaceAll('${config.workingDirectory}/html/', '');
  }

  /// creates a output
  void buildPage() async {
    var config = ConfigurationLoader.load();
    if (!config.debug && isPartial()) return;
    await _replaceSeoTags();
    await _replaceTaidaTags();
    await _replaceReactTags();
    await _addModuleContent();
    await _replaceImageTags();
    await _sortHeadTags();
    if (!config.debug) {
      await _removeComments();
      await _minify();
    }
    var subDirectory = isPartial() ? '_layout/' : '';
    var path = '${config.outputDirectory}/$subDirectory${_relativeFilePath()}';
    if (!isPartial()) {
      path = path.replaceFirst(
          '/${config.moduleConfiguration.html.pagesDirectory}', '');
    }
    var outputFile = File(path);
    Logger.verbose('Writing file ${outputFile.path}');
    if (!await outputFile.exists()) {
      await outputFile.create(recursive: true);
    }
    await outputFile.writeAsString(await file.readAsString());
  }

  /// adds the moduleContents to the output html
  void _addModuleContent() async {
    var tree = parse(await file.readAsString());
    for (var node in ModuleContent.headContents) {
      // we need to wrap the node in a fragment or it will throw
      var fragment = DocumentFragment.html(node.outerHtml);
      tree.head.append(fragment);
    }
    for (var node in ModuleContent.bodyContents) {
      tree.body.append(node);
    }
    await file.writeAsString(tree.outerHtml);
  }

  /// checks if the given File contains a partial
  bool isPartial() {
    var config = ConfigurationLoader.load();
    var partialsDir = config.moduleConfiguration.html.partialsDirectory;

    return file.absolute.path.contains(partialsDir);
  }

  /// Minifies the output.
  void _minify() async {
    var html = await file.readAsString();
    html = html.replaceAll(RegExp(r'>[\s\n]*<'), '><');
    await file.writeAsString(html);
  }

  void _sortHeadTags() async {
    var tree = parse(await file.readAsString());
    var head = List<Element>.from(tree.head.children);
    tree.head.children.clear();
    for (var tag in ['title', 'link', 'meta', 'script', '']) {
      for (var element in List<Element>.unmodifiable(head)) {
        if (tag.isEmpty || element.localName == tag) {
          head.remove(element);
          tree.head.append(element);
        }
      }
    }
    await file.writeAsString(tree.outerHtml);
  }

  /// resolves the provided `path` as path string referencing directory
  /// config key
  /// e.g. @KEY => module_configuration.html.key_directory
  String resolvePath(String path) {
    var regex = RegExp(r'@([A-Z]+)/(.*)');
    if (!regex.hasMatch(path)) return path;
    var configuration = ConfigurationLoader.load();
    var moduleConfig = configuration.moduleConfiguration.html.toJson();
    var match = regex.firstMatch(path);
    var configKey = '${match.group(1).toLowerCase()}_directory';
    var templatesDir =
        configuration.moduleConfiguration.html.templatesDirectory;
    var rest = match.group(2);
    if (moduleConfig.containsKey(configKey)) {
      return '$templatesDir/${moduleConfig[configKey]}/$rest';
    }
    return path;
  }
}
