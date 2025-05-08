---
title: unnecessary_nullable_for_final_variable_declarations
description: >-
  Details about the unnecessary_nullable_for_final_variable_declarations
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_nullable_for_final_variable_declarations"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Type could be non-nullable._

## Description

The analyzer produces this diagnostic when a final field or variable has a
nullable type but is initialized to a non-nullable value.

## Example

The following code produces this diagnostic because the final variable `i`
has a nullable type (`int?`), but can never be `null`:

```dart
final int? [!i!] = 1;
```

## Common fixes

Make the type non-nullable:

```dart
final int i = 1;
```
