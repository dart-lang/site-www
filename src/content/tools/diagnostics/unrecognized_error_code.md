---
title: unrecognized_error_code
description: >-
  Details about the unrecognized_error_code
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' isn't a recognized diagnostic code._

## Description

The analyzer produces this diagnostic when the analyzer/errors section in
an analysis options file contains a diagnostic code that is not valid.

## Example

The following code produces this diagnostic because the diagnostic
`implementation_import` isn't defined:

```yaml
// %uri="analysis_options.yaml"
analyzer:
  errors:
    annotate_overrides: error
    [!implementation_import!]: warning
```

## Common fixes

If the diagnostic being specified has a different name, then replace the
name:

```yaml
// %uri="analysis_options.yaml"
analyzer:
  errors:
    annotate_overrides: error
    implementation_imports: warning
```

If there is no diagnostic, then remove the name:

```yaml
// %uri="analysis_options.yaml"
analyzer:
  errors:
    annotate_overrides: error
```
