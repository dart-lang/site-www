---
title: generic_method_type_instantiation_on_dynamic
description: >-
  Details about the generic_method_type_instantiation_on_dynamic
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_A method tear-off on a receiver whose type is 'dynamic' can't have type
arguments._

## Description

The analyzer produces this diagnostic when an instance method is being torn
off from a receiver whose type is `dynamic`, and the tear-off includes type
arguments. Because the analyzer can't know how many type parameters the
method has, or whether it has any type parameters, there's no way it can
validate that the type arguments are correct. As a result, the type
arguments aren't allowed.

## Example

The following code produces this diagnostic because the type of `p` is
`dynamic` and the tear-off of `m` has type arguments:

```dart
void f(dynamic list) {
  [!list.fold!]<int>;
}
```

## Common fixes

If you can use a more specific type than `dynamic`, then change the type of
the receiver:

```dart
void f(List<Object> list) {
  list.fold<int>;
}
```

If you can't use a more specific type, then remove the type arguments:

```dart
void f(dynamic list) {
  list.cast;
}
```
