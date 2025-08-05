---
title: invalid_override_of_non_virtual_member
description: >-
  Details about the invalid_override_of_non_virtual_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The member '{0}' is declared non-virtual in '{1}' and can't be overridden in subclasses._

## Description

The analyzer produces this diagnostic when a member of a class, mixin, or
enum overrides a member that has the `@nonVirtual` annotation on it.

## Example

The following code produces this diagnostic because the method `m` in `B`
overrides the method `m` in `A`, and the method `m` in `A` is annotated
with the `@nonVirtual` annotation:

```dart
import 'package:meta/meta.dart';

class A {
  @nonVirtual
  void m() {}
}

class B extends A {
  @override
  void [!m!]() {}
}
```

## Common fixes

If the annotation on the method in the superclass is correct (the method
in the superclass is not intended to be overridden), then remove or rename
the overriding method:

```dart
import 'package:meta/meta.dart';

class A {
  @nonVirtual
  void m() {}
}

class B extends A {}
```

If the method in the superclass is intended to be overridden, then remove
the `@nonVirtual` annotation:

```dart
class A {
  void m() {}
}

class B extends A {
  @override
  void m() {}
}
```
