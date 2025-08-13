---
title: shared_deferred_prefix
description: >-
  Details about the shared_deferred_prefix
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The prefix of a deferred import can't be used in other import directives._

## Description

The analyzer produces this diagnostic when a prefix in a deferred import is
also used as a prefix in other imports (whether deferred or not). The
prefix in a deferred import can't be shared with other imports because the
prefix is used to load the imported library.

## Example

The following code produces this diagnostic because the prefix `x` is used
as the prefix for a deferred import and is also used for one other import:

```dart
import 'dart:math' [!deferred!] as x;
import 'dart:convert' as x;

var y = x.json.encode(x.min(0, 1));
```

## Common fixes

If you can use a different name for the deferred import, then do so:

```dart
import 'dart:math' deferred as math;
import 'dart:convert' as x;

var y = x.json.encode(math.min(0, 1));
```

If you can use a different name for the other imports, then do so:

```dart
import 'dart:math' deferred as x;
import 'dart:convert' as convert;

var y = convert.json.encode(x.min(0, 1));
```
