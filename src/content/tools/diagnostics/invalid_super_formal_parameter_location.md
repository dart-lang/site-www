---
title: invalid_super_formal_parameter_location
description: >-
  Details about the invalid_super_formal_parameter_location
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Super parameters can only be used in non-redirecting generative constructors._

## Description

The analyzer produces this diagnostic when a super parameter is used
anywhere other than a non-redirecting generative constructor.

## Examples

The following code produces this diagnostic because the super parameter
`x` is in a redirecting generative constructor:

```dart
class A {
  A(int x);
}

class B extends A {
  B.b([!super!].x) : this._();
  B._() : super(0);
}
```

The following code produces this diagnostic because the super parameter
`x` isn't in a generative constructor:

```dart
class A {
  A(int x);
}

class C extends A {
  factory C.c([!super!].x) => C._();
  C._() : super(0);
}
```

The following code produces this diagnostic because the super parameter
`x` is in a method:

```dart
class A {
  A(int x);
}

class D extends A {
  D() : super(0);

  void m([!super!].x) {}
}
```

## Common fixes

If the function containing the super parameter can be changed to be a
non-redirecting generative constructor, then do so:

```dart
class A {
  A(int x);
}

class B extends A {
  B.b(super.x);
}
```

If the function containing the super parameter can't be changed to be a
non-redirecting generative constructor, then remove the `super`:

```dart
class A {
  A(int x);
}

class D extends A {
  D() : super(0);

  void m(int x) {}
}
```
