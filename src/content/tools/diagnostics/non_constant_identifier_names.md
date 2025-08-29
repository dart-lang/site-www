---
title: non_constant_identifier_names
description: >-
  Details about the non_constant_identifier_names
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/non_constant_identifier_names"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The variable name '{0}' isn't a lowerCamelCase identifier._

## Description

The analyzer produces this diagnostic when the name of a class member,
top-level declaration, variable, parameter, named parameter, or named
constructor that isn't declared to be `const`, doesn't use the
lowerCamelCase convention.

## Example

The following code produces this diagnostic because the top-level variable
`Count` doesn't start with a lowercase letter:

```dart
var [!Count!] = 0;
```

## Common fixes

Change the name in the declaration to follow the lowerCamelCase
convention:

```dart
var count = 0;
```
