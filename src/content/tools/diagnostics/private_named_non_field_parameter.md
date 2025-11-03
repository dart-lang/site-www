---
title: private_named_non_field_parameter
description: >-
  Details about the private_named_non_field_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Named parameters that don't refer to instance variables can't start with underscore._

## Description

The analyzer produces this diagnostic when a named parameter starts with
an underscore, unless it's an initializing formal or field parameter.

## Example

The following code produces this diagnostic because the named parameter
`_x` starts with an underscore:

```dart
class C {
  C({int [!_x!] = 0});
}
```

## Common fixes

If the parameter is intended to refer to a field, then add the missing
field:

```dart
class C {
  final int _x;
  C({this._x = 0});
  int get x => _x;
}
```

If the parameter isn't intended to refer to a field, then remove the
underscore:

```dart
class C {
  C({int x = 0});
}
```
