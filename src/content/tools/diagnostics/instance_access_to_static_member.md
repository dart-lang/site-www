---
title: instance_access_to_static_member
description: >-
  Details about the instance_access_to_static_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The static {0} '{1}' can't be accessed through an instance._

## Description

The analyzer produces this diagnostic when an access operator is used to
access a static member through an instance of the class.

## Example

The following code produces this diagnostic because `zero` is a static
field, but it's being accessed as if it were an instance field:

```dart
void f(C c) {
  c.[!zero!];
}

class C {
  static int zero = 0;
}
```

## Common fixes

Use the class to access the static member:

```dart
void f(C c) {
  C.zero;
}

class C {
  static int zero = 0;
}
```
