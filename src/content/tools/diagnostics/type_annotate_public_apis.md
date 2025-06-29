---
title: type_annotate_public_apis
description: >-
  Details about the type_annotate_public_apis
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/type_annotate_public_apis"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Missing type annotation on a public API._

## Description

The analyzer produces this diagnostic when the declaration of part of the
public API of a package doesn't have explicit type annotations.

## Example

The following code produces this diagnostic because the function `f`
doesn't have an explicit return type and the parameters `x` and `y` don't
have explicit types:

```dart
[!f!](x, y) => '';
```

## Common fixes

Add type annotations to the API:

```dart
String f(int x, int y) => '';
```
