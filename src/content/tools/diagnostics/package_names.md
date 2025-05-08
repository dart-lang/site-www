---
title: package_names
description: >-
  Details about the package_names
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/package_names"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The package name '{0}' isn't a lower\_case\_with\_underscores identifier._

## Description

The analyzer produces this diagnostic when the name of a package doesn't
use the lower_case_with_underscores naming convention.

## Example

The following code produces this diagnostic because the name of the
package uses the lowerCamelCase naming convention:

```yaml
name: [!somePackage!]
```

## Common fixes

Rewrite the name of the package using the lower_case_with_underscores
naming convention:

```yaml
name: some_package
```
