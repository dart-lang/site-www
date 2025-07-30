---
title: asset_does_not_exist
description: >-
  Details about the asset_does_not_exist
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The asset file '{0}' doesn't exist._

## Description

The analyzer produces this diagnostic when an asset list contains a value
referencing a file that doesn't exist.

## Example

Assuming that the file `doesNotExist.gif` doesn't exist, the following code
produces this diagnostic because it's listed as an asset:

```yaml
name: example
flutter:
  assets:
    - [!doesNotExist.gif!]
```

## Common fixes

If the path is correct, then create a file at that path.

If the path isn't correct, then change the path to match the path of the
file containing the asset.
