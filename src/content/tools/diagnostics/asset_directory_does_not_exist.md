---
title: asset_directory_does_not_exist
description: >-
  Details about the asset_directory_does_not_exist
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The asset directory '{0}' doesn't exist._

## Description

The analyzer produces this diagnostic when an asset list contains a value
referencing a directory that doesn't exist.

## Example

Assuming that the directory `assets` doesn't exist, the following code
produces this diagnostic because it's listed as a directory containing
assets:

```yaml
name: example
flutter:
  assets:
    - [!assets/!]
```

## Common fixes

If the path is correct, then create a directory at that path.

If the path isn't correct, then change the path to match the path of the
directory containing the assets.
