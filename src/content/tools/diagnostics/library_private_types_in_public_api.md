---
title: library_private_types_in_public_api
description: >-
  Details about the library_private_types_in_public_api
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/library_private_types_in_public_api"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Invalid use of a private type in a public API._

## Description

The analyzer produces this diagnostic when a type that is not part of the
public API of a library is referenced in the public API of that library.

Using a private type in a public API can make the API unusable outside the
defining library.

## Example

The following code produces this diagnostic because the parameter `c` of
the public function `f` has a type that is library private (`_C`):

```dart
void f([!_C!] c) {}

class _C {}
```

## Common fixes

If the API doesn't need to be used outside the defining library, then make
it private:

```dart
void _f(_C c) {}

class _C {}
```

If the API needs to be part of the public API of the library, then either
use a different type that's public, or make the referenced type public:

```dart
void f(C c) {}

class C {}
```
