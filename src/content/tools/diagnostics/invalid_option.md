---
title: invalid_option
description: >-
  Details about the invalid_option
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Invalid option specified for '{0}': {1}_

## Description

The analyzer produces this diagnostic when an option is specified and the
value of the option is invalid.

## Example

The following code produces this diagnostic because `fail` isn't a valid
severity for a diagnostic:

```yaml
// %uri="analysis_options.yaml"
analyzer:
  errors:
    dead_code: [!fail!]
    prefer_single_quotes: warning
```

## Common fixes

If you specify the option, provide a valid value for it:

```yaml
// %uri="analysis_options.yaml"
analyzer:
  errors:
    dead_code: error
    prefer_single_quotes: warning
```

If you don't need the option, remove it:

```yaml
// %uri="analysis_options.yaml"
analyzer:
  errors:
    prefer_single_quotes: warning
```
