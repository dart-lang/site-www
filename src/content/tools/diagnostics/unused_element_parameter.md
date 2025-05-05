---
title: unused_element_parameter
description: >-
  Details about the unused_element_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_A value for optional parameter '{0}' isn't ever given._

## Description

The analyzer produces this diagnostic when a value is never passed for an
optional parameter declared within a private declaration.

## Example

Assuming that no code in the library passes a value for `y` in any
invocation of `_m`, the following code produces this diagnostic:

```dart
class C {
  void _m(int x, [int? [!y!]]) {}

  void n() => _m(0);
}
```

## Common fixes

If the declaration isn't needed, then remove it:

```dart
class C {
  void _m(int x) {}

  void n() => _m(0);
}
```

If the declaration is intended to be used, then add the code to use it.
