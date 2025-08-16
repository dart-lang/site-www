---
title: invalid_implementation_override
description: >-
  Details about the invalid_implementation_override
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_'{0}.{1}' ('{2}') isn't a valid concrete implementation of '{3}.{1}' ('{4}')._

_The setter '{0}.{1}' ('{2}') isn't a valid concrete implementation of '{3}.{1}'
('{4}')._

## Description

The analyzer produces this diagnostic when all of the following are true:

- A class defines an abstract member.
- There is a concrete implementation of that member in a superclass.
- The concrete implementation isn't a valid implementation of the abstract
  method.

The concrete implementation can be invalid because of incompatibilities in
either the return type, the types of the method's parameters, or the type
parameters.

## Example

The following code produces this diagnostic because the method `A.add` has
a parameter of type `int`, and the overriding method `B.add` has a
corresponding parameter of type `num`:

```dart
class A {
  int add(int a) => a;
}
class [!B!] extends A {
  int add(num a);
}
```

This is a problem because in an invocation of `B.add` like the following:

```dart
void f(B b) {
  b.add(3.4);
}
```

`B.add` is expecting to be able to take, for example, a `double`, but when
the method `A.add` is executed (because it's the only concrete
implementation of `add`), a runtime exception will be thrown because a
`double` can't be assigned to a parameter of type `int`.

## Common fixes

If the method in the subclass can conform to the implementation in the
superclass, then change the declaration in the subclass (or remove it if
it's the same):

```dart
class A {
  int add(int a) => a;
}
class B	extends A {
  int add(int a);
}
```

If the method in the superclass can be generalized to be a valid
implementation of the method in the subclass, then change the superclass
method:

```dart
class A {
  int add(num a) => a.floor();
}
class B	extends A {
  int add(num a);
}
```

If neither the method in the superclass nor the method in the subclass can
be changed, then provide a concrete implementation of the method in the
subclass:

```dart
class A {
  int add(int a) => a;
}
class B	extends A {
  int add(num a) => a.floor();
}
```
