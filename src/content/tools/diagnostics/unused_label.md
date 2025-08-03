---
title: unused_label
description: >-
  Details about the unused_label
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The label '{0}' isn't used._

## Description

The analyzer produces this diagnostic when a label that isn't used is
found.

## Example

The following code produces this diagnostic because the label `loop` isn't
referenced anywhere in the method:

```dart
void f(int limit) {
  [!loop:!] for (int i = 0; i < limit; i++) {
    print(i);
  }
}
```

## Common fixes

If the label isn't needed, then remove it:

```dart
void f(int limit) {
  for (int i = 0; i < limit; i++) {
    print(i);
  }
}
```

If the label is needed, then use it:

```dart
void f(int limit) {
  loop: for (int i = 0; i < limit; i++) {
    print(i);
    if (i != 0) {
      break loop;
    }
  }
}
```
