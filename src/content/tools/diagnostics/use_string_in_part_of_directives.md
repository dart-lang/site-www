---
title: use_string_in_part_of_directives
description: >-
  Details about the use_string_in_part_of_directives
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_string_in_part_of_directives"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The part-of directive uses a library name._

## Description

The analyzer produces this diagnostic when a `part of` directive uses a
library name to refer to the library that the part is a part of.

## Example

Given a file named `lib.dart` that contains the following:

```dart
library lib;

part 'test.dart';
```

The following code produces this diagnostic because the `part of`
directive uses the name of the library rather than the URI of the library
it's part of:

```dart
[!part of lib;!]
```

## Common fixes

Use a URI to reference the library:

```dart
part of 'lib.dart';
```
