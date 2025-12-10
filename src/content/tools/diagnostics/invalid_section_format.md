---
title: invalid_section_format
description: >-
  Details about the invalid_section_format
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Invalid format for the '{0}' section._

## Description

The analyzer produces this diagnostic when an analysis options file
contains a configuration section (key) whose content is not in the
expected data structure or format. For example, this occurs when the
configuration requires a map but is provided a list.

## Example

The following code produces this diagnostic because the `errors` section
expects to have a map as its value:

```yaml
// %uri="analysis_options.yaml"
analyzer:
  errors:
    - dead_code
```

## Common fixes

Change the value to be of the appropriate format:

```yaml
// %uri="analysis_options.yaml"
analyzer:
  errors:
    dead_code: error
```
