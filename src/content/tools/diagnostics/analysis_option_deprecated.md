---
title: analysis_option_deprecated
description: >-
  Details about the analysis_option_deprecated
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The option '{0}' is no longer supported._

## Description

The analyzer produces this diagnostic when an option in an analysis
options file is deprecated.

## Example

The following code produces this diagnostic because the top-level key
`errors` is deprecated:

```yaml
// %uri="analysis_options.yaml"
[!errors!]:
  dead_code: ignore
```

## Common fixes

If a replacement option or format exists, update the file to use it:

```yaml
// %uri="analysis_options.yaml"
analyzer:
  errors:
    dead_code: ignore
```

If no replacement is available, remove the deprecated option.
