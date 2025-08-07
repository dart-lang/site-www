---
title: inconsistent_inheritance
description: >-
  Details about the inconsistent_inheritance
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Superinterfaces don't have a valid override for '{0}': {1}._

## Description

The analyzer produces this diagnostic when a class inherits two or more
conflicting signatures for a member and doesn't provide an implementation
that satisfies all the inherited signatures.

## Example

The following code produces this diagnostic because `C` is inheriting the
declaration of `m` from `A`, and that implementation isn't consistent with
the signature of `m` that's inherited from `B`:

```dart
class A {
  void m({int? a}) {}
}

class B {
  void m({int? b}) {}
}

class [!C!] extends A implements B {
}
```

## Common fixes

Add an implementation of the method that satisfies all the inherited
signatures:

```dart
class A {
  void m({int? a}) {}
}

class B {
  void m({int? b}) {}
}

class C extends A implements B {
  void m({int? a, int? b}) {}
}
```
