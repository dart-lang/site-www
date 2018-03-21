---
layout: default
permalink: /dart-2
title: Dart 2 Updates
description: How Dart 2 is different from Dart 1.x, and how you can convert your code to work with Dart 2.
---

This page will be rewritten to help developers migrating from Dart 1.x to Dart 2.

Much of the content will come from [Leaf's email].


## Resources

* General
  * [Dart's type system][sound Dart]
    * [Fixing common type problems][Fixing Common Type Problems]
  * Dart SDK
    * [dart-lang/sdk CHANGELOG][]
    * [About SDK release channels and version strings][pre-release]
  * Pub and packages
    * [Creating library packages][creating library packages]
    * [pub.dartlang.org][]
    * [Pubspec format][pubspec format]
    * [SDK constraints][]
  * [Dart 2 changes][] section of the [Dart Language Specification][] page
  * [Dart testing][testing]
  * [Stagehand templates][]
{% comment %} update-for-dart-2
  * [DartPad][]
{% endcomment %}
* Flutter
  * [Trying the preview of Dart 2 in Flutter][Flutter migration instructions]
  * [Installing Flutter][]
  * [Upgrading Flutter][]
* Web
  * [Dartium news][]
  * [dartdevc][]
  * [Doc preview of Angular 5.0][]
  * [angular-examples repos][] (see the 5-dev branches for the latest code)


[angular-examples repos]: https://github.com/angular-examples
[creating library packages]: /guides/libraries/create-library-packages
[Dart 2 changes]: /guides/language/spec#dart-2-changes
[Dart Language Specification]: /guides/language/spec
[dart-lang/sdk CHANGELOG]: https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md#200
[dartdevc]: {{site.webdev}}/tools/dartdevc
[Dartium news]: http://news.dartlang.org/2017/06/a-stronger-dart-for-everyone.html
[DartPad]: {{site.custom.dartpad.direct-link}}
[Doc preview of Angular 5.0]: https://webdev-dartlang-org-dev.firebaseapp.com/angular
[enable strong mode]: /guides/language/sound-dart#how-to-enable-strong-mode
[Flutter migration instructions]: https://github.com/flutter/flutter/wiki/Trying-the-preview-of-Dart-2-in-Flutter
[Installing Flutter]: {{site.flutter}}/setup/
[Leaf's email]: https://groups.google.com/d/msg/flutter-dev/H8dDhWg_c8I/_Ql78q_6AgAJ
[pre-release]: /install#about-sdk-release-channels-and-version-strings
[pub.dartlang.org]: {{site.pub}}
[pubspec format]: /tools/pub/pubspec
[SDK constraints]: /tools/pub/pubspec#sdk-constraints
[sound Dart]: /guides/language/sound-dart
[Stagehand templates]: https://github.com/google/stagehand/tree/master/templates
[Fixing Common Type Problems]: /guides/language/sound-problems
[strong vs checked]: /guides/language/sound-faq#how-is-it-different-than-checked-mode
[testing]: /guides/testing
[type inference]: /guides/language/sound-dart#type-inference
[Upgrading Flutter]: {{site.flutter}}/upgrading/
