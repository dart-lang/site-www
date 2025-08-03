---
title: prefix_identifier_not_followed_by_dot
description: >-
  Details about the prefix_identifier_not_followed_by_dot
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The name '{0}' refers to an import prefix, so it must be followed by '.'._

## Description

The analyzer produces this diagnostic when an import prefix is used by
itself, without accessing any of the names declared in the libraries
associated with the prefix. Prefixes aren't variables, and therefore can't
be used as a value.

## Example

The following code produces this diagnostic because the prefix `math` is
being used as if it were a variable:

```dart
import 'dart:math' as math;

void f() {
  print([!math!]);
}
```

## Common fixes

If the code is incomplete, then reference something in one of the libraries
associated with the prefix:

```dart
import 'dart:math' as math;

void f() {
  print(math.pi);
}
```

If the name is wrong, then correct the name.
