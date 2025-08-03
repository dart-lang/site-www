---
title: recursive_constructor_redirect
description: >-
  Details about the recursive_constructor_redirect
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Constructors can't redirect to themselves either directly or indirectly._

## Description

The analyzer produces this diagnostic when a constructor redirects to
itself, either directly or indirectly, creating an infinite loop.

## Examples

The following code produces this diagnostic because the generative
constructors `C.a` and `C.b` each redirect to the other:

```dart
class C {
  C.a() : [!this.b()!];
  C.b() : [!this.a()!];
}
```

The following code produces this diagnostic because the factory
constructors `A` and `B` each redirect to the other:

```dart
abstract class A {
  factory A() = [!B!];
}
class B implements A {
  factory B() = [!A!];
  B.named();
}
```

## Common fixes

In the case of generative constructors, break the cycle by finding defining
at least one of the constructors to not redirect to another constructor:

```dart
class C {
  C.a() : this.b();
  C.b();
}
```

In the case of factory constructors, break the cycle by defining at least
one of the factory constructors to do one of the following:

- Redirect to a generative constructor:

```dart
abstract class A {
  factory A() = B;
}
class B implements A {
  factory B() = B.named;
  B.named();
}
```

- Not redirect to another constructor:

```dart
abstract class A {
  factory A() = B;
}
class B implements A {
  factory B() {
    return B.named();
  }

  B.named();
}
```

- Not be a factory constructor:

```dart
abstract class A {
  factory A() = B;
}
class B implements A {
  B();
  B.named();
}
```
