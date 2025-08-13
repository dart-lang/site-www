---
title: invalid_type_argument_in_const_literal
description: >-
  Details about the invalid_type_argument_in_const_literal
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Constant list literals can't use a type parameter in a type argument, such as '{0}'._
_Constant map literals can't use a type parameter in a type argument, such as '{0}'._
_Constant set literals can't use a type parameter in a type argument, such as '{0}'._

## Description

The analyzer produces this diagnostic when a type parameter is used in a
type argument in a list, map, or set literal that is prefixed by `const`.
This isn't allowed because the value of the type parameter (the actual type
that will be used at runtime) can't be known at compile time.

## Examples

The following code produces this diagnostic because the type parameter `T`
is being used as a type argument when creating a constant list:

```dart
List<T> newList<T>() => const <[!T!]>[];
```

The following code produces this diagnostic because the type parameter `T`
is being used as a type argument when creating a constant map:

```dart
Map<String, T> newSet<T>() => const <String, [!T!]>{};
```

The following code produces this diagnostic because the type parameter `T`
is being used as a type argument when creating a constant set:

```dart
Set<T> newSet<T>() => const <[!T!]>{};
```

## Common fixes

If the type that will be used for the type parameter can be known at
compile time, then remove the type parameter:

```dart
List<int> newList() => const <int>[];
```

If the type that will be used for the type parameter can't be known until
runtime, then remove the keyword `const`:

```dart
List<T> newList<T>() => <T>[];
```
