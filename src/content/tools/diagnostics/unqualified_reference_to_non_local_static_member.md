---
title: unqualified_reference_to_non_local_static_member
description: >-
  Details about the unqualified_reference_to_non_local_static_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Static members from supertypes must be qualified by the name of the defining type._

## Description

The analyzer produces this diagnostic when code in one class references a
static member in a superclass without prefixing the member's name with the
name of the superclass. Static members can only be referenced without a
prefix in the class in which they're declared.

## Example

The following code produces this diagnostic because the static field `x` is
referenced in the getter `g` without prefixing it with the name of the
defining class:

```dart
class A {
  static int x = 3;
}

class B extends A {
  int get g => [!x!];
}
```

## Common fixes

Prefix the name of the static member with the name of the declaring class:

```dart
class A {
  static int x = 3;
}

class B extends A {
  int get g => A.x;
}
```
