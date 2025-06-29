---
title: inconsistent_language_version_override
description: >-
  Details about the inconsistent_language_version_override
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Parts must have exactly the same language version override as the library._

## Description

The analyzer produces this diagnostic when a [part file][] has a language
version override comment that specifies a different language version than
the one being used for the library to which the part belongs.

## Example

Given a [part file][] named `part.dart` that contains the following:

```dart
// @dart = 2.14
part of 'test.dart';
```

The following code produces this diagnostic because the parts of a library
must have the same language version as the defining compilation unit:

```dart
// @dart = 2.15
part [!'part.dart'!];
```

## Common fixes

Remove the language version override from the [part file][], so that it
implicitly uses the same version as the defining compilation unit:

```dart
part of 'test.dart';
```

If necessary, either adjust the language version override in the defining
compilation unit to be appropriate for the code in the part, or migrate
the code in the [part file][] to be consistent with the new language
version.

[part file]: /resources/glossary#part-file
