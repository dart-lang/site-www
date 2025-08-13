---
title: platform_value_disallowed
description: >-
  Details about the platform_value_disallowed
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Keys in the `platforms` field can't have values._

## Description

The analyzer produces this diagnostic when a key in the `platforms` map
has a value.
To learn more about specifying your package's supported platforms,
check out the [documentation on platform declarations](https://dart.dev/tools/pub/pubspec#platforms).

## Example

The following `pubspec.yaml` produces this diagnostic because the key
`web` has a value.

```yaml
name: example
platforms:
  web: [!"chrome"!]
```

## Common fixes

Omit the value and leave the key without a value:

```yaml
name: example
platforms:
  web:
```

Values for keys in the `platforms` field are currently reserved for
potential future behavior.
