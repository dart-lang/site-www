---
title: for_in_with_const_variable
description: >-
  Details about the for_in_with_const_variable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_A for-in loop variable can't be a 'const'._

## Description

The analyzer produces this diagnostic when the loop variable declared in a
for-in loop is declared to be a `const`. The variable can't be a `const`
because the value can't be computed at compile time.

## Example

The following code produces this diagnostic because the loop variable `x`
is declared to be a `const`:

```dart
void f() {
  for ([!const!] x in [0, 1, 2]) {
    print(x);
  }
}
```

## Common fixes

If there's a type annotation, then remove the `const` modifier from the
declaration.

If there's no type, then replace the `const` modifier with `final`, `var`,
or a type annotation:

```dart
void f() {
  for (final x in [0, 1, 2]) {
    print(x);
  }
}
```
