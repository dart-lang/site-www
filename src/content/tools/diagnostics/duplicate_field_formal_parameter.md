---
title: duplicate_field_formal_parameter
description: >-
  Details about the duplicate_field_formal_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The field '{0}' can't be initialized by multiple parameters in the same
constructor._

## Description

The analyzer produces this diagnostic when there's more than one
initializing formal parameter for the same field in a constructor's
parameter list. It isn't useful to assign a value that will immediately be
overwritten.

## Example

The following code produces this diagnostic because `this.f` appears twice
in the parameter list:

```dart
class C {
  int f;

  C(this.f, this.[!f!]) {}
}
```

## Common fixes

Remove one of the initializing formal parameters:

```dart
class C {
  int f;

  C(this.f) {}
}
```
