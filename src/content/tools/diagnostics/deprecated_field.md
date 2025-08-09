---
title: deprecated_field
description: >-
  Details about the deprecated_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The '{0}' field is no longer used and can be removed._

## Description

The analyzer produces this diagnostic when a key is used in a
`pubspec.yaml` file that was deprecated. Unused keys take up space and
might imply semantics that are no longer valid.

## Example

The following code produces this diagnostic because the `author` key is no
longer being used:

```dart
name: example
author: 'Dash'
```

## Common fixes

Remove the deprecated key:

```dart
name: example
```
