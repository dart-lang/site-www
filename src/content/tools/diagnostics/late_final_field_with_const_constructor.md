---
title: late_final_field_with_const_constructor
description: >-
  Details about the late_final_field_with_const_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Can't have a late final field in a class with a generative const constructor._

## Description

The analyzer produces this diagnostic when a class that has at least one
`const` constructor also has a field marked both `late` and `final`.

## Example

The following code produces this diagnostic because the class `A` has a
`const` constructor and the `final` field `f` is marked as `late`:

```dart
class A {
  [!late!] final int f;

  const A();
}
```

## Common fixes

If the field doesn't need to be marked `late`, then remove the `late`
modifier from the field:

```dart
class A {
  final int f = 0;

  const A();
}
```

If the field must be marked `late`, then remove the `const` modifier from
the constructors:

```dart
class A {
  late final int f;

  A();
}
```
