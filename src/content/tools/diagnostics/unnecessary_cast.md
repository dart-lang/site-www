---
title: unnecessary_cast
description: >-
  Details about the unnecessary_cast
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Unnecessary cast._

## Description

The analyzer produces this diagnostic when the value being cast is already
known to be of the type that it's being cast to.

## Example

The following code produces this diagnostic because `n` is already known to
be an `int` as a result of the `is` test:

```dart
void f(num n) {
  if (n is int) {
    ([!n as int!]).isEven;
  }
}
```

## Common fixes

Remove the unnecessary cast:

```dart
void f(num n) {
  if (n is int) {
    n.isEven;
  }
}
```
