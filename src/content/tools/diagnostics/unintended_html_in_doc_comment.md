---
title: unintended_html_in_doc_comment
description: >-
  Details about the unintended_html_in_doc_comment
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unintended_html_in_doc_comment"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Angle brackets will be interpreted as HTML._

## Description

The analyzer produces this diagnostic when a documentation comment
contains angle bracketed text (`<...>`) that isn't one of the allowed
exceptions.

Such text is interpreted by markdown to be an HTML tag, which is rarely
what was intended.

See the [lint rule description](https://dart.dev/tools/linter-rules/unintended_html_in_doc_comment)
for the list of allowed exceptions.

## Example

The following code produces this diagnostic because the documentation
comment contains the text `<int>`, which isn't one of the allowed
exceptions:

```dart
/// Converts a List[!<int>!] to a comma-separated String.
String f(List<int> l) => '';
```

## Common fixes

If the text was intended to be part of a code span, then add backticks
around the code:

```dart
/// Converts a `List<int>` to a comma-separated String.
String f(List<int> l) => '';
```

If the text was intended to be part of a link, then add square brackets
around the code:

```dart
/// Converts a [List<int>] to a comma-separated String.
String f(List<int> l) => '';
```

If the text was intended to be printed as-is, including the angle
brackets, then add backslash escapes before the angle brackets:

```dart
/// Converts a List\<int\> to a comma-separated String.
String f(List<int> l) => '';
```
