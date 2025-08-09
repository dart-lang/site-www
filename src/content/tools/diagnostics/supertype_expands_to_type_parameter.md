---
title: supertype_expands_to_type_parameter
description: >-
  Details about the supertype_expands_to_type_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_A type alias that expands to a type parameter can't be implemented._

_A type alias that expands to a type parameter can't be mixed in._

_A type alias that expands to a type parameter can't be used as a superclass
constraint._

_A type alias that expands to a type parameter can't be used as a superclass._

## Description

The analyzer produces this diagnostic when a type alias that expands to a
type parameter is used in an `extends`, `implements`, `with`, or `on`
clause.

## Example

The following code produces this diagnostic because the type alias `T`,
which expands to the type parameter `S`, is used in the `extends` clause of
the class `C`:

```dart
typedef T<S> = S;

class C extends [!T!]<Object> {}
```

## Common fixes

Use the value of the type argument directly:

```dart
typedef T<S> = S;

class C extends Object {}
```
