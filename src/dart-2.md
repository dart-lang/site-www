---
title: Dart 2
description: How Dart 2 is different from Dart 1.x, and how you can convert your code to work with Dart 2.
---

Dart 2 has a few key differences from earlier versions of Dart.
This page briefly covers those differences and
gives general advice on migrating your code to Dart 2.

For information on _why_ Dart 2 has changed, see the
[Dart 2 announcement.][Dart 2 announcement]


## Differences

The Dart language, libraries, build system, and web development tools have changed.

### Language and libraries

* [Dart's type system][sound Dart] is now sound.
  * [Fixing common type problems][Fixing Common Type Problems]
  * [Flutter announcement: Breaking Change: `--preview-dart-2` turned on by default][Leaf's email]
* Instance creation keywords are now generally optional,
  as described in [Using constructors][]:
  * `new` is always optional.
  * `const` is optional inside of a constant context.
* Dart no longer has checked mode.
  * [Assert statements][] are still supported, but you enable them differently.
* The Dart language and core libraries have changed,
  partly as a result of the type system changes.
  * [Dev channel API reference documentation][apiref]
  * [dart-lang/sdk CHANGELOG][]

### Tools

* Pub no longer supports transformers.
  Instead, use the [new build system.][build system]
* Tools related to web development have changed.
  * The new build system [replaces `pub build` and `pub serve`.][build_runner web]
  * Dartium is no longer supported. Instead, use [dartdevc][] and Chrome.


## Migrating your code {#migration}

First, see the migration guide for your platform:

* [Flutter migration guide][Flutter migration instructions]
* [Web app migration guide][webdev dart2]

If you publish packages, then also see the
[package migration instructions below.](#migrating-packages)


### General process

Here's an overview of the process of migrating to Dart 2,
from either Dart 1.x or an earlier version of Dart 2.

1. **Get an up-to-date version of the Flutter or Dart SDK.**
   * [Flutter SDK instructions][Flutter SDK install]
   * [Dart SDK instructions][Dart SDK install] (VM or web)
2. **Upgrade the packages your app depends on.**
   * Flutter: [`flutter packages upgrade`][flutter package upgrade]
   * Server-side or web: [`pub upgrade`][pub upgrade]
3. **Run the [dart2_fix tool.][dart2_fix]** It helps migrate some
   usages of deprecated Dart 1.x APIs to Dart 2.
4. **Run the analyzer** to find [compile-time errors][]
   and deprecation hints.
   * Flutter: [`flutter analyze`][Flutter analyzer]
   * Server-side or web: [`dartanalyzer`][dartanalyzer]
5. **Fix issues in your code and run the analyzer again**,
   repeating until your code passes static analysis.
6. **Run tests to find [runtime errors][].**
   * Run all [automated tests] for your software.
   * Do manual testing, and look for console errors.
   Consider adding automated tests to catch issues that you find.
7. **Fix issues until your code works.**
8. _Optional:_ **Remove `new` and unnecessary `const`.**
   * You can remove these by hand or use a tool such as `dartfmt --fix`.
   * To find occurrences of `new` and unnecessary `const`, add the rules
     `unnecessary_new` and `unnecessary_const` to the `linter` section of your
     [analysis options file][].

Each time the SDK has a significant release, repeat the process.

{% comment %}
TODO:
- talk about library vs. app migration?
- talk more about versioning?
{% endcomment %}

### Migrating packages

As a package owner, you need to do the following:

* Follow the migration tips for the platforms that your package supports
  (see above).
* Make sure your package passes Dart 2 analysis (see **Run the analyzer** above)
* Make sure your package's users know how to report issues.
* Respond quickly to issue reports.
* If code changes aren't backward compatible,
  update the lower SDK constraint.

#### Changes and backward compatibility

If you have to change your package's code,
**try to make it work in 1.x**, as well as Dart 2.
For example, you might be able to add type annotations
or (if an API has been removed) to use an alternative 1.x API.

If a backward-compatible change isn't possible,
**update the lower [SDK constraint.][SDK constraints]**

[Test your changes][testing] to make sure that your package works as expected.

#### Upper constraints on the SDK version {#upper-constraint}

Once your package passes Dart 2 analysis, update the upper constraint
to declare that the package is compatible with Dart 2:

```yaml
# Works in Dart 1 (starting with 1.20.1), and works in Dart 2
sdk: '>=1.20.1 <3.0.0'

# Works in Dart 2 only, starting with Dart 2 dev build 61
sdk: '>=2.0.0-dev.61.0 <3.0.0'
```

<aside class="alert alert-warning" markdown="1">
  Packages that declare an upper constraint of `<2.0.0` can still be consumed by
  Dart 2 dev builds, as those have lax upper constraint checking. However,
  once Dart 2 ships on the stable channel, those constraints will no longer
  resolve, and **only packages that declare an upper constraint of `<3.0.0` will
  work with Dart 2**.
</aside>

## More resources

* [DartPad](/tools/dartpad)
* [Dart 2 changes][] section of the [Dart Language Specification][] page
* [About Dart SDK release channels and version strings][pre-release]
* [SDK constraints][]
* [Updating your pub package to Dart 2,][]
  an article that includes tips for updating your code and
  using Travis to perform continuous integration (CI) testing

[analysis options file]: /guides/language/analysis-options#the-analysis-options-file
[dartdevc]: {{site.webdev}}/tools/dartdevc
[build system]: https://github.com/dart-lang/build/tree/master/docs
[automated tests]: /guides/testing
[customize static analysis]: /guides/language/analysis-options
[Flutter analyzer]: https://flutter.io/debugging/#the-dart-analyzer
[dartanalyzer]: https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer
[flutter package upgrade]: https://flutter.io/using-packages/#updating-package-dependencies
[pub upgrade]: /tools/pub/get-started#upgrading-a-dependency
[dart2_fix]: https://github.com/dart-lang/dart2_fix
[angular-examples repos]: https://github.com/angular-examples
[apiref]: {{site.dart_api}}/dev
[assert statements]: /guides/language/language-tour#assert
[build_runner web]: {{site.webdev}}/tools/build_runner
[compile-time errors]: /guides/language/sound-problems#static-errors-and-warnings
[creating library packages]: /guides/libraries/create-library-packages
[Dart 2 changes]: /guides/language/spec#dart-2-changes
[Dart 2 announcement]: https://medium.com/dartlang/announcing-dart-2-80ba01f43b6
[Dart Language Specification]: /guides/language/spec
[dart-lang/sdk CHANGELOG]: https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md#200
[Dartium news]: http://news.dartlang.org/2017/06/a-stronger-dart-for-everyone.html
[Fixing Common Type Problems]: /guides/language/sound-problems
[Flutter migration instructions]: https://github.com/flutter/flutter/wiki/Dart-2-Migration
[Flutter SDK install]: https://flutter.io/upgrading/
[Dart SDK install]: /tools/sdk#install
[Leaf's email]: https://groups.google.com/d/msg/flutter-dev/H8dDhWg_c8I/_Ql78q_6AgAJ
[newsletters]: https://github.com/dart-lang/sdk/tree/master/docs/newsletter#dart-language-and-library-newsletters
[pre-release]: /tools/sdk#about-release-channels-and-version-strings
[runtime errors]: /guides/language/sound-problems#runtime-errors
[SDK constraints]: /tools/pub/pubspec#sdk-constraints
[sound Dart]: /guides/language/sound-dart
[testing]: /guides/testing
[Updating your pub package to Dart 2,]: https://medium.com/@filiph/updating-your-pub-package-to-dart-2-cd8ca343b1be
[Using constructors]: /guides/language/language-tour#using-constructors
[webdev dart2]: {{site.webdev}}/dart-2
