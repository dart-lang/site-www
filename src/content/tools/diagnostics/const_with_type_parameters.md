---
title: const_with_type_parameters
description: >-
  Details about the const_with_type_parameters
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A constant constructor tearoff can't use a type parameter as a type argument._
_A constant creation can't use a type parameter as a type argument._
_A constant function tearoff can't use a type parameter as a type argument._

## Description

The analyzer produces this diagnostic when a type parameter is used as a
type argument in a `const` invocation of a constructor. This isn't allowed
because the value of the type parameter (the actual type that will be used
at runtime) can't be known at compile time.

## Example

The following code produces this diagnostic because the type parameter `T`
is being used as a type argument when creating a constant:

```dart
class C<T> {
  const C();
}

C<T> newC<T>() => const C<[!T!]>();
```

## Common fixes

If the type that will be used for the type parameter can be known at
compile time, then remove the use of the type parameter:

```dart
class C<T> {
  const C();
}

C<int> newC() => const C<int>();
```

If the type that will be used for the type parameter can't be known until
runtime, then remove the keyword `const`:

```dart
class C<T> {
  const C();
}

C<T> newC<T>() => C<T>();
```
