---
title: late_final_local_already_assigned
description: >-
  Details about the late_final_local_already_assigned
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The late final local variable is already assigned._

## Description

The analyzer produces this diagnostic when the analyzer can prove that a
local variable marked as both `late` and `final` was already assigned a
value at the point where another assignment occurs.

Because `final` variables can only be assigned once, subsequent assignments
are guaranteed to fail, so they're flagged.

## Example

The following code produces this diagnostic because the `final` variable
`v` is assigned a value in two places:

```dart
int f() {
  late final int v;
  v = 0;
  [!v!] += 1;
  return v;
}
```

## Common fixes

If you need to be able to reassign the variable, then remove the `final`
keyword:

```dart
int f() {
  late int v;
  v = 0;
  v += 1;
  return v;
}
```

If you don't need to reassign the variable, then remove all except the
first of the assignments:

```dart
int f() {
  late final int v;
  v = 0;
  return v;
}
```
