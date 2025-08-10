---
title: dependencies_field_not_map
description: >-
  Details about the dependencies_field_not_map
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The value of the '{0}' field is expected to be a map._

## Description

The analyzer produces this diagnostic when the value of either the
`dependencies` or `dev_dependencies` key isn't a map.

## Example

The following code produces this diagnostic because the value of the
top-level `dependencies` key is a list:

```yaml
name: example
dependencies:
  [!- meta!]
```

## Common fixes

Use a map as the value of the `dependencies` key:

```yaml
name: example
dependencies:
  meta: ^1.0.2
```
