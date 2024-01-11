---
title: The dart:js_util library
short-title: dart:js_util
description: Overview of the utility library for JS interop
---

[**`dart:js_util` API docs**][]

**We will continue to support `dart:js_util` alongside static interop.**

The `dart:js_util` library, or just `js_util`, is a low-level utility library
for performing JS interop. Because `js_util` is so low-level,
it could potentially be able to provide more flexibility than static interop,
for example, in rare edge cases where `js_interop` is not expressive enough.
This is an exception to the rule;
**please always use static, inline-class based interop by default**.

The `js_util` library is supported by the JS and `dart2wasm` backends.
It is slower and less ergonomic than `js_interop`.

The best example of the difference in ergonomics between `js_interop` and
`js_util` is calling equivalent [`external`][] methods. 
Each interop solution generates JavaScript code upon calling an `external` method:

```dart
// js_util external call:
...

// javascript generated:
...
```

The JavaScript code `external` generates for `js_util` is very verbose,
compared to the efficient, compact generation for `js_interop`:

```dart
// js_interop external call:
...

// javascript generated:
...
```

For optimal JS interop, only use `js_util` over static interop if you encounter
a use case that `js_interop` cannot address
(and please [let us know][] if you encounter such a use case).

[**`dart:js_util` API docs**]: {{site.dart-api}}/dart-js_util/dart-js_util-library.html
[`external`]: /web/js-interop/reference#external
[let us know]: https://github.com/dart-lang/sdk/issues/new?assignees=&labels=web-js-interop&template=1_issue_template.md&title=Create+an+issue