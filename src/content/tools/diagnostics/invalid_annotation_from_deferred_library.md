---
title: invalid_annotation_from_deferred_library
description: >-
  Details about the invalid_annotation_from_deferred_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Constant values from a deferred library can't be used as annotations._

## Description

The analyzer produces this diagnostic when a constant from a library that
is imported using a deferred import is used as an annotation. Annotations
are evaluated at compile time, and constants from deferred libraries aren't
available at compile time.

For more information, check out
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

The following code produces this diagnostic because the constant `pi` is
being used as an annotation when the library `dart:math` is imported as
`deferred`:

```dart
import 'dart:math' deferred as math;

@[!math.pi!]
void f() {}
```

## Common fixes

If you need to reference the constant as an annotation, then remove the
keyword `deferred` from the import:

```dart
import 'dart:math' as math;

@math.pi
void f() {}
```

If you can use a different constant as an annotation, then replace the
annotation with a different constant:

```dart
@deprecated
void f() {}
```
