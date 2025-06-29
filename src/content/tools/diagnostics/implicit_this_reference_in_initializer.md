---
title: implicit_this_reference_in_initializer
description: >-
  Details about the implicit_this_reference_in_initializer
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The instance member '{0}' can't be accessed in an initializer._

## Description

The analyzer produces this diagnostic when it finds a reference to an
instance member in a constructor's initializer list.

## Example

The following code produces this diagnostic because `defaultX` is an
instance member:

```dart
class C {
  int x;

  C() : x = [!defaultX!];

  int get defaultX => 0;
}
```

## Common fixes

If the member can be made static, then do so:

```dart
class C {
  int x;

  C() : x = defaultX;

  static int get defaultX => 0;
}
```

If not, then replace the reference in the initializer with a different
expression that doesn't use an instance member:

```dart
class C {
  int x;

  C() : x = 0;

  int get defaultX => 0;
}
```
