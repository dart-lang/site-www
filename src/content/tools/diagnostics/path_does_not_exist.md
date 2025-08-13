---
title: path_does_not_exist
description: >-
  Details about the path_does_not_exist
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The path '{0}' doesn't exist._

## Description

The analyzer produces this diagnostic when a dependency has a `path` key
referencing a directory that doesn't exist.

## Example

Assuming that the directory `doesNotExist` doesn't exist, the following
code produces this diagnostic because it's listed as the path of a package:

```yaml
name: example
dependencies:
  local_package:
    path: [!doesNotExist!]
```

## Common fixes

If the path is correct, then create a directory at that path.

If the path isn't correct, then change the path to match the path to the
root of the package.
