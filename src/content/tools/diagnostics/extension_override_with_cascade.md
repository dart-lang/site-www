---
title: extension_override_with_cascade
description: >-
  Details about the extension_override_with_cascade
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Extension overrides have no value so they can't be used as the receiver of a
cascade expression._

## Description

The analyzer produces this diagnostic when an extension override is used as
the receiver of a cascade expression. The value of a cascade expression
`e..m` is the value of the receiver `e`, but extension overrides aren't
expressions and don't have a value.

## Example

The following code produces this diagnostic because `E(3)` isn't an
expression:

```dart
extension E on int {
  void m() {}
}
f() {
  [!E!](3)..m();
}
```

## Common fixes

Use `.` rather than `..`:

```dart
extension E on int {
  void m() {}
}
f() {
  E(3).m();
}
```

If there are multiple cascaded accesses, you'll need to duplicate the
extension override for each one.
