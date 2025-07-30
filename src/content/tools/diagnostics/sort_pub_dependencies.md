---
title: sort_pub_dependencies
description: >-
  Details about the sort_pub_dependencies
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/sort_pub_dependencies"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Dependencies not sorted alphabetically._

## Description

The analyzer produces this diagnostic when the keys in a dependency map in
the `pubspec.yaml` file aren't sorted alphabetically. The dependency maps
that are checked are the `dependencies`, `dev_dependencies`, and
`dependency_overrides` maps.

## Example

The following code produces this diagnostic because the entries in the
`dependencies` map are not sorted:

```yaml
dependencies:
  path: any
  collection: any
```

## Common fixes

Sort the entries:

```yaml
dependencies:
  collection: any
  path: any
```
