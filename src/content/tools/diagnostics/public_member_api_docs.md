---
title: public_member_api_docs
description: >-
  Details about the public_member_api_docs
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/public_member_api_docs"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Missing documentation for a public member._

## Description

The analyzer produces this diagnostic when the declaration of part of the
public API of a package doesn't have a documentation comment.

## Example

The following code produces this diagnostic because the class `C` doesn't
have a documentation comment:

```dart
class [!C!] {}
```

## Common fixes

Add a documentation comment.

```dart
/// Documentation comment.
class C {}
```
