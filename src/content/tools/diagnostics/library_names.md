---
title: library_names
description: >-
  Details about the library_names
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/library_names"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The library name '{0}' isn't a lower\_case\_with\_underscores identifier._

## Description

The analyzer produces this diagnostic when the name of a library doesn't
use the lower_case_with_underscores naming convention.

## Example

The following code produces this diagnostic because the library name
`libraryName` isn't a lower_case_with_underscores identifier:

```dart
library [!libraryName!];
```

## Common fixes

If the library name is not required, then remove the library name:

```dart
library;
```

If the library name is required, then convert it to use the
lower_case_with_underscores naming convention:

```dart
library library_name;
```
