---
title: no_combined_super_signature
description: >-
  Details about the no_combined_super_signature
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Can't infer missing types in '{0}' from overridden methods: {1}._

## Description

The analyzer produces this diagnostic when there is a method declaration
for which one or more types needs to be inferred, and those types can't be
inferred because none of the overridden methods has a function type that is
a supertype of all the other overridden methods, as specified by
[override inference][].

## Example

The following code produces this diagnostic because the method `m` declared
in the class `C` is missing both the return type and the type of the
parameter `a`, and neither of the missing types can be inferred for it:

```dart
abstract class A {
  A m(String a);
}

abstract class B {
  B m(int a);
}

abstract class C implements A, B {
  [!m!](a);
}
```

In this example, override inference can't be performed because the
overridden methods are incompatible in these ways:
- Neither parameter type (`String` and `int`) is a supertype of the other.
- Neither return type is a subtype of the other.

## Common fixes

If possible, add types to the method in the subclass that are consistent
with the types from all the overridden methods:

```dart
abstract class A {
  A m(String a);
}

abstract class B {
  B m(int a);
}

abstract class C implements A, B {
  C m(Object a);
}
```

[override inference]: /resources/glossary#override-inference
