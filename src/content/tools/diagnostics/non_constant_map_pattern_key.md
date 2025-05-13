---
title: non_constant_map_pattern_key
description: >-
  Details about the non_constant_map_pattern_key
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Key expressions in map patterns must be constants._

## Description

The analyzer produces this diagnostic when a key in a map pattern isn't a
constant expression.

## Example

The following code produces this diagnostic because the key `A()` isn't a
constant:

```dart
void f(Object x) {
  if (x case {[!A()!]: 0}) {}
}

class A {
  const A();
}
```

## Common fixes

Use a constant for the key:

```dart
void f(Object x) {
  if (x case {const A(): 0}) {}
}

class A {
  const A();
}
```
