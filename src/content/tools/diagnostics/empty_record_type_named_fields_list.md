---
title: empty_record_type_named_fields_list
description: >-
  Details about the empty_record_type_named_fields_list
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The list of named fields in a record type can't be empty._

## Description

The analyzer produces this diagnostic when a record type has an empty list
of named fields.

## Example

The following code produces this diagnostic because the record type has an
empty list of named fields:

```dart
void f((int, int, {[!}!]) r) {}
```

## Common fixes

If the record is intended to have named fields, then add the types and
names of the fields:

```dart
void f((int, int, {int z}) r) {}
```

If the record isn't intended to have named fields, then remove the curly
braces:

```dart
void f((int, int) r) {}
```
