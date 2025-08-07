---
title: const_constructor_with_non_const_super
description: >-
  Details about the const_constructor_with_non_const_super
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_A constant constructor can't call a non-constant super constructor of '{0}'._

## Description

The analyzer produces this diagnostic when a constructor that is marked as
`const` invokes a constructor from its superclass that isn't marked as
`const`.

## Example

The following code produces this diagnostic because the `const` constructor
in `B` invokes the constructor `nonConst` from the class `A`, and the
superclass constructor isn't a `const` constructor:

```dart
class A {
  const A();
  A.nonConst();
}

class B extends A {
  const B() : [!super.nonConst()!];
}
```

## Common fixes

If it isn't essential to invoke the superclass constructor that is
currently being invoked, then invoke a constant constructor from the
superclass:

```dart
class A {
  const A();
  A.nonConst();
}

class B extends A {
  const B() : super();
}
```

If it's essential that the current constructor be invoked and if you can
modify it, then add `const` to the constructor in the superclass:

```dart
class A {
  const A();
  const A.nonConst();
}

class B extends A {
  const B() : super.nonConst();
}
```

If it's essential that the current constructor be invoked and you can't
modify it, then remove `const` from the constructor in the subclass:

```dart
class A {
  const A();
  A.nonConst();
}

class B extends A {
  B() : super.nonConst();
}
```
