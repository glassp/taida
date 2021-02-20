Taida
======
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)

Taida is a build tool used to create websites.

Current features:

- SCSS-compiles
- HTML-nesting (importing another HTML file in the current file)
- Dart (compiled to js)
- coping static assets
- auto generating meta data
- auto compressing (resizing) images
- formating all files
- analyzing all files
- running tests

## How to install
Add this package to your `pubspec.yaml` dependencies:
```yaml
    dependencies:
        taida: <latest_version>
```
then run `dart pub get`

Or install it globally via `dart pub global activate taida`

## How to use
This package is best used via `dart pub run taida:taida` if installed as dependency.
In this case it is recommended to create an alias for the command (e.g. `alias taida='dart pub run taida:taida`)

If the package is installed globally you can just use it as `taida`.

Whenever you read `taida` as a command it referes to the appropiate aforementioned command depending on how you installed the package.

You can run the following tasks:
```bash
taida build # starts the build process for the project
taida modules # lists all registered modules
taida format # formats all project files
taida analyze # runs an analyzer over all files
taida test # executes all test
taida --help # prints the help screen
taida -h # prints the help screen
```

## Configuration
Please refer to the files in [examples/configuration](examples/configuration/README.md)
