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

## Future-proof JS interop

Dart's JS interop story is currently evolving. 
Many of the features that enable future JS interop,
and support of all three compilers,
are ready to use (Dart version 2.19). 
To ease the transition to future JS interop,
you can refactor your code to conform to the
syntax and semantics of the new features now.

{{site.alert.note}}
  Future-proofing is for those *very* eager to
  prepare their code for [Dart 3][], or to try
  integrating with [`dart2wasm`][] before Dart 3.
  None of this necessarily works *performantly* on
  `dart2wasm` yet, but refactoring now means you
  won't need to later, if that's important to you.
{{site.alert.end}}

The following sections are the set of features
expected to work across compilers for JS interop,
per library.

*Requirements:*
* Dart SDK constraint: `>= 2.19`
* [`package:js`][] constraint: `>= 0.6.6`

[Dart 3]: https://medium.com/dartlang/the-road-to-dart-3-afdd580fbefa
[`dart2wasm`]: https://github.com/dart-lang/sdk/blob/main/pkg/dart2wasm/dart2wasm.md#running-dart2wasm
[`package:js`]: https://pub.dev/packages/js

### `package:js`

If you're interested in interop that will work with
`dart2wasm` when Dart 3 is released, you can implement
[static interop][] using the `package:js` class `@staticInterop`.
Static interop will be continually eveloving until Dart 3.

The set of features for future static interop currently includes:
* `@staticInterop` interfaces
  * External factory constructors with and without `@anonymous`
  * External `static` class members
  * External non-`static` extension members on a `@staticInterop`
  class (fields, getters, setters, methods)
  * Non-external extension members on a `@staticInterop` class
* Top-level external members
* [`@JSExport`][] for mocking and exports

[static interop]: https://github.com/dart-lang/sdk/tree/main/pkg/js#staticinterop
[`@JSExport`]: https://github.com/dart-lang/sdk/tree/main/pkg/js#jsexport-and-js_utilcreatedartexport

### `dart:js_util`

If you're interested in refactoring your [`js_util`][]
interop code in preparation for Dart 3, the following
list of features for the library currently work:
* jsify
* dartify
* getProperty
* hasProperty
* setProperty
* callMethod
* callConstructor
* instanceof
* promiseToFuture
* globalThis
* newObject
* createStaticInteropMock
* createDartExport
* allowInterop

The library may continue to evolve before Dart 3.

[`js_util`]: https://pub.dev/packages/js_util