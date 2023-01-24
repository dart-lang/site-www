---
title: JavaScript interoperability
short-title: JS interop
description: "Use package:js to integrate JavaScript code into your Dart web app."
toc: false
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
and development web compilers, as well as Dart's
in-progress Wasm compiler ([`dart2wasm`][]).

For a glimpse into the next generation of JS interop,
you can refactor your code to conform to the new
syntax and semantics now. Doing so will
likely not prevent the need to refactor again once
[Dart 3][] lands, as the features are still in development. 
However, the features available for preview are much
closer to future JS interop than any pattern supported today.
So, there are a few reasons to try them out now:

* New JS interop developers can learn and build with future JS interop
so they won't have to unlearn obsolete patterns in a few months.
* Existing JS interop developers eager to experiment with
the latest features in JS interop
or with `dart2wasm` when it becomes available.
* Potentially ease transition of existing JS
interop code once migration becomes necessary.

The following sections are the set of features
expected to work across compilers for JS interop.

*Requirements:*
* Dart SDK constraint: `>= 2.19`
* [`package:js`][] constraint: `>= 0.6.6`

[`dart2wasm`]: https://github.com/dart-lang/sdk/blob/main/pkg/dart2wasm/dart2wasm.md#running-dart2wasm
[Dart 3]: https://medium.com/dartlang/the-road-to-dart-3-afdd580fbefa
[`package:js`]: {{site.pub-pkg}}/js

### `package:js`

The key feature of next-generation JS interop is [static interop][].
We recommend using static interop as the default for `package:js`,
as it is more declaritive, more likely to be optimized,
more likely to perform better, and required for `dart2wasm`.
Static interop addresses several gaps in the existing JS interop story:

* **Missing features:** Static interop enables previously
unavailable features, like easily wrapping and transforming APIs,
renaming members, and static checking.

* **Inconsistencies:** Static interop makes backends more consistent,
so development and production web compilers won't behave as differently
as before.

* **Clarity:** Static interop takes a step towards making JS interop
more idiomatic in Dart, and making the boundary between the two languages more visible.
For example, it enforces that JS classes are not meant to be mixed with Dart
(e.g. no dynamic calls, JS interop types cannot be implemented as a Dart class).
We expect upcoming integration with inline classes
will help make interop even more idiomatic.

You can implement static interop using the `package:js`
annotation `@staticInterop`.
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

[static interop]: https://pub.dev/packages/js#staticinterop
[`@JSExport`]: https://pub.dev/packages/js#jsexport-and-js_utilcreatedartexport


### `dart:js_util`

We recommend using static interop over `js_util`
in future JS interop. 

However, since [`js_util`][] provides lower-level
functionality than static interop, it can be
configured in a more granular, customizable way.
This means `js_util` could *potentially* help with
some rare edge cases we haven't accounted for yet,
that static interop won't be able to  address.

For example, we may discover that some migrations are
easier to accomplish with `js_util`. Preexisting uses of
`dart:js` (now deprecated) can be replaced by a combination
of static interop and `dart:js_util`.
The former is what we recommend, but it may be easier
to automate migrations using the latter.

While `dart:js_util` is supported by `dart2wasm` in future interop,
it won't be as ergonomic, and won't be optimized. 

[`js_util`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-js_util/dart-js_util-library.html