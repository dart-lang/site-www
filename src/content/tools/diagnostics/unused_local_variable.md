---
title: unused_local_variable
description: >-
  Details about the unused_local_variable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The value of the local variable '{0}' isn't used._

## Description

The analyzer produces this diagnostic when a local variable is declared but
never read, even if it's written in one or more places.

## Example

The following code produces this diagnostic because the value of `count` is
never read:

```dart
void main() {
  int [!count!] = 0;
}
```

## Common fixes

If the variable isn't needed, then remove it.

If the variable was intended to be used, then add the missing code.
