---
title: JavaScript interoperability
short-title: JS interop
description: "Use package:js to integrate JavaScript code into your Dart web app."
---

The [Dart web platform](/overview#web-platform) supports calling
JavaScript using the `js` package,
also known as _package:js_.

For help using the `js` package, see the following:

* Documentation for the `js` package:
  * [pub.dev site page][js]
  * [API reference][js-api]
* Packages that use the `js` package:
  * [sass][] is an example of a more unusual use case: providing a
    way for JavaScript code to call Dart code.

[js]: {{site.pub-pkg}}/js
[js-api]: {{site.pub-api}}/js
[sass]: {{site.pub-pkg}}/sass

## Next-generation JS interop preview

{{site.alert.note}}
  This interop feature is **experimental**,
  and [in active development](https://github.com/dart-lang/sdk/issues/35084).
{{site.alert.end}}

Dart's JS interop story is currently evolving. 
Many of the features that enable future JS interop
are ready to experiment with as of Dart version 2.19.
These features support the existing production
and development web compilers, 
as well as Dart's in-progress Wasm compiler ([`dart2wasm`][]).

For a glimpse into the next generation of JS interop,
you can refactor your code to conform to
the new syntax and semantics now. 
Doing so will likely not prevent the need to refactor again
once [Dart 3][] lands, as the features are still in development. 
However, the features available for preview are much closer
to future JS interop than any pattern supported today.
So, there are a few reasons to try them out now:

* New JS interop developers can learn and build with future JS interop
  so they won't have to unlearn obsolete patterns in a few months.
* Existing JS interop developers eager to experiment with
  the latest features in JS interop 
  or with `dart2wasm` when it becomes available.
* Potentially ease transition of existing JS interop code
  once migration becomes necessary.

The following sections are the set of features
expected to work across compilers for JS interop.

*Requirements:*

* Dart SDK constraint: `>= 2.19`
* [`package:js`][] constraint: `>= 0.6.6`

[`dart2wasm`]: https://github.com/dart-lang/sdk/blob/main/pkg/dart2wasm#running-dart2wasm
[Dart 3]: https://medium.com/dartlang/dart-3-alpha-f1458fb9d232
[`package:js`]: {{site.pub-pkg}}/js

### `package:js`

The key feature of next-generation JS interop is [static interop][].
We recommend using static interop as the default for `package:js`,
as it is more declarative, more likely to be optimized,
more likely to perform better, and required for `dart2wasm`.
Static interop addresses several gaps in the existing JS interop story:

* **Missing features:** Static interop enables previously
  unavailable features, like easily wrapping and transforming APIs,
  renaming members, and static checking.

* **Inconsistencies:** Static interop makes backends more consistent,
  so development and production web compilers
  won't behave as differently as before.

* **Clarity:** Static interop takes a step towards making 
  JS interop more idiomatic in Dart, 
  and making the boundary between the two languages more visible.
  For example, it enforces that JS classes are not meant to be mixed with Dart
  (dynamic calls aren't allowed, 
  and JS interop types cannot be implemented as a Dart class).

You can implement static interop using
the `package:js` annotation [`@staticInterop`][].
The set of features for future static interop currently includes:

* `@staticInterop` interfaces
  * External factory constructors with and without `@anonymous`
  * External `static` class members
  * External non-`static` extension members on a `@staticInterop`
    class (fields, getters, setters, methods)
  * Non-external extension members on a `@staticInterop` class
* Top-level external members
* [`@JSExport`][] for mocking and exports

To learn how to implement static interop and see examples,
visit the [static interop][] specification.

[`@staticInterop`]: {{site.pub-api}}/js/latest/js/staticInterop-constant.html
[static interop]: {{site.pub-pkg}}/js#staticinterop
[`@JSExport`]: {{site.pub-pkg}}/js#jsexport-and-js_utilcreatedartexport

### `dart:js_util`

[`dart:js_util`][] provides low-level interop API
and is supported by the JS and `dart2wasm` backends.
`dart:js_util` can provide more flexibility,
for example, in potential, rare edge cases we haven't yet
accounted for where static interop is not expressive enough.

However, it is not as ergonomic, and we do not plan
to optimize it in the same way as static interop.
As a result, we highly recommend using static interop over
`dart:js_util` whenever it's possible.

[`dart:js_util`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-js_util/dart-js_util-library.html
