---
title: const_constructor_param_type_mismatch
description: >-
  Details about the const_constructor_param_type_mismatch
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_A value of type '{0}' can't be assigned to a parameter of type '{1}' in a const
constructor._

## Description

The analyzer produces this diagnostic when the runtime type of a constant
value can't be assigned to the static type of a constant constructor's
parameter.

## Example

The following code produces this diagnostic because the runtime type of `i`
is `int`, which can't be assigned to the static type of `s`:

```dart
class C {
  final String s;

  const C(this.s);
}

const dynamic i = 0;

void f() {
  const C([!i!]);
}
```

## Common fixes

Pass a value of the correct type to the constructor:

```dart
class C {
  final String s;

  const C(this.s);
}

const dynamic i = 0;

void f() {
  const C('$i');
}
```
