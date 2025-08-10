---
title: duplicate_ignore
description: >-
  Details about the duplicate_ignore
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The diagnostic '{0}' doesn't need to be ignored here because it's already being
ignored._

## Description

The analyzer produces this diagnostic when a diagnostic name appears in an
`ignore` comment, but the diagnostic is already being ignored, either
because it's already included in the same `ignore` comment or because it
appears in an `ignore-in-file` comment.

## Examples

The following code produces this diagnostic because the diagnostic named
`unused_local_variable` is already being ignored for the whole file so it
doesn't need to be ignored on a specific line:

```dart
// ignore_for_file: unused_local_variable
void f() {
  // ignore: [!unused_local_variable!]
  var x = 0;
}
```

The following code produces this diagnostic because the diagnostic named
`unused_local_variable` is being ignored twice on the same line:

```dart
void f() {
  // ignore: unused_local_variable, [!unused_local_variable!]
  var x = 0;
}
```

## Common fixes

Remove the ignore comment, or remove the unnecessary diagnostic name if the
ignore comment is ignoring more than one diagnostic:

```dart
// ignore_for_file: unused_local_variable
void f() {
  var x = 0;
}
```
