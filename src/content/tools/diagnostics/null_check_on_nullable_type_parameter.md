---
title: null_check_on_nullable_type_parameter
description: >-
  Details about the null_check_on_nullable_type_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/null_check_on_nullable_type_parameter"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The null check operator shouldn't be used on a variable whose type is a potentially nullable type parameter._

## Description

The analyzer produces this diagnostic when a null check operator is used
on a variable whose type is `T?`, where `T` is a type parameter that
allows the type argument to be nullable (either has no bound or has a
bound that is nullable).

Given a generic type parameter `T` which has a nullable bound, it is very
easy to introduce erroneous null checks when working with a variable of
type `T?`. Specifically, it is not uncommon to have `T? x;` and want to
assert that `x` has been set to a valid value of type `T`. A common
mistake is to do so using `x!`. This is almost always incorrect, because
if `T` is a nullable type, `x` may validly hold `null` as a value of type
`T`.

## Example

The following code produces this diagnostic because `t` has the type `T?`
and `T` allows the type argument to be nullable (because it has no
`extends` clause):

```dart
T f<T>(T? t) => t[!!!];
```

## Common fixes

Use the type parameter to cast the variable:

```dart
T f<T>(T? t) => t as T;
```
