---
title: import_of_legacy_library_into_null_safe
description: >-
  Details about the import_of_legacy_library_into_null_safe
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The library '{0}' is legacy, and shouldn't be imported into a null safe library._

## Description

The analyzer produces this diagnostic when a library that is null safe
imports a library that isn't null safe.

## Example

Given a file `a.dart` that contains the following:

```dart
// @dart = 2.9

class A {}
```

The following code produces this diagnostic because a library that null
safe is importing a library that isn't null safe:

```dart
import [!'a.dart'!];

A? f() => null;
```

## Common fixes

If you can migrate the imported library to be null safe, then migrate it
and update or remove the migrated library's language version.

If you can't migrate the imported library, then the importing library
needs to have a language version that is before 2.12, when null safety was
enabled by default.
