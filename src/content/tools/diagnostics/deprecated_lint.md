---
title: deprecated_lint
description: >-
  Details about the deprecated_lint
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The lint rule '{0}' is deprecated and shouldn't be enabled._

## Description

The analyzer produces this diagnostic when an enabled lint rule is
deprecated.

## Example

The following code produces this diagnostic because the rule
`always_specify_types` is deprecated:

```yaml
// %uri="analysis_options.yaml"
linter:
  rules:
    - [!always_specify_types!]
    - annotate_overrides
```

## Common fixes

If a replacement rule exists, enable it:

```yaml
// %uri="analysis_options.yaml"
linter:
  rules:
    - annotate_overrides
    - specify_nonobvious_property_types
```

If no replacement rule exists, remove the deprecated lint rule from the
list:

```yaml
// %uri="analysis_options.yaml"
linter:
  rules:
    - annotate_overrides
```
