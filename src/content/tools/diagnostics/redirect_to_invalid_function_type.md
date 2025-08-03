---
title: redirect_to_invalid_function_type
description: >-
  Details about the redirect_to_invalid_function_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The redirected constructor '{0}' has incompatible parameters with '{1}'._

## Description

The analyzer produces this diagnostic when a factory constructor attempts
to redirect to another constructor, but the two have incompatible
parameters. The parameters are compatible if all of the parameters of the
redirecting constructor can be passed to the other constructor and if the
other constructor doesn't require any parameters that aren't declared by
the redirecting constructor.

## Examples

The following code produces this diagnostic because the constructor for `A`
doesn't declare a parameter that the constructor for `B` requires:

```dart
abstract class A {
  factory A() = [!B!];
}

class B implements A {
  B(int x);
  B.zero();
}
```

The following code produces this diagnostic because the constructor for `A`
declares a named parameter (`y`) that the constructor for `B` doesn't
allow:

```dart
abstract class A {
  factory A(int x, {int y}) = [!B!];
}

class B implements A {
  B(int x);
}
```

## Common fixes

If there's a different constructor that is compatible with the redirecting
constructor, then redirect to that constructor:

```dart
abstract class A {
  factory A() = B.zero;
}

class B implements A {
  B(int x);
  B.zero();
}
```

Otherwise, update the redirecting constructor to be compatible:

```dart
abstract class A {
  factory A(int x) = B;
}

class B implements A {
  B(int x);
}
```
