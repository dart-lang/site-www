---
title: no_adjacent_strings_in_list
description: >-
  Details about the no_adjacent_strings_in_list
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/no_adjacent_strings_in_list"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Don't use adjacent strings in a list literal._

## Description

The analyzer produces this diagnostic when two string literals are
adjacent in a list literal. Adjacent strings in Dart are concatenated
together to form a single string, but the intent might be for each string
to be a separate element in the list.

## Example

The following code produces this diagnostic because the strings `'a'` and
`'b'` are adjacent:

```dart
List<String> list = [[!'a' 'b'!], 'c'];
```

## Common fixes

If the two strings are intended to be separate elements of the list, then
add a comma between them:

```dart
List<String> list = ['a', 'b', 'c'];
```

If the two strings are intended to be a single concatenated string, then
either manually merge the strings:

```dart
List<String> list = ['ab', 'c'];
```

Or use the `+` operator to concatenate the strings:

```dart
List<String> list = ['a' + 'b', 'c'];
```
