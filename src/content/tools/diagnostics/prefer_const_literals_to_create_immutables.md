---
title: prefer_const_literals_to_create_immutables
description: >-
  Details about the prefer_const_literals_to_create_immutables
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_const_literals_to_create_immutables"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'const' literals as arguments to constructors of '@immutable' classes._

## Description

The analyzer produces this diagnostic when a non-const list, map, or set
literal is passed as an argument to a constructor declared in a class
annotated with `@immutable`.

## Example

The following code produces this diagnostic because the list literal
(`[1]`) is being passed to a constructor in an immutable class but isn't
a constant list:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}

C c = C([![1]!]);
```

## Common fixes

If the context can be made a [constant context][], then do so:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}

const C c = C([1]);
```

If the context can't be made a [constant context][] but the constructor
can be invoked using `const`, then add `const` before the constructor
invocation:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}

C c = const C([1]);
```

If the context can't be made a [constant context][] and the constructor
can't be invoked using `const`, then add the keyword `const` before the
collection literal:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}

C c = C(const [1]);
```

[constant context]: /resources/glossary#constant-context
