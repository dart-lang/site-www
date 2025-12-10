---
title: incompatible_lint
description: >-
  Details about the incompatible_lint
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The rule '{0}' is incompatible with '{1}'._

_The rule '{0}' is incompatible with {1}, which is included from {2} file{3}._

_The rule '{0}' is incompatible with {1}._

## Description

The analyzer produces this diagnostic when two specified lint rules are
incompatible, such as when they enforce opposite styles.

## Example

The following code produces this diagnostic because the rules
`prefer_single_quotes` and `prefer_double_quotes` are incompatible with
each other:

```yaml
// %uri="analysis_options.yaml"
linter:
  rules:
    - prefer_single_quotes
    - [!prefer_double_quotes!]
```

## Common fixes

Remove all but one of the incompatible rules:

```yaml
// %uri="analysis_options.yaml"
linter:
  rules:
    - prefer_single_quotes
```
