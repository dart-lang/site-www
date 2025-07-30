---
title: type_check_with_null
description: >-
  Details about the type_check_with_null
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Tests for non-null should be done with '!= null'._

_Tests for null should be done with '== null'._

## Description

The analyzer produces this diagnostic when there's a type check (using the
`as` operator) where the type is `Null`. There's only one value whose type
is `Null`, so the code is both more readable and more performant when it
tests for `null` explicitly.

## Examples

The following code produces this diagnostic because the code is testing to
see whether the value of `s` is `null` by using a type check:

```dart
void f(String? s) {
  if ([!s is Null!]) {
    return;
  }
  print(s);
}
```

The following code produces this diagnostic because the code is testing to
see whether the value of `s` is something other than `null` by using a type
check:

```dart
void f(String? s) {
  if ([!s is! Null!]) {
    print(s);
  }
}
```

## Common fixes

Replace the type check with the equivalent comparison with `null`:

```dart
void f(String? s) {
  if (s == null) {
    return;
  }
  print(s);
}
```
