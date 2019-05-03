---
title: Dart testing
description: How to test Flutter, web, and VM applications.
---

Software testing, an important part of app development, helps verify that
your app is working correctly before you release it.
This Dart testing guide outlines several types of testing, and points
you to where you can learn how to test your
[mobile,]({{site.flutter}}) [web](/web),
and [server-side apps and scripts](/server).

<aside class="alert alert-info" markdown="1">
**Terminology: widget vs. component**<br>
Flutter, an SDK for building apps for iOS and Android, defines its
GUI elements as _widgets_. AngularDart, a web app framework,
defines its GUI elements as _components_.
This doc uses **component** (except when explicitly discussing Flutter),
but both terms refer to the same concept.
</aside>

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

* _Component_ tests verify that a component (which
  usually consists of multiple classes) behaves as expected.
  A component test often requires the use of mock objects
  that can mimic user actions, events, perform layout,
  and instantiate child components.

* _Integration_ and _end-to-end_ tests verify the behavior of
  an entire app, or a large chunk of an app. An integration test
  generally runs on a real device or OS simulator (for mobile)
  or on a browser (for the web) and consists of two pieces:
  the app itself, and the test app that puts
  the app through its paces. An integration test often measures performance,
  so the test app generally runs on a different device or OS
  than the app being tested.

## Generally useful libraries

Although your tests partly depend on the platform your code is intended
for&mdash;Flutter, the web, or server-side, for example&mdash;the
following packages are useful across Dart platforms:

* [package:test]({{site.pub}}/packages/test)<br>
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


* [package:mockito]({{site.pub}}/packages/mockito)<br>
  Provides a way to create
  [mock objects,](https://en.wikipedia.org/wiki/Mock_object)
  easily configured for use in fixed scenarios, and to verify
  that the system under test interacts with the mock object in
  expected ways.
  For an example that uses both package:test and package:mockito,
  see the [International Space Station API library and its unit
  tests](https://github.com/dart-lang/mockito/tree/master/test/example/iss)
  in the [mockito package](https://github.com/dart-lang/mockito).

## Flutter testing

Use the following resources to learn more about testing Flutter apps:

* [Testing Flutter Apps]({{site.flutter}}/docs/testing)<br>
  How to perform unit, widget, or integration tests on a Flutter app.
* [flutter_test]({{site.flutter_api}}/flutter/flutter_test/flutter_test-library.html)<br>
  A testing library for Flutter built on top of package:test.
* [flutter_driver]({{site.flutter_api}}/flutter/flutter_driver/flutter_driver-library.html)<br>
  A testing library for testing Flutter applications on real devices and
  emulators (in a separate process).
* [flutter/examples/flutter_gallery](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)<br>
  Tests for the Flutter gallery example.
* [flutter/dev/manual_tests](https://github.com/flutter/flutter/tree/master/dev/manual_tests)<br>
  Many examples of tests in the Flutter SDK.

## Web testing

Use the following resources to learn more about testing Dart web
applications:

* [Testing]({{site.angulardart}}/guide/testing)(a page
  in the AngularDart guide)<br>
  How to use the [angular_test]({{site.pub}}/packages/angular_test)
  package to test AngularDart components and subsystems.
  <!-- More pages are coming! -->
* [package:webdriver]({{site.pub}}/packages/webdriver)<br>
  A Dart package for interfacing with
  [WebDriver](https://www.w3.org/TR/webdriver/) servers.

## Other tools and resources

You may also find the following resources useful for developing and
debugging Dart applications.

### IDE

When it comes to debugging, your first line of defense is your IDE.
Dart plugins exist for many [commonly used IDEs](/tools/#ides-and-editors).

### Observatory

Observatory is a browser-based tool for profiling and debugging your
Dart applications. You can learn more using the following resources:

* [Observatory: A Profiler for Dart
  Apps](https://dart-lang.github.io/observatory/)
* [Dart
  Observatory]({{site.flutter}}/testing/debugging#dart-observatory-statement-level-single-stepping-debugger-and-profiler),
  a section in [Debugging Flutter Apps]({{site.flutter}}/testing//debugging)
* [Dart VM
  Observatory]({{site.group}}/forum/#!forum/observatory-discuss)
  discussion group

### Continuous integration

Consider using continuous integration (CI) to build your project
and run its tests after every commit. Two CI services for GitHub are
[Travis CI](https://travis-ci.org/) (for OS X and Unix) and
[AppVeyor](https://www.appveyor.com/) (for Windows).

Travis has built-in support for Dart projects.
Learn more at the following links:

* [Building a Dart Project](https://docs.travis-ci.com/user/languages/dart)
  covers how to configure Travis for Dart projects
* The [shelf](https://github.com/dart-lang/shelf/blob/master/.travis.yml)
  example uses the `dart_task` tag (in `.travis.yml`) to configure
  the build.
