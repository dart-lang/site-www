---
title: positional_field_in_object_pattern
description: >-
  Details about the positional_field_in_object_pattern
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Object patterns can only use named fields._

## Description

The analyzer produces this diagnostic when an object pattern contains a
field without specifying the getter name. Object pattern fields match
against values that the object's getters return. Without a getter name
specified, the pattern field can't access a value to attempt to match against.

## Example

The following code produces this diagnostic because the object pattern
`String(1)` doesn't specify which getter of `String` to access and compare
with the value `1`:

```dart
void f(Object o) {
  if (o case String([!1!])) {}
}
```

## Common fixes

Add the getter name to access the value, followed
by a colon before the pattern to match against:

```dart
void f(Object o) {
  if (o case String(length: 1)) {}
}
```
