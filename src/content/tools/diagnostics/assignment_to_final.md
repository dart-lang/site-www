---
title: assignment_to_final
description: >-
  Details about the assignment_to_final
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_'{0}' can't be used as a setter because it's final._

## Description

The analyzer produces this diagnostic when it finds an invocation of a
setter, but there's no setter because the field with the same name was
declared to be `final` or `const`.

## Example

The following code produces this diagnostic because `v` is final:

```dart
class C {
  final v = 0;
}

f(C c) {
  c.[!v!] = 1;
}
```

## Common fixes

If you need to be able to set the value of the field, then remove the
modifier `final` from the field:

```dart
class C {
  int v = 0;
}

f(C c) {
  c.v = 1;
}
```
