---
title: wrong_number_of_type_arguments_constructor
description: >-
  Details about the wrong_number_of_type_arguments_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The constructor '{0}.{1}' doesn't have type parameters._

_The constructor '{0}.{1}` doesn't have type parameters._

## Description

The analyzer produces this diagnostic when type arguments are provided
after the name of a named constructor. Constructors can't declare type
parameters, so invocations can only provide the type arguments associated
with the class, and those type arguments are required to follow the name of
the class rather than the name of the constructor.

## Example

The following code produces this diagnostic because the type parameters
(`<String>`) follow the name of the constructor rather than the name of the
class:

```dart
class C<T> {
  C.named();
}
C f() => C.named[!<String>!]();
```

## Common fixes

If the type arguments are for the class' type parameters, then move the
type arguments to follow the class name:

```dart
class C<T> {
  C.named();
}
C f() => C<String>.named();
```

If the type arguments aren't for the class' type parameters, then remove
them:

```dart
class C<T> {
  C.named();
}
C f() => C.named();
```
