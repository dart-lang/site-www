---
title: Dart testing
description: How to test Flutter, web, and VM applications.
---

Software testing, an important part of app development, helps verify that
your app is working correctly before you release it.
This Dart testing guide outlines several types of testing, and points
you to where you can learn how to test your
[Flutter]({{site.flutter}}), [web](/web),
and [server-side apps and scripts](/server).

You can run tests on the command line
using the [`dart test`][] command
(or, for Flutter apps, [`flutter test`][]).

[`dart test`]: /tools/dart-test
[`flutter test`]: {{site.flutter-docs}}/reference/flutter-cli

## Kinds of testing

The Dart testing docs focus on three kinds of testing, out of the
[many kinds of testing](https://en.wikipedia.org/wiki/Software_testing)
that you may be familiar with: unit, component, and end-to-end
(a form of integration testing). Testing terminology varies,
but these are the terms and concepts that you are likely to
encounter when using Dart technologies:

* _Unit_ tests focus on verifying the smallest piece of testable
  software, such as a function, method, or class. Your test suites
  should have more unit tests than other kinds of tests.

* _Component_ tests (called _widget_ tests in Flutter)
  verify that a component (which usually consists of multiple classes)
  behaves as expected.
  A component test often requires the use of mock objects
  that can mimic user actions, events, perform layout,
  and instantiate child components.

* _Integration_ and _end-to-end_ tests verify the behavior of
  an entire app, or a large chunk of an app. An integration test
  generally runs on a simulated or real device
  or on a browser (for the web) and consists of two pieces:
  the app itself, and the test app that puts
  the app through its paces. An integration test often measures performance,
  so the test app generally runs on a different device or OS
  than the app being tested.

## Generally useful libraries

Although your tests partly depend on the platform your code is intended
for—Flutter, the web, or server-side, for example—the
following packages are useful across Dart platforms:

* [package:test]({{site.pub-pkg}}/test)<br>
  Provides a standard way of writing tests in Dart. You can use the test
  package to:
    * Write single tests, or groups of tests.
    * Use the `@TestOn` annotation to restrict tests to run on
      specific environments.
    * Write asynchronous tests just as you would write synchronous
      tests.
    * Tag tests using the `@Tag` annotation. For example, define a tag to
      create a custom configuration for some tests, or to identify some tests
      as needing more time to complete.
    * Create a `dart_test.yaml` file to configure tagged tests across
      multiple files or an entire package.


* [package:mockito]({{site.pub-pkg}}/mockito)<br>
  Provides a way to create
  [mock objects,](https://en.wikipedia.org/wiki/Mock_object)
  easily configured for use in fixed scenarios, and to verify
  that the system under test interacts with the mock object in
  expected ways.
  For an example that uses both package:test and package:mockito,
  see the [International Space Station API library and its unit
  tests](https://github.com/dart-lang/mockito/tree/master/example/iss)
  in the [mockito package](https://github.com/dart-lang/mockito).

## Flutter testing

Use the following resources to learn more about testing Flutter apps:

* [Testing Flutter Apps]({{site.flutter-docs}}/testing)<br>
  How to perform unit, widget, or integration tests on a Flutter app.
* [flutter_test]({{site.flutter-api}}/flutter/flutter_test/flutter_test-library.html)<br>
  A testing library for Flutter built on top of package:test.
* [flutter_driver]({{site.flutter-api}}/flutter/flutter_driver/flutter_driver-library.html)<br>
  A testing library for testing Flutter applications on real devices and
  emulators (in a separate process).
* [flutter_gallery](https://github.com/flutter/gallery)<br>
  Source code and tests for the Flutter gallery example.
* [flutter/dev/manual_tests](https://github.com/flutter/flutter/tree/master/dev/manual_tests)<br>
  Many examples of tests in the Flutter SDK.

## Other tools and resources

You may also find the following resources useful for developing and
debugging Dart applications.

### IDE

When it comes to debugging, your first line of defense is your IDE.
Dart plugins exist for many [commonly used IDEs](/tools/#ides-and-editors).

### Dart DevTools

Dart DevTools is a suite of performance tools for Dart and Flutter.
For details, see the
[Dart DevTools documentation.](/tools/dart-devtools)


### Continuous integration

Consider using continuous integration (CI) to build your project
and run its tests after every commit. Two CI services for GitHub are
[GitHub Actions](https://github.com/features/actions) and
[AppVeyor](https://www.appveyor.com/).

Learn more about GitHub Actions:

* [Testing Dart packages with GitHub Actions][gha-article]
  demonstrates a simple workflow for using GitHub Actions to test
  a Flutter app or Dart package.
* Many packages provided by the Dart team use GitHub Actions.
  For an example, see
  [`test-package.yml`][markdown-ci] in the markdown package's repo.
  To see how that repo migrated from Travis CI to GitHub Actions,
  look at [PR #353](https://github.com/dart-lang/markdown/pull/353).

[gha-article]: https://poetryincode.dev/testing-dart-packages-with-github-actions
[markdown-ci]: https://github.com/dart-lang/markdown/blob/master/.github/workflows/test-package.yml

