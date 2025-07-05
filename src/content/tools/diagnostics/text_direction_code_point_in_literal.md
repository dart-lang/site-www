---
title: text_direction_code_point_in_literal
description: >-
  Details about the text_direction_code_point_in_literal
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The Unicode code point 'U+{0}' changes the appearance of text from how it's
interpreted by the compiler._

## Description

The analyzer produces this diagnostic when it encounters source that
contains text direction Unicode code points. These code points cause
source code in either a string literal or a comment to be interpreted
and compiled differently than how it appears in editors, leading to
possible security vulnerabilities.

## Example

The following code produces this diagnostic twice because there are
hidden characters at the start and end of the label string:

```dart
var label = '[!I!]nteractive text[!'!];
```

## Common fixes

If the code points are intended to be included in the string literal,
then escape them:

```dart
var label = '\u202AInteractive text\u202C';
```

If the code points aren't intended to be included in the string literal,
then remove them:

```dart
var label = 'Interactive text';
```
