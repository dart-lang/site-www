---
title: assignment_to_final_local
description: >-
  Details about the assignment_to_final_local
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The final variable '{0}' can only be set once._

## Description

The analyzer produces this diagnostic when a local variable that was
declared to be final is assigned after it was initialized.

## Example

The following code produces this diagnostic because `x` is final, so it
can't have a value assigned to it after it was initialized:

```dart
void f() {
  final x = 0;
  [!x!] = 3;
  print(x);
}
```

## Common fixes

Remove the keyword `final`, and replace it with `var` if there's no type
annotation:

```dart
void f() {
  var x = 0;
  x = 3;
  print(x);
}
```
