---
title: "Announcing Windows support for Dart on Travis CI"
description: "Today, we’re announcing that Travis CI on Windows supports the Dart SDK, so you can run Dart build and test jobs on all major desktop OS’s."
publishDate: 2019-04-15
author: mit-mit
image: images/1Zh0PvesZNUKCljlerYe4Sg.png
category: announcements
tags:
  - continuous-integration
  - dart
  - travis-ci
  - flutter
  - announcements
layout: blog
---


Recently, [Travis CI](https://travis-ci.com/) — a continuous integration (CI) service for GitHub repos — [announced](https://blog.travis-ci.com/2018-10-11-windows-early-release) early release support for the Windows operating system. Today, we’re announcing that Travis CI on Windows supports the Dart SDK, so you can run Dart build and test jobs on all three major desktop operating systems: Linux, Mac, and Windows.

<DashImage src="images/1Zh0PvesZNUKCljlerYe4Sg.png" />


### Configuring Travis CI jobs for multiple operating systems

If you already use Travis CI to build or test your Dart code, you can easily run your jobs on all three operating systems. Just add (or extend) the `os:` section in your repo’s `.travis.yml` file:

```
os:
- linux
- osx
- windows
```


Then, whenever Travis CI runs, you’ll see entries for each test configuration running on each of the enabled operating systems. Here’s [an example](https://travis-ci.org/grpc/grpc-dart/builds/517691491) from the [grpc-dart](https://github.com/grpc/grpc-dart) repo, after we [added Windows](https://github.com/grpc/grpc-dart/commit/0cbc5401c82500bf20b89654c4adbde355dcc8d3) to the test matrix:

<DashImage src="images/0wegLWjqUZkUfufxl.png" alt="Travis CI test matrix run on Linux, MacOS, and Windows" caption="Travis CI test matrix run on Linux, MacOS, and Windows" />


Because Windows support on Travis CI is still in an early release stage, we recommend that you review the [known issues](https://travis-ci.community/t/current-known-issues-please-read-this-before-posting-a-new-topic/264) before adding Windows to your Travis jobs.

### Adding Travis CI test support to a project

If you don’t yet use Travis CI for testing Dart, it’s really easy to get started. The most minimal `.travis.yml` file contains just one line:

```
language: dart
```


This config is the equivalent of `pub run test`.

List any additional tasks under the `dart_task:` tag. These include running static analysis and code formatting checks (for full details, see the [Travis documentation](https://docs.travis-ci.com/user/languages/dart/)).

Here’s how to run static analysis, which checks your code for analysis errors:

```
language: dart
dart_task:
- dartanalyzer
```


Here’s how to make sure that all Dart files are correctly formatted:

```
language: dart
dart_task:
- dartfmt
```


If you have a more complicated repo with multiple Dart packages, you need a slightly more detailed setup. The `travis` command in the [mono_repo tool](https://pub.dartlang.org/packages/mono_repo) is one possible solution for creating this setup.

### Alternatives to Travis CI

Travis CI is one of several popular providers of continuous integration. Others with support for the Dart SDK include [AppVeyor](https://www.appveyor.com/) ([sample](https://github.com/dart-lang/dartdoc/blob/master/appveyor.yml)) and [Codeship](https://documentation.codeship.com/basic/languages-frameworks/dart/). For [Flutter](https://flutter.dev/) apps, options include [NeverCode](https://developer.nevercode.io/docs/building-flutter-apps), [CirrusCI](https://cirrus-ci.org/examples/#flutter), and [Bitrise](https://devcenter.bitrise.io/getting-started/getting-started-with-flutter-apps/).

That’s it for now. We hope you enjoy this new CI support for Dart.