---
title: empty_record_literal_with_comma
description: >-
  Details about the empty_record_literal_with_comma
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_A record literal without fields can't have a trailing comma._

## Description

The analyzer produces this diagnostic when a record literal that has no
fields has a trailing comma. Empty record literals can't contain a comma.

## Example

The following code produces this diagnostic because the empty record
literal has a trailing comma:

```dart
var r = ([!,!]);
```

## Common fixes

If the record is intended to be empty, then remove the comma:

```dart
var r = ();
```

If the record is intended to have one or more fields, then add the
expressions used to compute the values of those fields:

```dart
var r = (3, 4);
```
