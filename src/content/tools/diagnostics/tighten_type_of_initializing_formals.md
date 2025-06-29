---
title: tighten_type_of_initializing_formals
description: >-
  Details about the tighten_type_of_initializing_formals
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/tighten_type_of_initializing_formals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use a type annotation rather than 'assert' to enforce non-nullability._

## Description

The analyzer produces this diagnostic when an `assert` is being used in
the initializer list of a constructor to ensure that only a non-`null`
value is being used to initialize a field.

## Example

The following code produces this diagnostic because an `assert` is being
used to catch an error that could be caught by the type system:

```dart
class C {
  final String? s;

  C([!this.s!]) : assert(s != null);
}
```

## Common fixes

Remove the `assert` and add the non-nullable type before the initializing
formal:

```dart
class C {
  final String? s;

  C(String this.s);
}
```
