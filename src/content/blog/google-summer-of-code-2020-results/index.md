---
title: "Google Summer of Code 2020 results"
description: "The Dart team mentored 5 student developers this summer, as part of GSoC 2020. Read about the student projects."
publishDate: 2020-09-02
author: "jonasfj"
image: images/15VxyyQ1juWjwtTbSkwzzXA.jpeg
category: other
tags:
  - dartlang
  - flutter
  - open-source
  - google-summer-of-code
---


<DashImage src="images/15VxyyQ1juWjwtTbSkwzzXA.jpeg" />


[Google Summer of Code (GSoC)](https://summerofcode.withgoogle.com/) is a global program focused on bringing student developers into open source software development. Students are sponsored by Google to work with a mentoring open source organization on a 3-month programming project during the summer.

In [February we were thrilled to announce](https://medium.com/dartlang/students-join-a-dart-project-for-google-summer-of-code-2020-655d39b557c2) that the Dart team would be a mentoring organization in GSoC 2020. We ended up [mentoring 5 projects](https://summerofcode.withgoogle.com/organizations/6544944065413120/), picked from more than 170 applications from students around the world. Today we’re excited to share our results, as described by the students who worked on the projects.

### Generating dart:ffi bindings for Dart-C interop with package:ffigen

*By Prerak Mann*

[package:ffigen](https://pub.dev/packages/ffigen) is an FFI generator that greatly reduces the effort of using `dart:ffi` by generating Dart bindings from C header files (`.h`).

To understand the need for this tool, consider [LibClang](https://clang.llvm.org/doxygen/group__CINDEX.html) (the C interface to Clang). LibClang’s [API](https://github.com/dart-lang/ffigen/tree/master/third_party/libclang/include/clang-c) is about 8,000 lines of code (LOC). If you were to write Dart [bindings for LibClang](https://github.com/dart-lang/ffigen/blob/master/example/libclang-example/generated_bindings.dart) by hand, you’d need almost 4,500 LOC. With `package:ffigen`, all you need to do is pass in a [small YAML configuration file](https://github.com/dart-lang/ffigen/blob/master/example/libclang-example/pubspec.yaml#L14) that’s less than 20 LOC, and then you can generate the bindings.

You can control which C functions to generate, and use simple regular expressions to rename macros, enums, and individual struct members. You can also [generate array](https://github.com/dart-lang/ffigen#array-workaround) members nested in structs (which are not fully supported in `dart:ffi` yet).

Check out [github.com/dart-lang/ffigen](https://github.com/dart-lang/ffigen) for a complete list of [configurations](https://github.com/dart-lang/ffigen#configurations), [FAQs](https://github.com/dart-lang/ffigen#faq), [examples](https://github.com/dart-lang/ffigen/blob/master/example/), and more.

### Learn testing with a new Flutter sample

*By Abdullah Deshmukh*

Have you been using Flutter for a while but still haven’t figured out how to test Flutter apps? Then you might be interested in the sample that we built to demonstrate best practices for testing Flutter apps. You’ll be able to learn testing in Flutter in a quick and easy way.

The [sample](https://github.com/flutter/samples/tree/master/testing_app) shows different types of testing including:

* Unit testing

* Widget testing

* Integration testing

* Performance testing

* State management testing

As a bonus, we also built a codelab on how to test Flutter apps. You can see a detailed report of the work done under the project in the article [Learn testing with the new Flutter sample](https://medium.com/flutter/learn-testing-with-the-new-flutter-sample-gsoc20-work-product-e872c7f6492a).

### User-extensible translation file formats

*By Jaime Blasco*

The [intl_translation](https://pub.dev/packages/intl_translation) package supports only the ARB file format, which is not widely used outside of Dart. The [intl_translation_format](https://pub.dev/packages/intl_translation_format) package, created during GSoC 2020, builds on intl_translation, adding a `TranslationFormat` class that can support widely varying formats. Developers can add support for additional formats in their own packages and in just a few lines create command-line tools for extraction and generation that integrate with the existing tools. With these, existing translations in other formats, even proprietary ones, can be imported into a Dart project easily and new messages originating in Dart code can be integrated into existing translation tools and workflows.

As a demonstration of these capabilities, the new packages include support for several formats. In addition to ARB, it supports **XLIFF v1.2 (iOS), XLIFF v2.0,** and **JSON with ICU** messages. [Experimental libraries](https://github.com/jamesblasco/intl_translation_format_experiments) show how support for other formats, and even translations that can be updated at runtime, could be implemented.

### Platform channels in a mobile app and a federated plugin

*By Ayush Bherwani*

After researching platform channels (the Flutter API for sending messages back and forth from Dart to native code like Swift or Kotlin), we decided to cover the topic with two different samples. One is a [straightforward Android and iOS demo](https://github.com/flutter/samples/tree/master/platform_channels), while the other is a [federated plugin](https://github.com/flutter/samples/tree/master/experimental/federated_plugin) capable of building with the master channel for web and desktop as well. Between the two samples, the codebase shows off not only the details of platform channels and the codecs that can be used to move data, but also the APIs for federated plugins and techniques for calling native code on web and desktop (Windows and Linux) APIs.

If you’re a developer looking to build a plugin or just access a platform API, these samples are a great place to get started learning. For more information about this project, see the article [Platform channel examples](https://medium.com/flutter/platform-channel-examples-7edeaeba4a66).

### Writing package:yaml_edit to enable `pub add &lt;package&gt;`

*By Garett Tok Ern Liang*

Dart projects specify package dependencies in a `pubspec.yaml` file. [YAML](https://yaml.org/spec/1.2/spec.html) is great because it allows us to write comments, but programmatically modifying YAML is a challenge.

To tackle this challenge, we wrote [`package:yaml_edit`](https://pub.dev/packages/yaml_edit) to easily perform context-aware string manipulations that preserve formatting and comments. The test suite for the package contains more than 40,000 tests, and we think we have a pretty good solution working. Play with it and [file bugs](https://github.com/google/dart-neats/issues)!

Using `package:yaml_edit`, we added a new `pub add &lt;package&gt;` subcommand to `pub`, the package management tool for Dart and Flutter. `pub add` automatically resolves for the latest compatible version of the target package and adds it to a user’s `pubspec.yaml`. To put this into perspective, `pub add &lt;package&gt;` automates the tedium of having to do all of the following:

1. Visiting `https://pub.dev/packages/<package>`

1. Choosing a version to add to your package

1. Modifying `pubspec.yaml`

1. Running `pub get`

1. Repeating steps 2-4 as many times as needed to get a version compatible with your other dependencies

A similar command that removes dependencies — `pub remove &lt;package&gt;`— is also in the works. Keep your eyes peeled for these two commands coming to `pub` soon!
> Huge thanks to everyone who applied for Google Summer of Code 2020 with Dart, and to the students who completed projects this year, and to the mentors who spent time every week to make this an awesome summer of code. We hope to see many of you students again as contributors throughout the Dart ecosystem.