---
title: unused_catch_clause
description: >-
  Details about the unused_catch_clause
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The exception variable '{0}' isn't used, so the 'catch' clause can be removed._

## Description

The analyzer produces this diagnostic when a `catch` clause is found, and
neither the exception parameter nor the optional stack trace parameter are
used in the `catch` block.

## Example

The following code produces this diagnostic because `e` isn't referenced:

```dart
void f() {
  try {
    int.parse(';');
  } on FormatException catch ([!e!]) {
    // ignored
  }
}
```

## Common fixes

Remove the unused `catch` clause:

```dart
void f() {
  try {
    int.parse(';');
  } on FormatException {
    // ignored
  }
}
```
