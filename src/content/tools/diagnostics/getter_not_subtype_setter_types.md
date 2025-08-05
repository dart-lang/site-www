---
title: getter_not_subtype_setter_types
description: >-
  Details about the getter_not_subtype_setter_types
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The return type of getter '{0}' is '{1}' which isn't a subtype of the type '{2}' of its setter '{3}'._

## Description

The analyzer produces this diagnostic when the return type of a getter
isn't a subtype of the type of the parameter of a setter with the same
name.

The subtype relationship is a requirement whether the getter and setter are
in the same class or whether one of them is in a superclass of the other.

## Example

The following code produces this diagnostic because the return type of the
getter `x` is `num`, the parameter type of the setter `x` is `int`, and
`num` isn't a subtype of `int`:

```dart
class C {
  num get [!x!] => 0;

  set x(int y) {}
}
```

## Common fixes

If the type of the getter is correct, then change the type of the setter:

```dart
class C {
  num get x => 0;

  set x(num y) {}
}
```

If the type of the setter is correct, then change the type of the getter:

```dart
class C {
  int get x => 0;

  set x(int y) {}
}
```
