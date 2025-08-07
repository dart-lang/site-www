---
title: avoid_renaming_method_parameters
description: >-
  Details about the avoid_renaming_method_parameters
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_renaming_method_parameters"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The parameter name '{0}' doesn't match the name '{1}' in the overridden
method._

## Description

The analyzer produces this diagnostic when a method that overrides a
method from a superclass changes the names of the parameters.

## Example

The following code produces this diagnostic because the parameter of the
method `m` in `B` is named `b`, which is different from the name of the
overridden method's parameter in `A`:

```dart
class A {
  void m(int a) {}
}

class B extends A {
  @override
  void m(int [!b!]) {}
}
```

## Common fixes

Rename one of the parameters so that they are the same:

```dart
class A {
  void m(int a) {}
}

class B extends A {
  @override
  void m(int a) {}
}
```
