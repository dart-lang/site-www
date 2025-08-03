---
title: nullable_type_in_catch_clause
description: >-
  Details about the nullable_type_in_catch_clause
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_A potentially nullable type can't be used in an 'on' clause because it isn't
valid to throw a nullable expression._

## Description

The analyzer produces this diagnostic when the type following `on` in a
`catch` clause is a nullable type. It isn't valid to specify a nullable
type because it isn't possible to catch `null` (because it's a runtime
error to throw `null`).

## Example

The following code produces this diagnostic because the exception type is
specified to allow `null` when `null` can't be thrown:

```dart
void f() {
  try {
    // ...
  } on [!FormatException?!] {
  }
}
```

## Common fixes

Remove the question mark from the type:

```dart
void f() {
  try {
    // ...
  } on FormatException {
  }
}
```
