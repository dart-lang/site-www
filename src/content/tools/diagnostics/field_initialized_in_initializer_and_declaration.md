---
title: field_initialized_in_initializer_and_declaration
description: >-
  Details about the field_initialized_in_initializer_and_declaration
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Fields can't be initialized in the constructor if they are final and were already initialized at their declaration._

## Description

The analyzer produces this diagnostic when a final field is initialized in
both the declaration of the field and in an initializer in a constructor.
Final fields can only be assigned once, so it can't be initialized in both
places.

## Example

The following code produces this diagnostic because `f` is :

```dart
class C {
  final int f = 0;
  C() : [!f!] = 1;
}
```

## Common fixes

If the initialization doesn't depend on any values passed to the
constructor, and if all of the constructors need to initialize the field to
the same value, then remove the initializer from the constructor:

```dart
class C {
  final int f = 0;
  C();
}
```

If the initialization depends on a value passed to the constructor, or if
different constructors need to initialize the field differently, then
remove the initializer in the field's declaration:

```dart
class C {
  final int f;
  C() : f = 1;
}
```
