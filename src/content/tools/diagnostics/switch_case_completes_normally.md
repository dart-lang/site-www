---
title: switch_case_completes_normally
description: >-
  Details about the switch_case_completes_normally
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The 'case' shouldn't complete normally._

## Description

The analyzer produces this diagnostic when the statements following a
`case` label in a `switch` statement could fall through to the next `case`
or `default` label.

## Example

The following code produces this diagnostic because the `case` label with
 a value of zero (`0`) falls through to the `default` statements:

```dart
void f(int a) {
  switch (a) {
    [!case!] 0:
      print(0);
    default:
      return;
  }
}
```

## Common fixes

Change the flow of control so that the `case` won't fall through. There
are several ways that this can be done, including adding one of the
following at the end of the current list of statements:
- a `return` statement,
- a `throw` expression,
- a `break` statement,
- a `continue`, or
- an invocation of a function or method whose return type is `Never`.
