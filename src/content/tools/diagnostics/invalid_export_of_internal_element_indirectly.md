---
title: invalid_export_of_internal_element_indirectly
description: >-
  Details about the invalid_export_of_internal_element_indirectly
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The member '{0}' can't be exported as a part of a package's public API, but is indirectly exported as part of the signature of '{1}'._

## Description

The analyzer produces this diagnostic when a [public library][] exports a
top-level function  with a return type or at least one parameter type that
is marked with the [`internal`][meta-internal] annotation.

## Example

Given a file `a.dart` in the `src` directory that contains the
following:

```dart
import 'package:meta/meta.dart';

@internal
typedef IntFunction = int Function();

int f(IntFunction g) => g();
```

The following code produces this diagnostic because the function `f` has a
parameter of type `IntFunction`, and `IntFunction` is only intended to be
used internally:

```dart
[!export 'src/a.dart' show f;!]
```

## Common fixes

If the function must be public, then make all the types in the function's
signature public types.

If the function doesn't need to be exported, then stop exporting it,
either by removing it from the `show` clause, adding it to the `hide`
clause, or by removing the export.

[meta-internal]: https://pub.dev/documentation/meta/latest/meta/internal-constant.html
[public library]: /resources/glossary#public-library
