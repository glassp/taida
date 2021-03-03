Taida
======
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)
[status: discontinued](https://img.shields.io/badge/Status-discontinued-red)

Taida is a build tool used to create websites.

## Discontinued
This project is discontinued in favir of using flutter 2.0 with web support.
Flutter is a full-fledged ui kit on a scale which is out of scope for this package.
Originally this was planned as a proof of concept  which then got used by some small side projects.

## Features
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
        taida: 1.1.0 # last release
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
