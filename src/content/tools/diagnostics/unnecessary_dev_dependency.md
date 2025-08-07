---
title: unnecessary_dev_dependency
description: >-
  Details about the unnecessary_dev_dependency
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The dev dependency on {0} is unnecessary because there is also a normal
dependency on that package._

## Description

The analyzer produces this diagnostic when there's an entry under
`dev_dependencies` for a package that is also listed under `dependencies`.
The packages under `dependencies` are available to all of the code in the
package, so there's no need to also list them under `dev_dependencies`.

## Example

The following code produces this diagnostic because the package `meta` is
listed under both `dependencies` and `dev_dependencies`:

```yaml
name: example
dependencies:
  meta: ^1.0.2
dev_dependencies:
  [!meta!]: ^1.0.2
```

## Common fixes

Remove the entry under `dev_dependencies` (and the `dev_dependencies` key
if that's the only package listed there):

```yaml
name: example
dependencies:
  meta: ^1.0.2
```
