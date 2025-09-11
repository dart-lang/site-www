---
title: final_initialized_in_declaration_and_constructor
description: >-
  Details about the final_initialized_in_declaration_and_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' is final and was given a value when it was declared, so it can't be set to a new value._

## Description

The analyzer produces this diagnostic when a final field is initialized
twice: once where it's declared and once by a constructor's parameter.

## Example

The following code produces this diagnostic because the field `f` is
initialized twice:

```dart
class C {
  final int f = 0;

  C(this.[!f!]);
}
```

## Common fixes

If the field should have the same value for all instances, then remove the
initialization in the parameter list:

```dart
class C {
  final int f = 0;

  C();
}
```

If the field can have different values in different instances, then remove
the initialization in the declaration:

```dart
class C {
  final int f;

  C(this.f);
}
```
