---
title: uri_has_not_been_generated
description: >-
  Details about the uri_has_not_been_generated
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Target of URI hasn't been generated: '{0}'._

## Description

The analyzer produces this diagnostic when an import, export, or part
directive is found where the URI refers to a file that doesn't exist and
the name of the file ends with a pattern that's commonly produced by code
generators, such as one of the following:
- `.g.dart`
- `.pb.dart`
- `.pbenum.dart`
- `.pbserver.dart`
- `.pbjson.dart`
- `.template.dart`

## Example

If the file `lib.g.dart` doesn't exist, the following code produces this
diagnostic:

```dart
import [!'lib.g.dart'!];
```

## Common fixes

If the file is a generated file, then run the generator that generates the
file.

If the file isn't a generated file, then check the spelling of the URI or
create the file.
