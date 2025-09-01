---
title: asset_field_not_list
description: >-
  Details about the asset_field_not_list
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The value of the 'assets' field is expected to be a list of relative file
paths._

## Description

The analyzer produces this diagnostic when the value of the `assets` key
isn't a list.

## Example

The following code produces this diagnostic because the value of the
`assets` key is a string when a list is expected:

```yaml
name: example
flutter:
  assets: [!assets/!]
```

## Common fixes

Change the value of the asset list so that it's a list:

```yaml
name: example
flutter:
  assets:
    - assets/
```
