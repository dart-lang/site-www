---
title: path_not_posix
description: >-
  Details about the path_not_posix
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The path '{0}' isn't a POSIX-style path._

## Description

The analyzer produces this diagnostic when a dependency has a `path` key
whose value is a string, but isn't a POSIX-style path.

## Example

The following code produces this diagnostic because the path following the
`path` key is a Windows path:

```yaml
name: example
dependencies:
  local_package:
    path: [!E:\local_package!]
```

## Common fixes

Convert the path to a POSIX path.
