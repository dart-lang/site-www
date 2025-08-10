---
title: case_block_not_terminated
description: >-
  Details about the case_block_not_terminated
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The last statement of the 'case' should be 'break', 'continue', 'rethrow',
'return', or 'throw'._

## Description

The analyzer produces this diagnostic when the last statement in a `case`
block isn't one of the required terminators: `break`, `continue`,
`rethrow`, `return`, or `throw`.

## Example

The following code produces this diagnostic because the `case` block ends
with an assignment:

```dart
void f(int x) {
  switch (x) {
    [!case!] 0:
      x += 2;
    default:
      x += 1;
  }
}
```

## Common fixes

Add one of the required terminators:

```dart
void f(int x) {
  switch (x) {
    case 0:
      x += 2;
      break;
    default:
      x += 1;
  }
}
```
