---
title: missing_name
description: >-
  Details about the missing_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The 'name' field is required but missing._

## Description

The analyzer produces this diagnostic when there's no top-level `name` key.
The `name` key provides the name of the package, which is required.

## Example

The following code produces this diagnostic because the package doesn't
have a name:

```yaml
dependencies:
  meta: ^1.0.2
```

## Common fixes

Add the top-level key `name` with a value that's the name of the package:

```yaml
name: example
dependencies:
  meta: ^1.0.2
```
