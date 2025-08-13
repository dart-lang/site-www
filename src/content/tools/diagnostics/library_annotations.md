---
title: library_annotations
description: >-
  Details about the library_annotations
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/library_annotations"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_This annotation should be attached to a library directive._

## Description

The analyzer produces this diagnostic when an annotation that applies to
a whole library isn't associated with a `library` directive.

## Example

The following code produces this diagnostic because the `TestOn`
annotation, which applies to the whole library, is associated with an
`import` directive rather than a `library` directive:

```dart
[!@TestOn('browser')!]

import 'package:test/test.dart';

void main() {}
```

## Common fixes

Associate the annotation with a `library` directive, adding one if
necessary:

```dart
@TestOn('browser')
library;

import 'package:test/test.dart';

void main() {}
```
