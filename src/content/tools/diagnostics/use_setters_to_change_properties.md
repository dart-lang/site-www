---
title: use_setters_to_change_properties
description: >-
  Details about the use_setters_to_change_properties
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_setters_to_change_properties"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The method is used to change a property._

## Description

The analyzer produces this diagnostic when a method is used to set the
value of a field, or a function is used to set the value of a top-level
variable, and nothing else.

## Example

The following code produces this diagnostic because the method `setF` is
used to set the value of the field `_f` and does no other work:

```dart
class C {
  int _f = 0;

  void [!setF!](int value) => _f = value;
}
```

## Common fixes

Convert the method to a setter:

```dart
class C {
  int _f = 0;

  set f(int value) => _f = value;
}
```
