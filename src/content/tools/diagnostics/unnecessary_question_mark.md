---
title: unnecessary_question_mark
description: >-
  Details about the unnecessary_question_mark
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The '?' is unnecessary because '{0}' is nullable without it._

## Description

The analyzer produces this diagnostic when either the type `dynamic` or the
type `Null` is followed by a question mark. Both of these types are
inherently nullable so the question mark doesn't change the semantics.

## Example

The following code produces this diagnostic because the question mark
following `dynamic` isn't necessary:

```dart
dynamic[!?!] x;
```

## Common fixes

Remove the unneeded question mark:

```dart
dynamic x;
```
