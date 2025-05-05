---
title: asset_missing_path
description: >-
  Details about the asset_missing_path
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Asset map entry must contain a 'path' field._

## Description

The analyzer produces this diagnostic when an asset map is missing a
`path` value.

## Example

The following code produces this diagnostic because the asset map
is missing a `path` value:

```yaml
name: example
flutter:
  assets:
    - flavors:
      - premium
```

## Common fixes

Change the asset map so that it contains a `path` field with a string
value (a valid POSIX-style file path):

```yaml
name: example
flutter:
  assets:
    - path: assets/image.gif
      flavors:
      - premium
```
