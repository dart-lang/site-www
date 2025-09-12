---
title: label_undefined
description: >-
  Details about the label_undefined
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Can't reference an undefined label '{0}'._

## Description

The analyzer produces this diagnostic when it finds a reference to a label
that isn't defined in the scope of the `break` or `continue` statement that
is referencing it.

## Example

The following code produces this diagnostic because the label `loop` isn't
defined anywhere:

```dart
void f() {
  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      if (j != 0) {
        break [!loop!];
      }
    }
  }
}
```

## Common fixes

If the label should be on the innermost enclosing `do`, `for`, `switch`, or
`while` statement, then remove the label:

```dart
void f() {
  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      if (j != 0) {
        break;
      }
    }
  }
}
```

If the label should be on some other statement, then add the label:

```dart
void f() {
  loop: for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      if (j != 0) {
        break loop;
      }
    }
  }
}
```
