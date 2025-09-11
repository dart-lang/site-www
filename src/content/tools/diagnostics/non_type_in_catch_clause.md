---
title: non_type_in_catch_clause
description: >-
  Details about the non_type_in_catch_clause
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The name '{0}' isn't a type and can't be used in an on-catch clause._

## Description

The analyzer produces this diagnostic when the identifier following the
`on` in a `catch` clause is defined to be something other than a type.

## Example

The following code produces this diagnostic because `f` is a function, not
a type:

```dart
void f() {
  try {
    // ...
  } on [!f!] {
    // ...
  }
}
```

## Common fixes

Change the name to the type of object that should be caught:

```dart
void f() {
  try {
    // ...
  } on FormatException {
    // ...
  }
}
```
