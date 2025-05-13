---
title: avoid_futureor_void
description: >-
  Details about the avoid_futureor_void
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_futureor_void"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Don't use the type 'FutureOr<void>'._

## Description

The analyzer produces this diagnostic when the type `FutureOr<void>`
is used as the type of a result (to be precise: it is used in a
position that isn't contravariant). The type `FutureOr<void>` is
problematic because it may appear to encode that a result is either a
`Future<void>`, or the result should be discarded (when it is
`void`).  However, there is no safe way to detect whether we have one
or the other case because an expression of type `void` can evaluate
to any object whatsoever, including a future of any type.

It is also conceptually unsound to have a type whose meaning is
something like "ignore this object; also, take a look because it
might be a future".

An exception is made for contravariant occurrences of the type
`FutureOr<void>` (e.g., for the type of a formal parameter), and no
warning is emitted for these occurrences. The reason for this
exception is that the type does not describe a result, it describes a
constraint on a value provided by others. Similarly, an exception is
made for type alias declarations, because they may well be used in a
contravariant position (e.g., as the type of a formal
parameter). Hence, in type alias declarations, only the type
parameter bounds are checked.

## Example

```dart
import 'dart:async';

[!FutureOr<void>!] m() => null;
```

## Common fixes

A replacement for the type `FutureOr<void>` which is often useful is
`Future<void>?`. This type encodes that a result is either a
`Future<void>` or it is null, and there is no ambiguity at run time
since no object can have both types.

It may not always be possible to use the type `Future<void>?` as a
replacement for the type `FutureOr<void>`, because the latter is a
supertype of all types, and the former is not. In this case it may be a
useful remedy to replace `FutureOr<void>` by the type `void`.
