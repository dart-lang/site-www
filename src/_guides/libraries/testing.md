---
layout: default
title: "Dart Testing"
description: "How to test Dart, Flutter, and 'Dart for the Web' applications?"
---

Software testing, an important part of app development, helps verify that
your app is working correctly before unleashing it on your users.
This Dart testing guide outlines several types of testing, and points
you to where you can learn more about testing on the Flutter, Dart VM,
and 'Dart for the Web' platforms.

## Testing types

The Dart testing docs focus on three types of testing, out of the
[many testing types](http://www.aptest.com/testtypes.html) that
you may be familiar with: unit, widget (or component, depending on the
platform), and integration (or end-to-end). Testing terminology varies,
but these are the terms and concepts that you are likely to
encounter when using Dart technologies:

* _Unit_ tests focus on verifying the smallest piece of testable
  software, such as a function, method, or class. Your testing suite
  should have more unit tests that widget or integration tests.

* _Widget_ (or _component_) tests verify that a widget (which
  usually consists of multiple classes) behaves as expected.
  A widget test requires a mock framework that can mimic user actions,
  events, perform layout, and instantiate child widgets.
  Note that Flutter refers to widgets, and AngularDart refers to
  components.

* _Integration_ or (_end-to-end_) tests verify the behavior of
  an entire app, or a large chunk of an app. An integration test
  generally runs on a real device or an OS simulator, and consists
  of two pieces: the app itself, and the test app that puts it through
  its paces. An integration test often measures performance, so the
  test app generally runs on a different device or OS.

## Generally useful libraries

How you write your tests partly depends on whether you are using Flutter,
Dart VM, AngularDart, or other web solutions, but the following packages
are useful across Dart platforms:

* [package:test](https://pub.dartlang.org/packages/test)<br>
  Provides a standard way of writing tests in Dart. You can use the test
  package to:
    * Write single tests, or groups of tests.
    * Use the `@TestOn` annotation to restrict tests to run on
      specific environments.
    * Write asynchronous tests just as you would for non-asynchronous
      tests.
    * Tag tests using the `@Tag` annotation. For example, define a tag to
      create a custom configuration for some tests, or to identify some tests
      as needing more time to complete.
    * Create a `dart_test.yaml` file to configure tagged tests across
      multiple files or an entire package.


* [package:mockito](https://pub.dartlang.org/packages/mockito)<br>
  Provides a way to mock interfaces so that a piece of code is replaced
  by a dummy implementation that emulates real code, but behaves in
  a predictable way. This package is particularly useful for unit
  testing. For an example that uses both package:test and package:mockito,
  see the [International Space Station API library and its unit
  tests](https://github.com/dart-lang/mockito/tree/master/test/example/iss)
  in the [mockito package](https://github.com/dart-lang/mockito).

## Flutter testing

Use the following resources to learn more about testing Flutter apps:

* [Testing Flutter Apps](https://flutter.io/testing/)<br>
  How to perform unit, widget, or integration tests on a Flutter app.
* [flutter_test](https://docs.flutter.io/flutter/flutter_test/flutter_test-library.html)<br>
  A testing library for Flutter built on top of package:test.
* [flutter_driver](https://docs.flutter.io/flutter/flutter_driver/flutter_driver-library.html)<br>
  A testing library for testing Flutter applications on real devices and
  emulators (in a separate process).
* [flutter/examples/flutter_gallery](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)<br>
  Tests for the Flutter gallery example.
* [flutter/dev/manual_tests](https://github.com/flutter/flutter/tree/master/dev/manual_tests)<br>
  Many examples of tests in the Flutter SDK.

## Web testing

Use the following resources to learn more about testing Dart web
applications:

* [Testing](https://webdev.dartlang.org/angular/guide/testing)<br>
  How to use the [angular_test](https://pub.dartlang.org/packages/angular_test)
  package to test AngularDart components and Angular subsystems.
* [package:webdriver](https://pub.dartlang.org/packages/webdriver)<br>
  Provides bindings that use the WebDriver JSON interface and require
  the WebDriver remote server. [PENDING: a better way to describe this?]

## Other tools and resources

You may also find the following resources useful for developing and
debugging Dart applications.

### Observatory

Observatory is a browser-based tool for profiling and debugging your
Dart applications. You can learn more using the following resources:

* [Observatory: A Profiler for Dart Apps](https://dart-lang.github.io/observatory/)
* [Dart Observatory](https://flutter.io/debugging/#dart-observatory-statement-level-single-stepping-debugger-and-profiler),
  a section in [Debugging Flutter Apps](https://flutter.io/debugging/)
* [Dart VM Observatory](https://groups.google.com/a/dartlang.org/forum/#!forum/observatory-discuss)
  discussion group

### Travis

If [GitHub](https://github.com/) is part of your app development workflow,
you might consider adding continuous integration using Travis
Continuous Integration (CI). Once configured for your repo, Travis
detects every commit, builds the project, and runs your tests.

Learn more about Travis at the following links:

* [Travis CL website](https://travis-ci.org/)
* [Building a Dart Project](https://docs.travis-ci.com/user/languages/dart)
  covers how to configure Travis for Dart projects
* The [shelf](https://github.com/dart-lang/shelf/blob/master/.travis.yml)
  example uses the `dart_task` tag (in `.travis.yml`) to configure
  the build.


