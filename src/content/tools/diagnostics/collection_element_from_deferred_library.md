---
title: collection_element_from_deferred_library
description: >-
  Details about the collection_element_from_deferred_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Constant values from a deferred library can't be used as keys in a 'const' map literal._
_Constant values from a deferred library can't be used as values in a 'const' constructor._
_Constant values from a deferred library can't be used as values in a 'const' list literal._
_Constant values from a deferred library can't be used as values in a 'const' map literal._
_Constant values from a deferred library can't be used as values in a 'const' set literal._

## Description

The analyzer produces this diagnostic when a collection literal that is
either explicitly (because it's prefixed by the `const` keyword) or
implicitly (because it appears in a [constant context][]) a constant
contains a value that is declared in a library that is imported using a
deferred import. Constants are evaluated at compile time, and values from
deferred libraries aren't available at compile time.

For more information, check out
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

Given a file `a.dart` that defines the constant `zero`:

```dart
const zero = 0;
```

The following code produces this diagnostic because the constant list
literal contains `a.zero`, which is imported using a `deferred` import:

```dart
import 'a.dart' deferred as a;

var l = const [a.[!zero!]];
```

## Common fixes

If the collection literal isn't required to be constant, then remove the
`const` keyword:

```dart
import 'a.dart' deferred as a;

var l = [a.zero];
```

If the collection is required to be constant and the imported constant must
be referenced, then remove the keyword `deferred` from the import:

```dart
import 'a.dart' as a;

var l = const [a.zero];
```

If you don't need to reference the constant, then replace it with a
suitable value:

```dart
var l = const [0];
```

[constant context]: /resources/glossary#constant-context
