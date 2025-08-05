---
title: const_constructor_with_field_initialized_by_non_const
description: >-
  Details about the const_constructor_with_field_initialized_by_non_const
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Can't define the 'const' constructor because the field '{0}' is initialized with a non-constant value._

## Description

The analyzer produces this diagnostic when a constructor has the keyword
`const`, but a field in the class is initialized to a non-constant value.

## Example

The following code produces this diagnostic because the field `s` is
initialized to a non-constant value:

```dart
String x = '3';
class C {
  final String s = x;
  [!const!] C();
}
```

## Common fixes

If the field can be initialized to a constant value, then change the
initializer to a constant expression:

```dart
class C {
  final String s = '3';
  const C();
}
```

If the field can't be initialized to a constant value, then remove the
keyword `const` from the constructor:

```dart
String x = '3';
class C {
  final String s = x;
  C();
}
```
