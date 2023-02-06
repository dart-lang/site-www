---
title: Past JS interop
description: Archive of past JS interop implementations
---

This page addresses previous iterations of JS interop for Dart:
* `package:js`
* `dart:js`

**We do not recommend using any JS interop solution other than [static interop][].**

Each of these tools still exist and are usable.
However, the static interop model
is more performant, provides more capabilities,
and will continue to be supported and developed.
If you are just starting out with JS interop in Dart,
please start with the static interop library, [`js_interop`][].

[static interop]: /web/js-interop
[`js_interop`]: {{site.dart-api}}/js_interop

## `package:js`

// *This section probably doesn't make any sense*

[**`package:js` API docs**]

**We will not continue to support `package:js` alongside static interop.**

The `package:js` library can represent objects in different ways with its
class type annotations: 

* [`@JS`] 
* [`@anonymous`]
* [`@staticInterop`]

Because `package:js` supports dynamic invocations of external members (the
opposite of static interop), its static type checking capabilities are
much more limited than static interop, and therefore cannot be fully sound.
For the same reason, `package:js` can not interop with [DOM APIs][]. 

[**`package:js` API docs**]: {{site.pub-pkg}}/js
[`@JS`]: /web/js-interop/reference#js
[`@Anonymous`]: /web/js-interop/reference#others
[`@staticInterop`]: /web/js-interop/reference#staticinterop
[DOM APIs]: /web/js-interop/dom

## `dart:js` 

[**`dart:js` API docs**]

**We will not continue to support `dart:js` alongside static interop.**

The `dart:js` library is a low-level API for non-static interop with JavaScript.
It's wrapper-based model requires much more overhead,
and is much more expensive and slow,
than static interop's zero-cost wrapper model.

[**`dart:js` API docs**]: {{site.dart-api}}/dart-js/dart-js-library.html