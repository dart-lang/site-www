---
title: name_not_string
description: >-
  Details about the name_not_string
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The value of the 'name' field is required to be a string._

## Description

The analyzer produces this diagnostic when the top-level `name` key has a
value that isn't a string.

## Example

The following code produces this diagnostic because the value following the
`name` key is a list:

```yaml
name:
  [!- example!]
```

## Common fixes

Replace the value with a string:

```yaml
name: example
```
