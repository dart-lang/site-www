---
title: unnecessary_type_check
description: >-
  Details about the unnecessary_type_check
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Unnecessary type check; the result is always 'false'._

_Unnecessary type check; the result is always 'true'._

## Description

The analyzer produces this diagnostic when the value of a type check (using
either `is` or `is!`) is known at compile time.

## Example

The following code produces this diagnostic because the test `a is Object?`
is always `true`:

```dart
bool f<T>(T a) => [!a is Object?!];
```

## Common fixes

If the type check doesn't check what you intended to check, then change the
test:

```dart
bool f<T>(T a) => a is Object;
```

If the type check does check what you intended to check, then replace the
type check with its known value or completely remove it:

```dart
bool f<T>(T a) => true;
```
