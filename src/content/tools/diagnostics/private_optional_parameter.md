---
title: private_optional_parameter
description: >-
  Details about the private_optional_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Named parameters can't start with an underscore._

## Description

The analyzer produces this diagnostic when the name of a named parameter
starts with an underscore.

## Example

The following code produces this diagnostic because the named parameter
`_x` starts with an underscore:

```dart
class C {
  void m({int [!_x!] = 0}) {}
}
```

## Common fixes

Rename the parameter so that it doesn't start with an underscore:

```dart
class C {
  void m({int x = 0}) {}
}
```
