---
title: Fixing type promotion failures
description: Solutions for cases where you know more about a field's type than Dart can determine.
toc: false
---

{{ site.alert.warn}}
  **This page is under construction**
  ([issue #2940][]).
{{ site.alert.end}}

This page will have information to help you understand
why type promotion failures occur,
and give tips on how to fix them.
For example, consider the following code:

```dart
class C {
  int? i;                  // (1)
  f() {
    if (i == null) return;
    i.isEven;              // (2)
  }
}
```

The Dart compiler produces an error message for (2)
that points to (1) and explains that
`i` can't be promoted to a non-nullable type
because it's a field.
The usual fix is to either use `i!`
or create a local variable
of type `int` that holds the value of `i`.

Until this page is complete, see the following resources:

* [Working with nullable fields][ns-fields]:
  A section in [Understanding null safety][].
* [Discussion in SDK issue #44900][sdk-44900-comment]:
  A detailed list of reasons why type promotion might fail.

[issue #2940]: https://github.com/dart-lang/site-www/issues/2940
[sdk-44900-comment]: https://github.com/dart-lang/sdk/issues/44900#issuecomment-807117343
[ns-fields]: /null-safety/understanding-null-safety#working-with-nullable-fields
[Understanding null safety]: /null-safety/understanding-null-safety
