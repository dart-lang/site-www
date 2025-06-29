---
title: prefer_final_parameters
description: >-
  Details about the prefer_final_parameters
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_final_parameters"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The parameter '{0}' should be final._

## Description

The analyzer produces this diagnostic when a parameter of a constructor,
method, function, or closure isn't marked as being `final`.

## Example

The following code produces this diagnostic because the parameter `s`
isn't a `final` parameter:

```dart
String f([!String s!]) => s;
```

## Common fixes

Add the modifier `final` to the parameter:

```dart
String f(final String s) => s;
```
