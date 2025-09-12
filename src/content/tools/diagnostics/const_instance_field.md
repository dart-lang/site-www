---
title: const_instance_field
description: >-
  Details about the const_instance_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Only static fields can be declared as const._

## Description

The analyzer produces this diagnostic when an instance field is marked as
being const.

## Example

The following code produces this diagnostic because `f` is an instance
field:

```dart
class C {
  [!const!] int f = 3;
}
```

## Common fixes

If the field needs to be an instance field, then remove the keyword
`const`, or replace it with `final`:

```dart
class C {
  final int f = 3;
}
```

If the field really should be a const field, then make it a static field:

```dart
class C {
  static const int f = 3;
}
```
