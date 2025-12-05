---
title: duplicate_rule
description: >-
  Details about the duplicate_rule
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The rule '{0}' is already enabled and doesn't need to be enabled again._

## Description

The analyzer produces this diagnostic when the same lint rule is listed
more than once in the linter/rules section.

## Example

The following code produces this diagnostic because the lint rule
`avoid_print` appears twice in the list of enabled rules:

```yaml
// %uri="analysis_options.yaml"
linter:
  rules:
    - avoid_print
    - [!avoid_print!]
```

## Common fixes

Remove the duplicates:

```yaml
// %uri="analysis_options.yaml"
linter:
  rules:
    - avoid_print
```
