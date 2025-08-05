---
title: undefined_setter
description: >-
  Details about the undefined_setter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The setter '{0}' isn't defined for the '{1}' function type._
_The setter '{0}' isn't defined for the type '{1}'._

## Description

The analyzer produces this diagnostic when it encounters an identifier that
appears to be the name of a setter but either isn't defined or isn't
visible in the scope in which the identifier is being referenced.

## Example

The following code produces this diagnostic because there isn't a setter
named `z`:

```dart
class C {
  int x = 0;
  void m(int y) {
    this.[!z!] = y;
  }
}
```

## Common fixes

If the identifier isn't defined, then either define it or replace it with
the name of a setter that is defined. The example above can be corrected by
fixing the spelling of the setter:

```dart
class C {
  int x = 0;
  void m(int y) {
    this.x = y;
  }
}
```
