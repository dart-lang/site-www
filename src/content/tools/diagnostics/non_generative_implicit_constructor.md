---
title: non_generative_implicit_constructor
description: >-
  Details about the non_generative_implicit_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The unnamed constructor of superclass '{0}' (called by the default constructor
of '{1}') must be a generative constructor, but factory found._

## Description

The analyzer produces this diagnostic when a class has an implicit
generative constructor and the superclass has an explicit unnamed factory
constructor. The implicit constructor in the subclass implicitly invokes
the unnamed constructor in the superclass, but generative constructors can
only invoke another generative constructor, not a factory constructor.

## Example

The following code produces this diagnostic because the implicit
constructor in `B` invokes the unnamed constructor in `A`, but the
constructor in `A` is a factory constructor, when a generative constructor
is required:

```dart
class A {
  factory A() => throw 0;
  A.named();
}

class [!B!] extends A {}
```

## Common fixes

If the unnamed constructor in the superclass can be a generative
constructor, then change it to be a generative constructor:

```dart
class A {
  A();
  A.named();
}

class B extends A { }
```

If the unnamed constructor can't be a generative constructor and there are
other generative constructors in the superclass, then explicitly invoke
one of them:

```dart
class A {
  factory A() => throw 0;
  A.named();
}

class B extends A {
  B() : super.named();
}
```

If there are no generative constructors that can be used and none can be
added, then implement the superclass rather than extending it:

```dart
class A {
  factory A() => throw 0;
  A.named();
}

class B implements A {}
```
