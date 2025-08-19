---
title: removed_lint_use
description: >-
  Details about the removed_lint_use
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' was removed in Dart '{1}'_

## Description

The analyzer produces this diagnostic when a lint that has been removed is
used in an analysis options file. Because the lint has been removed, the
reference to it (such as enabling it) will have no effect.

## Example

Assuming that the lint `removed_lint` has been removed, the following
options file produces this diagnostic:

```yaml
linter:
  rules:
  - always_put_required_named_parameters_first
  - [!removed_lint!]
```

## Common fixes

Remove the reference to the lint code:

```yaml
linter:
  rules:
  - always_put_required_named_parameters_first
```
