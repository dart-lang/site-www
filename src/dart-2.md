---
layout: default
permalink: /dart-2
title: Dart 2 Migration
description: How Dart 2 is different from Dart 1.x, and how you can convert your code to work with Dart 2.
---

**This page is under construction.**
It aims to help developers migrating from Dart 1.x to Dart 2.


## Differences

### Tools

* Tools related to web development have changed.
  For details, see the
  [Dart 2 page for web developers.][webdev dart2]
  * Pub no longer supports `build` and `serve`.
  * Dartium is no longer supported.
* Pub no longer supports transformers.
  Instead, use builders. For more information, see
  your platform documentation or the
  [dart-lang/build repo docs.](https://github.com/dart-lang/build/tree/master/docs)

### Language and libraries

* [Dart's type system][sound Dart] is now sound.
  * [Fixing common type problems][Fixing Common Type Problems]
  * [Email: Breaking Change: --preview-dart-2 turned on by default][Leaf's email]
* The Dart language and core libraries have changed,
  partly as a result of the type system changes.
  * [Dev channel API reference documentation][apiref]
  * [dart-lang/sdk CHANGELOG][]


## More resources

* General:
  * [About SDK release channels and version strings][pre-release]
  * [Dart language and library newsletters][newsletters]
  * [Enabling Dart 2 semantics][enable strong mode]
  * [SDK constraints][]
{% comment %} update-for-dart-2
  * [DartPad][]
  * [Dart 2 changes][] section of the [Dart Language Specification][] page
{% endcomment %}
* Flutter:
  * [Trying the preview of Dart 2 in Flutter][Flutter migration instructions]
* Web:
  * [Dartium news][]
  * [Doc preview of Angular 5.0][]
  * [angular-examples repos][] (see the 5-dev branches for the latest code)


[angular-examples repos]: https://github.com/angular-examples
[apiref]: {{site.dart_api}}/dev
[creating library packages]: /guides/libraries/create-library-packages
[Dart 2 changes]: /guides/language/spec#dart-2-changes
[Dart Language Specification]: /guides/language/spec
[dart-lang/sdk CHANGELOG]: https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md#200
[Dartium news]: http://news.dartlang.org/2017/06/a-stronger-dart-for-everyone.html
[DartPad]: {{site.custom.dartpad.direct-link}}
[Doc preview of Angular 5.0]: https://webdev-dartlang-org-dev.firebaseapp.com/angular
[enable strong mode]: /guides/language/sound-dart#how-to-enable-strong-mode
[Fixing Common Type Problems]: /guides/language/sound-problems
[Flutter migration instructions]: https://github.com/flutter/flutter/wiki/Trying-the-preview-of-Dart-2-in-Flutter
[Leaf's email]: https://groups.google.com/d/msg/flutter-dev/H8dDhWg_c8I/_Ql78q_6AgAJ
[newsletters]: https://github.com/dart-lang/sdk/tree/master/docs/newsletter#dart-language-and-library-newsletters
[pre-release]: /install#about-sdk-release-channels-and-version-strings
[SDK constraints]: /tools/pub/pubspec#sdk-constraints
[sound Dart]: /guides/language/sound-dart
[testing]: /guides/testing
[webdev dart2]: {{site.webdev}}/dart-2