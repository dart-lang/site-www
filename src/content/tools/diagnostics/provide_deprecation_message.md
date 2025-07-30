---
title: provide_deprecation_message
description: >-
  Details about the provide_deprecation_message
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/provide_deprecation_message"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Missing a deprecation message._

## Description

The analyzer produces this diagnostic when a `deprecated` annotation is
used instead of the `Deprecated` annotation.

## Example

The following code produces this diagnostic because the function `f` is
annotated with `deprecated`:

```dart
[!@deprecated!]
void f() {}
```

## Common fixes

Convert the code to use the longer form:

```dart
@Deprecated('Use g instead. Will be removed in 4.0.0.')
void f() {}
```
