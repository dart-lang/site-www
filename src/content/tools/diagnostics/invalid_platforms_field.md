---
title: invalid_platforms_field
description: >-
  Details about the invalid_platforms_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The 'platforms' field must be a map with platforms as keys._

## Description

The analyzer produces this diagnostic when a top-level `platforms`
field is specified, but its value is not a map with keys.
To learn more about specifying your package's supported platforms,
check out the [documentation on platform declarations](https://dart.dev/tools/pub/pubspec#platforms).

## Example

The following `pubspec.yaml` produces this diagnostic because `platforms`
should be a map.

```yaml
name: example
platforms:
  [!- android!]
  [!- web!]
  [!- ios!]
```

## Common fixes

If you can rely on automatic platform detection, then omit the
top-level `platforms` field.

```yaml
name: example
```

If you need to manually specify the list of supported platforms, then
write the `platforms` field as a map with platform names as keys.

```yaml
name: example
platforms:
  android:
  web:
  ios:
```
