---
title: workspace_field_not_list
description: >-
  Details about the workspace_field_not_list
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The value of the 'workspace' field is required to be a list of relative file
paths._

## Description

The analyzer produces this diagnostic when the value of the `workspace` key
isn't a list.

## Example

The following code produces this diagnostic because the value of the
`workspace` key is a string when a list is expected:

```yaml
name: example
workspace: [!notPaths!]
```

## Common fixes

Change the value of the workspace field so that it's a list:

```yaml
name: example
workspace:
    - pkg/package_1
    - pkg/package_2
```
