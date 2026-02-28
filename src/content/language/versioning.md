---
title: Language versioning
description: >-
  Learn how language versioning in Dart enables evolution of the language
  and how to configure the language versions of your project and its libraries.
---

## Overview

A single Dart SDK can simultaneously support
multiple versions of the Dart language.
The compiler determines what version the code is targeting,
and it interprets the code according to that version.

Language versioning becomes important on the rare occasions when Dart
introduces an incompatible feature like [null safety][].
When Dart introduces a breaking change, code that
did compile might no longer compile.
Language versioning allows you to set each library's language version
to maintain compatibility.

In the case of null safety, Dart SDKs 2.12 through 2.19 allowed you
to _choose_ to update your code to use null safety.
Dart uses language versioning to permit non-null-safe code to run
alongside null-safe code.
This decision enabled migration from non-null-safe to null-safe code.
To review an example of how an app or package can migrate to a new
language version with an incompatible feature, check out this article on
[Gradual null safety migration for large Dart projects][].

Each package has a default language version equal to the **lower bound**
of the [SDK constraint][] in the `pubspec.yaml` file.

**For example:** The following entry in a `pubspec.yaml` file
indicates that this package defaults to the Dart 2.18 language version.

```yaml
environment:
  sdk: '>=2.18.0 <3.0.0'
```

To learn how and why the Dart team developed this versioning method,
check out the [language versioning specification][].

[null safety]: /null-safety
[Gradual null safety migration for large Dart projects]: https://blog.dart.dev/gradual-null-safety-migration-for-large-dart-projects-85acb10b64a9
[SDK constraint]: /tools/pub/pubspec#sdk-constraints
[language versioning specification]: {{site.repo.dart.lang}}/blob/main/accepted/2.8/language-versioning/feature-specification.md#dart-language-versioning

## Language version numbers

Dart formats its language versions as two numbers separated with a period.
It reads as a major version number and a minor version number.
Minor version numbers might introduce breaking changes.

Dart releases might append a patch number to a language version.
Patches should not change the language except for bug fixes.
To illustrate: Dart 2.18.3 serves as the latest release of the
Dart 2.18 SDK language version.

Each Dart SDK release supports its own language version and
all previous versions within the same major version number.
That means that Dart SDK 2.18.3 supports language versions
2.0 through 2.18 inclusive, but not Dart 1.x.

Deriving the language version from the SDK version implies the following:

* Whenever a minor version of the SDK ships, a new language version appears.
  In practice, many of these language versions work in a very similar manner
  to previous versions and have with full compatibility between them.
  For example: The Dart 2.9 language works much like the Dart 2.8 language.

* When a patch release of the SDK ships,
  it cannot introduce new language features.
  For example: The 2.18.3 release _remains_ language version 2.18.
  It must remain compatible with 2.18.2, 2.18.1, and 2.18.0.

## Per-library language version selection {: #library-override}

By default, every Dart file in a package uses the same language version.
Dart identifies the default language version as the
lower-bound of the SDK constraint specified in the `pubspec.yaml` file.
Sometimes, a Dart file might need to use an older language version.
For example, you might not be able to migrate all the files in a package
to null safety at the same time.

Dart supports per-library language version selection.
To opt to have a different language version from
the rest of a package, a [Dart library][] must
include a comment in the following format:

```dart
// @dart = <major>.<minor>
```

For example:

```dart
// Description of what's in this file.
// @dart = 2.17
import 'dart:math';

// ...
```

The `@dart` string must be in a `//` comment (not `///` or `/*`),
and it must appear before any Dart code in the file.
Whitespace (tabs and spaces) doesn't matter,
except within the `@dart` and version strings.
As the previous example shows,
other comments can appear before the `@dart` comment.

[Dart library]: /tools/pub/create-packages#organizing-a-package

## Language-versioned changes

Language versioning helps Dart and its tooling evolve over time.
Besides potentially breaking syntax and semantic language changes,
new features and tooling changes might also be gated behind a language version.
For example, `dart format` might format Dart code differently depending on
the language version of the library it is formatting.

To find what changes each language version introduced,
you can reference the filterable [Dart changelog][].
To learn specific details about each language version and its features,
check out the [language documentation][] and the [language specification][].

:::tip
To review new Dart features and changes being
discussed, designed, and implemented,
check out the [Dart language funnel][] project on GitHub.
:::

[Dart changelog]: /changelog
[language documentation]: /language
[language specification]: /resources/language/spec
[Dart language funnel]: https://github.com/orgs/dart-lang/projects/90
