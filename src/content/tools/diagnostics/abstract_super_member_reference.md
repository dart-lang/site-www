---
title: abstract_super_member_reference
description: >-
  Details about the abstract_super_member_reference
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The {0} '{1}' is always abstract in the supertype._

## Description

The analyzer produces this diagnostic when an inherited member is
referenced using `super`, but there is no concrete implementation of the
member in the superclass chain. Abstract members can't be invoked.

## Example

The following code produces this diagnostic because `B` doesn't inherit a
concrete implementation of `a`:

```dart
abstract class A {
  int get a;
}
class B extends A {
  int get a => super.[!a!];
}
```

## Common fixes

Remove the invocation of the abstract member, possibly replacing it with an
invocation of a concrete member.
