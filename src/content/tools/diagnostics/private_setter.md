---
title: private_setter
description: >-
  Details about the private_setter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The setter '{0}' is private and can't be accessed outside the library that declares it._

## Description

The analyzer produces this diagnostic when a private setter is used in a
library where it isn't visible.

## Example

Given a file `a.dart` that contains the following:

```dart
class A {
  static int _f = 0;
}
```

The following code produces this diagnostic because it references the
private setter `_f` even though the setter isn't visible:

```dart
import 'a.dart';

void f() {
  A.[!_f!] = 0;
}
```

## Common fixes

If you're able to make the setter public, then do so:

```dart
class A {
  static int f = 0;
}
```

If you aren't able to make the setter public, then find a different way to
implement the code.
