---
title: avoid_types_as_parameter_names
description: >-
  Details about the avoid_types_as_parameter_names
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_types_as_parameter_names"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The parameter name '{0}' matches a visible type name._
_The type parameter name '{0}' matches a visible type name._

## Description

The analyzer produces this diagnostic when the name of a parameter in a
parameter list is the same as a visible type (a type whose name is in
scope).

This often indicates that the intended name of the parameter is missing,
causing the name of the type to be used as the name of the parameter
rather than the type of the parameter. Even when that's not the case (the
name of the parameter is intentional), the name of the parameter will
shadow the existing type, which can lead to bugs that are difficult to
diagnose.

The analyzer also produces this diagnostic when the name of a type
parameter in a type parameter list is the same as a type whose name is
in scope. It is again recommended that the type parameter is renamed
such that the error-prone shadowing is avoided.

## Example

The following code produces this diagnostic because the function `f` has a
parameter named `int`, which shadows the type `int` from `dart:core`:

```dart
void f([!int!]) {}
```

## Common fixes

If the parameter name is missing, then add a name for the parameter:

```dart
void f(int x) {}
```

If the parameter is intended to have an implicit type of `dynamic`, then
rename the parameter so that it doesn't shadow the name of any visible type:

```dart
void f(int_) {}
```
