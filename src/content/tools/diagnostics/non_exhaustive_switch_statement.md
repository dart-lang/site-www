---
title: non_exhaustive_switch_statement
description: >-
  Details about the non_exhaustive_switch_statement
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The type '{0}' isn't exhaustively matched by the switch cases since it doesn't match the pattern '{1}'._

## Description

The analyzer produces this diagnostic when a `switch` statement switching
over an exhaustive type is missing a case for one or more of the possible
values that could flow through it.

## Example

The following code produces this diagnostic because the switch statement
doesn't have a case for the value `E.three`, and `E` is an exhaustive
type:

```dart
enum E { one, two, three }

void f(E e) {
  [!switch!] (e) {
    case E.one:
    case E.two:
  }
}
```

## Common fixes

Add a case for each of the constants that aren't currently being matched:

```dart
enum E { one, two, three }

void f(E e) {
  switch (e) {
    case E.one:
    case E.two:
      break;
    case E.three:
  }
}
```

If the missing values don't need to be matched, then add a `default`
clause or a wildcard pattern:

```dart
enum E { one, two, three }

void f(E e) {
  switch (e) {
    case E.one:
    case E.two:
      break;
    default:
  }
}
```

But be aware that adding a `default` clause or wildcard pattern will cause
any future values of the exhaustive type to also be handled, so you will
have lost the ability for the compiler to warn you if the `switch` needs
to be updated.
