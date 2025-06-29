---
title: workspace_value_not_string
description: >-
  Details about the workspace_value_not_string
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Workspace entries are required to be directory paths (strings)._

## Description

The analyzer produces this diagnostic when a `workspace` list contains a
value that isn't a string.

## Example

The following code produces this diagnostic because the `workspace` list
contains a map:

```yaml
name: example
workspace:
    - [!image.gif: true!]
```

## Common fixes

Change the `workspace` list so that it only contains valid POSIX-style directory
paths:

```yaml
name: example
workspace:
    - pkg/package_1
    - pkg/package_2
```
