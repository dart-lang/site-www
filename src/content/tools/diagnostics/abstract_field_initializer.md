---
title: abstract_field_initializer
description: >-
  Details about the abstract_field_initializer
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Abstract fields can't have initializers._

## Description

The analyzer produces this diagnostic when a field that has the `abstract`
modifier also has an initializer.

## Examples

The following code produces this diagnostic because `f` is marked as
`abstract` and has an initializer:

```dart
abstract class C {
  abstract int [!f!] = 0;
}
```

The following code produces this diagnostic because `f` is marked as
`abstract` and there's an initializer in the constructor:

```dart
abstract class C {
  abstract int f;

  C() : [!f!] = 0;
}
```

## Common fixes

If the field must be abstract, then remove the initializer:

```dart
abstract class C {
  abstract int f;
}
```

If the field isn't required to be abstract, then remove the keyword:

```dart
abstract class C {
  int f = 0;
}
```
