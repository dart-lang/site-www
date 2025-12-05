---
title: included_file_warning
description: >-
  Details about the included_file_warning
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Warning in the included options file {0}({1}..{2}): {3}_

## Description

The analyzer produces this diagnostic when an analysis options file
contains an `include` key, and the included file contains a warning.

## Example

Given a file named `shared.yaml` that contains:

```yaml
// %uri="shared.yaml"
linter:
  rules:
    - undefined_lint_rule
```

The following code produces this diagnostic because the file `shared.yaml`
has a warning that the rule `undefined_lint_rule` doesn't exist:

```yaml
// %uri="analysis_options.yaml"
include: [!shared.yaml!]
```

## Common fixes

If the included file can be fixed, then fix the warning in it.

If the included file can't be fixed, then don't include it.
