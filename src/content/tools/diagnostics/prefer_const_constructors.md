---
title: prefer_const_constructors
description: >-
  Details about the prefer_const_constructors
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_const_constructors"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'const' with the constructor to improve performance._

## Description

The analyzer produces this diagnostic when an invocation of a const
constructor isn't either preceded by `const` or in a [constant context][].

## Example

The following code produces this diagnostic because the invocation of the
`const` constructor is neither prefixed by `const` nor in a
[constant context][]:

```dart
class C {
  const C();
}

C c = [!C()!];
```

## Common fixes

If the context can be made a [constant context][], then do so:

```dart
class C {
  const C();
}

const C c = C();
```

If the context can't be made a [constant context][], then add `const`
before the constructor invocation:

```dart
class C {
  const C();
}

C c = const C();
```

[constant context]: /resources/glossary#constant-context
