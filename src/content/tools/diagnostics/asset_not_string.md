---
title: asset_not_string
description: >-
  Details about the asset_not_string
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Assets are required to be file paths (strings)._

## Description

The analyzer produces this diagnostic when an `assets` list contains a
value that isn't a string.

## Example

The following code produces this diagnostic because the `assets` list
contains a map:

```yaml
name: example
flutter:
  assets:
    - [!image.gif: true!]
```

## Common fixes

Change the `assets` list so that it only contains valid POSIX-style file
paths:

```yaml
name: example
flutter:
  assets:
    - assets/image.gif
```
