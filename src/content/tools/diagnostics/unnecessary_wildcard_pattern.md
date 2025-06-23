---
title: unnecessary_wildcard_pattern
description: >-
  Details about the unnecessary_wildcard_pattern
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Unnecessary wildcard pattern._

## Description

The analyzer produces this diagnostic when a wildcard pattern is used in
either an and (`&&`) pattern or an or (`||`) pattern.

## Example

The following code produces this diagnostic because the wildcard pattern
(`_`) will always succeed, making it's use in an and pattern unnecessary:

```dart
void f(Object? x) {
  if (x case [!_!] && 0) {}
}
```

## Common fixes

Remove the use of the wildcard pattern:

```dart
void f(Object? x) {
  if (x case 0) {}
}
```
