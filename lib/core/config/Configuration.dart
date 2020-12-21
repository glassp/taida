class Configuration {
  final String projectRoot;
  final String outputDirectory;
  final bool debug;

  Configuration(this.outputDirectory, this.debug, this.projectRoot);
  factory Configuration.fromMap(Map<String, dynamic> config) => Configuration('', true, '');
}