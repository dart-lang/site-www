---
title: invalid_language_version_override
description: >-
  Details about the invalid_language_version_override
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The Dart language version override comment can't be followed by any non-whitespace characters._

_The Dart language version override comment must be specified with a version number, like '2.0', after the '=' character._

_The Dart language version override comment must be specified with an '=' character._

_The Dart language version override comment must be specified with exactly two slashes._

_The Dart language version override comment must be specified with the word 'dart' in all lower case._

_The Dart language version override number can't be prefixed with a letter._

_The Dart language version override number must begin with '@dart'._

_The language version override can't specify a version greater than the latest known language version: {0}.{1}._

_The language version override must be specified before any declaration or directive._

## Description

The analyzer produces this diagnostic when a comment that appears to be an
attempt to specify a language version override doesn't conform to the
requirements for such a comment. For more information, see
[Per-library language version selection](https://dart.dev/resources/language/evolution#per-library-language-version-selection).

## Example

The following code produces this diagnostic because the word `dart` must
be lowercase in such a comment and because there's no equal sign between
the word `dart` and the version number:

```dart
[!// @Dart 2.13!]
```

## Common fixes

If the comment is intended to be a language version override, then change
the comment to follow the correct format:

```dart
// @dart = 2.13
```
