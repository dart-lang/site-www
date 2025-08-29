---
title: camel_case_types
description: >-
  Details about the camel_case_types
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/camel_case_types"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The type name '{0}' isn't an UpperCamelCase identifier._

## Description

The analyzer produces this diagnostic when the name of a type (a class,
mixin, enum, or typedef) doesn't use the 'UpperCamelCase' naming
convention.

## Example

The following code produces this diagnostic because the name of the class
doesn't start with an uppercase letter:

```dart
class [!c!] {}
```

## Common fixes

Rename the type so that it has a valid name:

```dart
class C {}
```
