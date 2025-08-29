---
title: assignment_to_method
description: >-
  Details about the assignment_to_method
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Methods can't be assigned a value._

## Description

The analyzer produces this diagnostic when the target of an assignment is a
method.

## Example

The following code produces this diagnostic because `f` can't be assigned a
value because it's a method:

```dart
class C {
  void f() {}

  void g() {
    [!f!] = null;
  }
}
```

## Common fixes

Rewrite the code so that there isn't an assignment to a method.
