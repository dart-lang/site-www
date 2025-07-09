---
title: unknown_platform
description: >-
  Details about the unknown_platform
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The platform '{0}' is not a recognized platform._

## Description

The analyzer produces this diagnostic when an unknown platform name is
used as a key in the `platforms` map.
To learn more about specifying your package's supported platforms,
check out the [documentation on platform declarations](https://dart.dev/tools/pub/pubspec#platforms).

## Example

The following `pubspec.yaml` produces this diagnostic because the platform
`browser` is unknown.

```yaml
name: example
platforms:
  [!browser:!]
```

## Common fixes

If you can rely on automatic platform detection, then omit the
top-level `platforms` key.

```yaml
name: example
```

If you need to manually specify the list of supported platforms, then
write the `platforms` field as a map with known platform names as keys.

```yaml
name: example
platforms:
  # These are the known platforms
  android:
  ios:
  linux:
  macos:
  web:
  windows:
```
