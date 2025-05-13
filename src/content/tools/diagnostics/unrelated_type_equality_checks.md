---
title: unrelated_type_equality_checks
description: >-
  Details about the unrelated_type_equality_checks
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unrelated_type_equality_checks"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The type of the operand ('{0}') isn't a subtype or a supertype of the value
being matched ('{1}')._

_The type of the right operand ('{0}') isn't a subtype or a supertype of the
left operand ('{1}')._

## Description

The analyzer produces this diagnostic when two objects are being compared
and neither of the static types of the two objects is a subtype of the
other.

Such a comparison will usually return `false` and might not reflect the
programmer's intent.

There can be false positives. For example, a class named `Point` might
have subclasses named `CartesianPoint` and `PolarPoint`, neither of which
is a subtype of the other, but it might still be appropriate to test the
equality of instances.

As a concrete case, the classes `Int64` and `Int32` from `package:fixnum`
allow comparing instances to an `int` provided the `int` is on the
right-hand side. This case is specifically allowed by the diagnostic, but
other such cases are not.

## Example

The following code produces this diagnostic because the string `s` is
being compared to the integer `1`:

```dart
bool f(String s) {
  return s [!==!] 1;
}
```

## Common fixes

Replace one of the operands with something compatible with the other
operand:

```dart
bool f(String s) {
  return s.length == 1;
}
```
