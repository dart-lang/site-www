---
title: export_legacy_symbol
description: >-
  Details about the export_legacy_symbol
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The symbol '{0}' is defined in a legacy library, and can't be re-exported from a library with null safety enabled._

## Description

The analyzer produces this diagnostic when a library that was opted in to
null safety exports another library, and the exported library is opted out
of null safety.

## Example

Given a library that is opted out of null safety:

```dart
// @dart = 2.8
String s;
```

The following code produces this diagnostic because it's exporting symbols
from an opted-out library:

```dart
export [!'optedOut.dart'!];

class C {}
```

## Common fixes

If you're able to do so, migrate the exported library so that it doesn't
need to opt out:

```dart
String? s;
```

If you can't migrate the library, then remove the export:

```dart
class C {}
```

If the exported library (the one that is opted out) itself exports an
opted-in library, then it's valid for your library to indirectly export the
symbols from the opted-in library. You can do so by adding a hide
combinator to the export directive in your library that hides all of the
names declared in the opted-out library.
