---
title: built_in_identifier_as_type
description: >-
  Details about the built_in_identifier_as_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The built-in identifier '{0}' can't be used as a type._

## Description

The analyzer produces this diagnostic when a built-in identifier is used
where a type name is expected.

## Example

The following code produces this diagnostic because `import` can't be used
as a type because it's a built-in identifier:

```dart
[!import!]<int> x;
```

## Common fixes

Replace the built-in identifier with the name of a valid type:

```dart
List<int> x;
```
