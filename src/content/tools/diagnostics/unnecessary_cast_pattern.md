---
title: unnecessary_cast_pattern
description: >-
  Details about the unnecessary_cast_pattern
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Unnecessary cast pattern._

## Description

The analyzer produces this diagnostic when a cast pattern is used on a
value that is known to be of the specified type.

## Example

The following code produces this diagnostic because the cast `as num` is
known to always succeed because the type of `z` is `int`:

```dart
void f(int x) {
  if (x case var z [!as!] num) {
    print(z);
  }
}
```

## Common fixes

Remove the cast pattern:

```dart
void f(int x) {
  if (x case var z) {
    print(z);
  }
}
```
