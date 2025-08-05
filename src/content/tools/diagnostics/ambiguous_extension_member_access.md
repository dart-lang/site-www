---
title: ambiguous_extension_member_access
description: >-
  Details about the ambiguous_extension_member_access
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_A member named '{0}' is defined in '{1}' and '{2}', and neither is more specific._
_A member named '{0}' is defined in {1}, and none are more specific._

## Description

When code refers to a member of an object (for example, `o.m()` or `o.m` or
`o[i]`) where the static type of `o` doesn't declare the member (`m` or
`[]`, for example), then the analyzer tries to find the member in an
extension. For example, if the member is `m`, then the analyzer looks for
extensions that declare a member named `m` and have an extended type that
the static type of `o` can be assigned to. When there's more than one such
extension in scope, the extension whose extended type is most specific is
selected.

The analyzer produces this diagnostic when none of the extensions has an
extended type that's more specific than the extended types of all of the
other extensions, making the reference to the member ambiguous.

## Example

The following code produces this diagnostic because there's no way to
choose between the member in `E1` and the member in `E2`:

```dart
extension E1 on String {
  int get charCount => 1;
}

extension E2 on String {
  int get charCount => 2;
}

void f(String s) {
  print(s.[!charCount!]);
}
```

## Common fixes

If you don't need both extensions, then you can delete or hide one of them.

If you need both, then explicitly select the one you want to use by using
an extension override:

```dart
extension E1 on String {
  int get charCount => length;
}

extension E2 on String {
  int get charCount => length;
}

void f(String s) {
  print(E2(s).charCount);
}
```
