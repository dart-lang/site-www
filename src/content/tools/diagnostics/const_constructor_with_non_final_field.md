---
title: const_constructor_with_non_final_field
description: >-
  Details about the const_constructor_with_non_final_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Can't define a const constructor for a class with non-final fields._

## Description

The analyzer produces this diagnostic when a constructor is marked as a
const constructor, but the constructor is defined in a class that has at
least one non-final instance field (either directly or by inheritance).

## Example

The following code produces this diagnostic because the field `x` isn't
final:

```dart
class C {
  int x;

  const [!C!](this.x);
}
```

## Common fixes

If it's possible to mark all of the fields as final, then do so:

```dart
class C {
  final int x;

  const C(this.x);
}
```

If it isn't possible to mark all of the fields as final, then remove the
keyword `const` from the constructor:

```dart
class C {
  int x;

  C(this.x);
}
```
