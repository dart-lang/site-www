---
title: workspace_value_not_subdirectory
description: >-
  Details about the workspace_value_not_subdirectory
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Workspace values must be a relative path of a subdirectory of '{0}'._

## Description

The analyzer produces this diagnostic when a `workspace` list contains a
value that is not a subdirectory of the directory containing the `pubspec.yaml`` file.

## Example

The following code produces this diagnostic because the value in the `workspace` list is not a
relative path of a subdirectory of the directory containing the 'pubspec.yaml' file:

```yaml
name: example
workspace:
    - /home/my_package
```

## Common fixes

Change the `workspace` list so that it only contains only subdirectory paths.

```yaml
name: example
workspace:
    - pkg/package_1
    - pkg/package_2
```
