---
title: assignment_to_const
description: >-
  Details about the assignment_to_const
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Constant variables can't be assigned a value after initialization._

## Description

The analyzer produces this diagnostic when it finds an assignment to a
top-level variable, a static field, or a local variable that has the
`const` modifier. The value of a compile-time constant can't be changed at
runtime.

## Example

The following code produces this diagnostic because `c` is being assigned a
value even though it has the `const` modifier:

```dart
const c = 0;

void f() {
  [!c!] = 1;
  print(c);
}
```

## Common fixes

If the variable must be assignable, then remove the `const` modifier:

```dart
var c = 0;

void f() {
  c = 1;
  print(c);
}
```

If the constant shouldn't be changed, then either remove the assignment or
use a local variable in place of references to the constant:

```dart
const c = 0;

void f() {
  var v = 1;
  print(v);
}
```
