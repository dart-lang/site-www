---
title: undefined_operator
description: >-
  Details about the undefined_operator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The operator '{0}' isn't defined for the type '{1}'._

## Description

The analyzer produces this diagnostic when a user-definable operator is
invoked on an object for which the operator isn't defined.

## Example

The following code produces this diagnostic because the class `C` doesn't
define the operator `+`:

```dart
class C {}

C f(C c) => c [!+!] 2;
```

## Common fixes

If the operator should be defined for the class, then define it:

```dart
class C {
  C operator +(int i) => this;
}

C f(C c) => c + 2;
```
