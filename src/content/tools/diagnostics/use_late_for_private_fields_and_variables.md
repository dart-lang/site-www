---
title: use_late_for_private_fields_and_variables
description: >-
  Details about the use_late_for_private_fields_and_variables
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_late_for_private_fields_and_variables"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'late' for private members with a non-nullable type._

## Description

The analyzer produces this diagnostic when a private field or variable is
marked as being nullable, but every reference assumes that the variable is
never `null`.

## Example

The following code produces this diagnostic because the private top-level
variable `_i` is nullable, but every reference assumes that it will not be
`null`:

```dart
void f() {
  _i!.abs();
}

int? [!_i!];
```

## Common fixes

Mark the variable or field as being both non-nullable and `late` to
indicate that it will always be assigned a non-null:

```dart
void f() {
  _i.abs();
}

late int _i;
```
