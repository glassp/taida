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
        sourcePath = sourcePath.replaceFirst(
            '${config.workingDirectory}/html/', module.templatesDir);
      }
      if (!sourcePath.endsWith('.html')) {
        sourcePath = sourcePath + '.html';
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

  /// replaces all <react> tags with generic divs
  /// also adds a comment in debug modue to get a better understanding of where component mounts
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
    await _replaceTaidaTags();
    await _replaceReactTags();
    await _addModuleContent();
    if (!config.debug) {
      await _removeComments();
      await _minify();
    }
    var subDirectory = isPartial() ? '_layout' : '';
    var path =
        '${config.outputDirectory}/${subDirectory}${_relativeFilePath()}';
    if (!isPartial()) {
      path = path.replaceFirst(
          '/${config.moduleConfiguration['html']['pages_directory']}/', '');
    }
    var outputFile = File(path);
    if (!await outputFile.exists()) {
      await outputFile.create(recursive: true);
    }
    await outputFile.writeAsString(await file.readAsString());
  }

  /// adds the moduleContents to the output html
  void _addModuleContent() async {
    var tree = parse(await file.readAsString());
    for (var node in ModuleContent.headContents) {
      tree.head.append(node);
    }
    for (var node in ModuleContent.bodyContents) {
      tree.body.append(node);
    }
    await file.writeAsString(tree.outerHtml);
  }

  /// checks if the given File contains a partial
  bool isPartial() {
    var config = ConfigurationLoader.load();
    var partialsDir = config.moduleConfiguration['html']['partials_directory'];

    return file.absolute.path.contains(partialsDir);
  }

  /// Minifies the output.
  void _minify() async {
    // TODO rm space between > and <
    // TODO check if all line breaks can be removed
  }

  void sortHeadTags() async {
    // TODO sort title, link, meta, script, misc
  }

  /// resolves the provided `path` as path string referencing directory config key
  /// e.g. @KEY => module_configuration.html.key_directory
  String resolvePath(String path) {
    var regex = RegExp(r'@([A-Z]+)/(.*)');
    if (!regex.hasMatch(path)) return path;
    var configuration = ConfigurationLoader.load();
    Map<String, dynamic> moduleConfig =
        configuration.moduleConfiguration['html'];
    var match = regex.firstMatch(path);
    var configKey = '${match.group(1).toLowerCase()}_directory';
    if (moduleConfig.containsKey(configKey)) {
      return '${module.templatesDir}/${moduleConfig[configKey]}/${match.group(2)}';
    }
    return path;
  }
}
