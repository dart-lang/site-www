---
title: dangling_library_doc_comments
description: >-
  Details about the dangling_library_doc_comments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/dangling_library_doc_comments"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Dangling library doc comment._

## Description

The analyzer produces this diagnostic when a documentation comment that
appears to be library documentation isn't followed by a `library`
directive. More specifically, it is produced when a documentation comment
appears before the first directive in the library, assuming that it isn't
a `library` directive, or before the first top-level declaration and is
separated from the declaration by one or more blank lines.

## Example

The following code produces this diagnostic because there's a
documentation comment before the first `import` directive:

```dart
[!/// This is a great library.!]
import 'dart:core';
```

The following code produces this diagnostic because there's a
documentation comment before the first class declaration, but there's a
blank line between the comment and the declaration.

```dart
[!/// This is a great library.!]

class C {}
```

## Common fixes

If the comment is library documentation, then add a `library` directive
without a name:

```dart
/// This is a great library.
library;

import 'dart:core';
```

If the comment is documentation for the following declaration, then remove
the blank line:

```dart
/// This is a great library.
class C {}
```
