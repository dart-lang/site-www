---
title: unsupported_value
description: >-
  Details about the unsupported_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The value '{0}' isn't supported by '{1}'._

## Description

The analyzer produces this diagnostic when an analysis options file
contains a valid option and the value of that option is not a valid value.

## Example

The following code produces this diagnostic because `fatal` isn't a valid
severity:

```yaml
// %uri="analysis_options.yaml"
analyzer:
  errors:
    dead_code: [!fatal!]
```

## Common fixes

If a valid value specifies the intended behavior, then replace the
unsupported value with it:

```yaml
// %uri="analysis_options.yaml"
analyzer:
  errors:
    dead_code: error
```

If there is no valid value to use, then remove the option:

```yaml
// %uri="analysis_options.yaml"
analyzer:
  errors:
```
