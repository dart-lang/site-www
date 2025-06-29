---
title: conflicting_constructor_and_static_member
description: >-
  Details about the conflicting_constructor_and_static_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_'{0}' can't be used to name both a constructor and a static field in this
class._

_'{0}' can't be used to name both a constructor and a static getter in this
class._

_'{0}' can't be used to name both a constructor and a static method in this
class._

_'{0}' can't be used to name both a constructor and a static setter in this
class._

## Description

The analyzer produces this diagnostic when a named constructor and either a
static method or static field have the same name. Both are accessed using
the name of the class, so having the same name makes the reference
ambiguous.

## Examples

The following code produces this diagnostic because the static field `foo`
and the named constructor `foo` have the same name:

```dart
class C {
  C.[!foo!]();
  static int foo = 0;
}
```

The following code produces this diagnostic because the static method `foo`
and the named constructor `foo` have the same name:

```dart
class C {
  C.[!foo!]();
  static void foo() {}
}
```

## Common fixes

Rename either the member or the constructor.
