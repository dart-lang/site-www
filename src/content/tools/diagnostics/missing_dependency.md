---
title: missing_dependency
description: >-
  Details about the missing_dependency
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Missing a dependency on imported package '{0}'._

## Description

The analyzer produces this diagnostic when there's a package that has been
imported in the source but is not listed as a dependency of the
importing package.

## Example

The following code produces this diagnostic because the package `path` is
not listed as a dependency, while there is an import statement
with package `path` in the source code of package `example`:

```yaml
name: example
dependencies:
  meta: ^1.0.2
```

## Common fixes

Add the missing package `path` to the `dependencies` field:

```yaml
name: example
dependencies:
  meta: ^1.0.2
  path: any
```
