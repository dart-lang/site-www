---
title: Breaking changes and deprecations
description: A list of breaking changes by release in Dart.
---

This page lists all language and library breaking changes and deprecations in Dart,
organized by release and area, to help Dart users understand and manage their
impact. Complete release notes are available in the [Dart SDK changelog][changelog].
The [breaking change policy][] document describes the policy and process
around breaking changes and deprecations in Dart. 

**This page includes the following types of breaking changes**:

* **Unversioned**: The Dart SDK does not maintain backward compatibility, and
  code may break as soon as you [upgrade your sdk version][sdk] if it relies on
  the previous behavior.
  
  _These are the majority of changes and are not specially marked in this list._
* **Language versioned**: The Dart SDK maintains backward compatibility for
  existing code, and the behavior change only takes effect (potentially breaking
  code that relies on the previous behavior) when you upgrade the
  [language version][] of your code.
  
  
  _These are marked "**Language versioned**"_.
* **Deprecations**: The Dart SDK maintains compatibility for deprecated code,
  with a warning. Deprecations are then completely removed in a subsequent release,
  breaking any code that relies on the previous behavior.
  
  _These are marked "**Deprecated**" and "**Removed**", respectively_.
* **Experimental**: Part of the release but not yet treated as stable in the SDK,
  and can break from one version to another. Experimental changes do not
  always have a corresponding breaking change issue, but may have more detail in
  the [SDK changelog][changelog].

  _These are marked "**Experimental**", possibly in conjunction with another change type_.

If you have questions or concerns about any of these breaking changes, please 
comment on the breaking change issue linked from the relevant entry.
To be notified about future breaking changes, join the [Dart announce][] group.

[breaking change policy]: {{site.repo.dart.sdk}}/blob/main/docs/process/breaking-changes.md
[changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md
[sdk]: /get-dart
[language version]: /guides/language/evolution#language-versioning
[Dart announce]: {{site.announce}}

{% comment %}
Create new section from these headers for each release.
If no changes exist in a section (e.g. Language, `dart:async`, etc.),
don't include the section header.

## x.x.x

### Language {:.no_toc}

### Libraries {:.no_toc}

#### (`dart:core`, `package:js`, etc)

### Tools {:.no_toc}

#### (Dart VM, Pub, Linter, `dart2js`, etc)
{% endcomment %}

## 3.4.0

**Tentative**<br>
The following changes are expected to be included in the 3.4.0 stable release,
but the final list will likely change before then.
To reduce the potential impact of these changes, consider
accounting for them before the 3.4.0 release.

### Language {:.no_toc}

* [The pattern context type schema for cast patterns
  is now `_` (the unknown type) instead of `Object?`][54640].

[54640]: {{site.repo.dart.sdk}}/issues/54640

### Libraries {:.no_toc}

#### `dart:cli`

* **Experimental** **Removed**: [The `waitFor` function][52121]
  has been removed.

[52121]: {{site.repo.dart.sdk}}/issues/52121

#### `dart:html`, `dart:indexed:db`, `dart:svg`, `dart:web_audo`, `dart:web_gl`

- These libraries are now marked as legacy and
  will see less support in the future.
  New projects should prefer to use [`package:web`][] and `dart:js_interop`.

[`package:web`]: {{site.pub-pkg}}/web

#### `dart:js`

- This library is now marked as legacy and will see less support in the future.
  Usages should be migrated to `dart:js_interop` and `dart:js_interop_unsafe`.
  To learn more, check out [`/go/next-gen-js-interop`][].

[`/go/next-gen-js-interop`]: {{site.redirect.go}}/next-gen-js-interop

#### `dart:js_util`

- This library is now marked as legacy and will see less support in the future.
  Usages should be migrated to `dart:js_interop` and `dart:js_interop_unsafe`.
  To learn more, check out [`/go/next-gen-js-interop`][].

[`/go/next-gen-js-interop`]: {{site.redirect.go}}/next-gen-js-interop

#### `dart:typed_data`

* **Deprecated**: [The unmodifiable view classes for typed data are deprecated][53128].
  Instead of using the constructors of these classes, use
  the new `asUnmodifiableView` methods on typed data lists.

[53128]: {{site.repo.dart.sdk}}/issues/53218

### Tools {:.no_toc}

#### Production JavaScript compiler (dart2js)

* **Experimental** **Deprecated**: You should now specify a format to
  the `--dump-info` CLI option of either `binary` or `json`.
  The `json` format is deprecated and might be removed in a future Dart release.

#### Wasm compiler (dart2wasm)

* **Experimental**: Various `dart compile wasm` CLI arguments have
  been updated, removed, or replaced.
  To learn more, run `dart compile wasm --verbose --help`.

## 3.3.0

### SDK {:.no_toc}

* **Experimental** **Removed**: The following experiments are now retired as
  they were released in Dart 3 and are no longer necessary with
  a language version of 3.0 or greater.
  Configuration of them should be removed from
  analysis options, CLI commands, and IDE configurations.

  * `patterns`
  * `records`
  * `class-modifers`
  * `sealed-class`

### Language {:.no_toc}

* [An abstract getter is now considered promotable if
  there are no conflicting declarations][54056].

[54056]: {{site.repo.dart.sdk}}/issues/54056

### Libraries {:.no_toc}

#### `dart:cli`

* **Experimental** **Deprecated**: [The `waitFor` function][52121]
  remains deprecated for another release and is set for removal in Dart 3.4.

[52121]: {{site.repo.dart.sdk}}/issues/52121

#### `dart:ffi`

* **Deprecated**: [The `elementAt` pointer arithmetic methods
  on `Pointer` types are deprecated][54250].
  Migrate to the `-` and `+` operators instead.
* **Experimental** **Removed**: The previously deprecated
  `@FfiNative` annotation has been removed. Usages should be
  updated to use the `@Native` annotation.

[54250]: {{site.repo.dart.sdk}}/issues/54250

#### `dart:html`

* Instead of using `HttpRequest` directly,
  it is now recommended to use [`package:http`][].

[`package:http`]: {{site.pub-pkg}}/http

#### `dart:io`

* Instead of using `HttpClient` directly,
  it is now recommended to use [`package:http`][].

[`package:http`]: {{site.pub-pkg}}/http

#### `dart:js_interop`

* **Experimental**: JS types like `JSAny` have
  [new compiler-specific representation types][52687].
* **Experimental**: User-defined `@staticInterop` classes can
  [no longer implement `JSAny` or `JSObject`][52687].
  Usages should be migrated to `JSObject.fromInteropObject` or
  be defined as extension types.
* **Experimental**: `JSArray` and `JSPromise` now have generic parameters.
* **Experimental**: Various extension members were moved or renamed.
  To learn about the updated extensions, reference
  `JSAnyUtilityExtension` and `JSAnyOperatorExtension`.

[52687]: {{site.repo.dart.sdk}}/issues/52687

#### `dart:typed_data`

* [The unmodifiable view classes for typed data will
  be deprecated in Dart 3.4][53128].
  Instead of using the constructors of these classes, use
  the new `asUnmodifiableView` methods on typed data lists.

[53128]: {{site.repo.dart.sdk}}/issues/53218

#### `dart:nativewrappers`

* **Experimental**: [All native wrapper classes are now marked `base`][51896]
  so that none of their subtypes can be implemented.

[51896]: {{site.repo.dart.sdk}}/issues/51896

### Tools {:.no_toc}

#### Production JavaScript compiler (dart2js)

* [The `Invocation` that is passed to `noSuchMethod` no longer
  has a minified `memberName`][54201], even when compiled with `--minify`.

[54201]: {{site.repo.dart.sdk}}/issues/54201

#### Wasm compiler (dart2wasm)

* **Experimental**: [Disallow importing legacy JS interop libraries][54004].
  Prefer using `dart:js_interop` and `dart:js_interop_unsafe` instead.

[54004]: {{site.repo.dart.sdk}}/issues/54004

#### Analyzer

* **Experimental**: Invalid `dart doc` comment directives are
  now reported by the analyzer.
* Due to [improvements in type promotion][54056], the following analyzer
  diagnostics might trigger on existing code that previously passed analysis:

  * `unnecessary_non_null_assertion`
  * `unnecessary_cast`
  * `invalid_null_aware_operator`

[54056]: {{site.repo.dart.sdk}}/issues/54056

#### Linter

* The `iterable_contains_unrelated_type` and
  `list_remove_unrelated_type` lints were removed.
  Consider migrating to the expanded
  [`collection_methods_unrelated_type`][] lint.
* The following lints are removed due to no longer being
  necessary with sound null safety. You should remove configuration of them
  from your `analysis_options.yaml` files and any ignore comments.
  
  * `always_require_non_null_named_parameters`
  * `avoid_returning_null`
  * `avoid_returning_null_for_future`

[`collection_methods_unrelated_type`]: /tools/linter-rules/collection_methods_unrelated_type

## 3.2.0

### Language {:.no_toc}

* **Language versioned**: [Changed the split point for refutable patterns][53167]
  to the top level pattern so type promotion in if-case statements is consistent
  regardless of whether the scrutinee might throw an exception.

### Libraries {:.no_toc}

#### `dart:cli`

* **Experimental** **Deprecated**: [The `waitFor` function.][52121]

#### `dart:convert`

* [Changed return types of `utf8.encode()` and `Utf8Codec.encode()`][52801]
 from `List<int>` to `Uint8List`.

#### `dart:developer`

* **Deprecated**: The `Service.getIsolateID` method.

#### `dart:ffi`

* [Changed `NativeCallable.nativeFunction` so calls now throw an error if
  the receiver is already closed][53311], instead of returning `nullptr`.

#### `dart:io`

* [Eliminated trailing whitespace from HTTP headers][53005].
* [Inserted a space at the fold point of folded header values][53227]
  that `HttpClientResponse.headers` and `HttpRequest.headers` return.

#### `dart:js_interop`

* **Experimental** **Removed**: `JSNumber.toDart` in favor of `toDartDouble` and
  `toDartInt`.
* **Experimental** **Removed**: `Object.toJS` in favor of `Object.toJSBox.`
* **Experimental**: Restricted external JS interop APIs using `dart:js_interop`
  to a set of allowed types.
* **Experimental**: Prohibited use of `isNull` and `isUndefined` on dart2wasm.
* **Experimental**: Changed `typeofEquals` and `instanceof` APIs to both return
  bool instead of `JSBoolean`.
  Also, `typeofEquals` now takes `String` instead of `JSString`.
* **Experimental**: Changed `JSAny` and `JSObject` types to only implementable,
  not extendable, by user `@staticInterop` types.
* **Experimental**: Changed `JSArray.withLength` to take `int` instead of `JSNumber`.

### Tools {:.no_toc}

#### Development JavaScript compiler (DDC)

* [Added interceptors for JavaScript `Symbol` and `BigInt` types][53106];
  they should no longer be used with `package:js` classes.

#### Production JavaScript compiler (dart2js)

* [Added interceptors for JavaScript `Symbol` and `BigInt` types][53106];
  they should no longer be used with `package:js` classes.

#### Analyzer

* **Language versioned**: [Private final field promotion][2020] might cause the following
  analyzer warnings to trigger on existing code that previously passed analysis:
  
  * [`unnecessary_non_null_assertion`](/tools/diagnostic-messages#unnecessary_non_null_assertion)
  * [`invalid_null_aware_operator`](/tools/diagnostic-messages#invalid_null_aware_operator)
  * [`unnecessary_cast`](/tools/diagnostic-messages#unnecessary_cast)

  ```dart
  class C {
    final num? _x = null;

    void test() {
      if (_x != null) {
        print(_x! * 2); // unnecessary_non_null_assertion
        print(_x?.abs()); // invalid_null_aware_operator
      }
      if (_x is int) {
        print((_x as int).bitLength); // unnecessary_cast
      }
    }
  }
  ```

[53167]: {{site.repo.dart.sdk}}/issues/53167
[52121]: {{site.repo.dart.sdk}}/issues/52121
[52801]: {{site.repo.dart.sdk}}/issues/52801
[53311]: {{site.repo.dart.sdk}}/issues/53311
[53005]: {{site.repo.dart.sdk}}/issues/53005
[53227]: {{site.repo.dart.sdk}}/issues/53227
[53106]: {{site.repo.dart.sdk}}/issues/53106
[2020]: {{site.repo.dart.lang}}/issues/2020


## 3.1.0

### Libraries {:.no_toc}

#### `dart:async`

* [Added `interface` modifier to purely abstract classes:][52334]
 `MultiStreamController`, `StreamConsumer`, `StreamIterator` and `StreamTransformer`.

#### `dart:io`

* [Added `sameSite` to the `Cookie` class, and added the class `SameSite`][51486].
* [`FileSystemEvent` is `sealed`][52027]. This means `FileSystemEvent` cannot be 
  extended or implemented.

#### `dart:js_interop`

* **Experimental** **Removed**: `ObjectLiteral`; create an object literal with
  no named members using `{}.jsify()`.

#### `package:js`

* `external` `@staticInterop` members and `external` extension members can no
  longer be used as tear-offs. Declare a closure or a non-`external` method that
  calls these members, and use that instead.
* `external` `@staticInterop` members and `external` extension members will
  generate slightly different JS code for methods that have optional parameters.

[52334]: {{site.repo.dart.sdk}}/issues/52334
[51486]: {{site.repo.dart.sdk}}/issues/51486
[52027]: {{site.repo.dart.sdk}}/issues/52027

## 3.0.0

:::tip
The [Dart 3.0 migration guide][dart3] covers the complete details
on all the changes in this section.
:::

### Language {:.no_toc}

* **Language versioned**: Changed interpretation of [switch cases] from constant
  expressions to patterns.

* **Language versioned**: Class declarations from libraries that have been upgraded
  to Dart 3.0 [can no longer be used as mixins by default][mixin class].

* [Dart reports a compile-time error][50902] if a `continue` statement targets
  a [label] that is not a loop (`for`, `do` and `while` statements) or a `switch`
  member.

### Libraries {:.no_toc}

* The following existing classes have been made mixin classes:
  `Iterable`, `IterableMixin`, `IterableBase`, `ListMixin`, `SetMixin`, `MapMixin`,
  `LinkedListEntry`, `StringConversionSink`.

#### `dart:core`

* **Deprecated**: [Deprecated APIs][49529].

#### `dart:async`

* **Removed**: [Removed the deprecated][49529] [`DeferredLibrary`][] class.

#### `dart:collection`

* **Language versioned**: [Changes to platform libraries][collection].

#### `dart:developer`

* **Removed**: [Removed the deprecated][49529] [`MAX_USER_TAGS`][] constant.
  Use [`maxUserTags`][] instead.
* **Removed**: [Removed the deprecated][50231] [`Metrics`][], [`Metric`][], [`Counter`][],
  and [`Gauge`][] classes as they have been broken since Dart 2.0.

#### `dart:ffi`

* **Experimental** **Deprecated**: The `@FfiNative` annotation is
  now deprecated. Usages should be updated to use the `@Native` annotation.

#### `dart:html`

* **Removed**: [Removed the deprecated `registerElement` and `registerElement2`][49536]
  methods in `Document` and `HtmlDocument`.

#### `dart:math`

* **Language versioned**: The `Random` interface can only be implemented,
  not extended.

#### `dart:io`

* [Updated `NetworkProfiling`][51035] to accommodate new `String` ids that are
  introduced in vm_service:11.0.0

[dart3]: /resources/dart-3-migration/
[switch cases]: /language/branches#switch
[mixin class]: /language/mixins#class-mixin-or-mixin-class
[label]: /language/branches#switch
[50902]: {{site.repo.dart.sdk}}/issues/50902
[collection]: /resources/dart-3-migration#dart-collection
[49529]: {{site.repo.dart.sdk}}/issues/49529
[`DeferredLibrary`]: {{site.dart-api}}/stable/2.18.4/dart-async/DeferredLibrary-class.html
[`deferred as`]: /guides/language/language-tour#lazily-loading-a-library
[`MAX_USER_TAGS`]: {{site.dart-api}}/stable/dart-developer/UserTag/MAX_USER_TAGS-constant.html
[`maxUserTags`]: {{site.dart-api}}/beta/2.19.0-255.2.beta/dart-developer/UserTag/maxUserTags-constant.html
[50231]: {{site.repo.dart.sdk}}/issues/50231
[`Metrics`]: {{site.dart-api}}/stable/2.18.2/dart-developer/Metrics-class.html
[`Metric`]: {{site.dart-api}}/stable/2.18.2/dart-developer/Metric-class.html
[`Counter`]: {{site.dart-api}}/stable/2.18.2/dart-developer/Counter-class.html
[`Gauge`]: {{site.dart-api}}/stable/2.18.2/dart-developer/Gauge-class.html
[49536]: {{site.repo.dart.sdk}}/issues/49536
[51035]: {{site.repo.dart.sdk}}/issues/51035


## 2.19.0

### Language {:.no_toc}

* [Flagged additional code as unreachable][49635] due to types `Null` and `Never`.
* [Don't delegate inaccessible private names to `noSuchMethod`][49687].
* [Report a compile-time error][50383] for all cyclic dependencies during
  top-level type inference.

### Libraries {:.no_toc}

#### `dart:convert`

* **Removed**: [The previously deprecated API][34233] [`DEFAULT_BUFFER_SIZE`] in `JsonUtf8Encoder`
  has been removed.

#### `dart:developer`

* **Removed**: [Removed previously deprecated APIs][34233] `kInvalidParams`,
  `kExtensionError`, `kExtensionErrorMax`, and `kExtensionErrorMin` in
  [`ServiceExtensionResponse`].

#### `dart:ffi`

* [Changed the runtime type argument of `Pointer` to `Never`][49935] in
  preparation of completely removing the runtime type argument. 
  Changed `Pointer.toString` to not report any type argument.

#### `dart:io`

* [Disallow negative or hexadecimal content-length headers][49305].
* [`File.create` now takes new optional `exclusive` `bool` parameter][49647],
  and when it is `true` the operation will fail if target file already exists.
* Calling `ResourceHandle.toFile()`, `ResourceHandle.toSocket()`,
  `ResourceHandle.toRawSocket()` or `ResourceHandle.toRawDatagramSocket()`,
  more than once [now throws a `StateError`][49878].

#### `dart:isolate`

* Reverted [`SendPort.send`] back to strict checks on contents of messages when
  sending messages between isolates that are not known to share the same code.

#### `dart:mirrors`

* [Removed APIs][34233] [`MirrorsUsed`] and [`Comment`].

#### `package:js`

* Breaking changes to the preview feature `@staticInterop`:
  * Disallowed classes with this annotation from using `external`
    generative constructors. See [48730] and [49941] for more details.
  * [Disallowed classes with this annotation's external extension members from
    using type parameters][49350].
  * Classes with this annotation should also have the `@JS` annotation.
  * Classes with this annotation can not be implemented by classes without this
    annotation.

#### `dart2js`

* [`dart2js` no longer supports HTTP URIs as inputs][49473].

[49635]: {{site.repo.dart.sdk}}/issues/49635
[49687]: {{site.repo.dart.sdk}}/issues/49687
[50383]: {{site.repo.dart.sdk}}/issues/50383
[34233]: {{site.repo.dart.sdk}}/issues/34233
[`ServiceExtensionResponse`]: {{site.dart-api}}/stable/2.17.6/dart-developer/ServiceExtensionResponse-class.html#constants
[49935]: {{site.repo.dart.sdk}}/issues/49935
[49305]: {{site.repo.dart.sdk}}/issues/49305
[49647]: {{site.repo.dart.sdk}}/issues/49647
[49878]: {{site.repo.dart.sdk}}/issues/49878
[`SendPort.send`]: {{site.dart-api}}/stable/dart-isolate/SendPort/send.html
[34233]: {{site.repo.dart.sdk}}/issues/34233
[49473]: {{site.repo.dart.sdk}}/issues/49473
[48730]: {{site.repo.dart.sdk}}/issues/48730
[49941]: {{site.repo.dart.sdk}}/issues/49941
[49350]: {{site.repo.dart.sdk}}/issues/49350


## 2.18.0

### Language {:.no_toc}

* [Removed support for mixin of classes that don't extend `Object`][48167].

### Libraries {:.no_toc}

#### `dart:io`

* [Changed the `uri` property of `RedirectException` in `dart:io` to be nullable][49045].
* [Removed constants in `dart:io` networking APIs following the `SCREAMING_CAPS`
  convention][34218].
* [The Dart VM no longer automatically restores the initial terminal settings][45630]
  upon exit.

### Tools {:.no_toc}

* [Fully discontinued the `.packages` file][48272]. 

#### Dart command line

* [Removed the standalone `dart2js` and `dartdevc` tools][46100].
* [Removed the standalone `dartanalyzer` tool][46100].

[48167]: {{site.repo.dart.sdk}}/issues/48167
[49045]: {{site.repo.dart.sdk}}/issues/49045
[34218]: {{site.repo.dart.sdk}}/issues/34218
[45630]: {{site.repo.dart.sdk}}/issues/45630
[48272]: {{site.repo.dart.sdk}}/issues/48272
[46100]: {{site.repo.dart.sdk}}/issues/46100

## 2.17.0

### Libraries {:.no_toc}

#### `dart:io`

* [Added new `connectionFactory` property to `HttpClient`][47887].
* [Added new `keyLog` property to `HttpClient`][48093], which allows TLS keys to
  be logged for debugging purposes.
* [Removed constants in `dart:io` following the `SCREAMING_CAPS`][34218]
* [Added a new `allowLegacyUnsafeRenegotiation` property to `SecurityContext`][48513],
  which allows TLS renegotiation for client secure sockets.

### Tools {:.no_toc}

#### Dart command line

* **Deprecated**: [Deprecated the standalone `dart2js` tool][46100].
* **Deprecated**: [Deprecated the standalone `dartdevc` tool][46100].
* **Removed**: [Removed the standalone `dartdoc` tool][46100].

[47887]: {{site.repo.dart.sdk}}/issues/47887
[48093]: {{site.repo.dart.sdk}}/issues/48093
[34218]: {{site.repo.dart.sdk}}/issues/34218
[48513]: {{site.repo.dart.sdk}}/issues/48513
[46100]: {{site.repo.dart.sdk}}/issues/46100

## 2.16.0

### Libraries {:.no_toc}

#### `dart:io`

* On Windows, [`Directory.rename` will no longer delete a directory][47653] if
  `newPath` specifies one. Instead, a `FileSystemException` will be thrown.
* **Removed**: [Removed the `Platform.packageRoot` API][47769].

#### `dart:isolate`

* **Removed**: [Removed the `Isolate.packageRoot` API][47769].

### Tools {:.no_toc}

#### Dart command line

* **Deprecated**: [Deprecated the standalone `dartanalyzer` tool][46100].
* **Deprecated**: [Deprecated the standalone `dartdoc` tool][46100].
* **Removed**: [Removed the deprecated standalone `pub` tool][46100].

[47653]: {{site.repo.dart.sdk}}/issues/47653
[47769]: {{site.repo.dart.sdk}}/issues/47769
[46100]: {{site.repo.dart.sdk}}/issues/46100

## 2.15.0

### Libraries {:.no_toc}

#### `dart:io`

* [Updated the `SecurityContext` class][46875] to set the minimum
  TLS protocol version to TLS1_2_VERSION (1.2) instead of TLS1_VERSION.

#### `dart:web_sql`

* [Completely deleted the `dart:web_sql` library][46316].

#### `dart:html`

* [Removed `window.openDatabase`][46316] (related to `dart:web_sql` deletion above).

### Tools {:.no_toc}

#### Dart command line

* [Removed the standalone `dart2native` tool][46100].
* Removed the standalone `dartfmt` tool.

#### Dart VM

* [Removed support for `dart-ext:`-style native extensions][45451]
* [Grouped isolates spawned via the `Isolate.spawn()` API][46754] to operate on the
  same managed heap, and therefore share various VM-internal data structures.

[46875]: {{site.repo.dart.sdk}}/issues/46875
[46316]: {{site.repo.dart.sdk}}/issues/46316
[45451]: {{site.repo.dart.sdk}}/issues/45451
[46754]: {{site.repo.dart.sdk}}/issues/46754

## 2.14.0

### Libraries {:.no_toc}

#### `dart:io`

* The setter callbacks `.authenticate` and `.authenticateProxy` in `HttpClient`
  must now accept a nullable `realm` argument (for pre-migrated null safe code).

#### `dart:typed_data`

* Most types exposed by this library [can no longer be extended, implemented or
  mixed-in][45115].

### Tools {:.no_toc}

#### Dart VM

* Expandos, and the `object` parameters of `Dart_NewWeakPersistentHandle` and 
  `Dart_NewFinalizableHandle`, [no longer accept `Pointer` and subtypes of `Struct`][45071] 

#### Dart command line

* [Deprecated the standalone `dart2native` tool][46100]
* Deprecated the standalone `dartfmt` tool.

#### `dart2js`

* [`dart2js` no longer supports legacy browsers][46545], because it emits ES6+
  JavaScript by default.

#### Dart Dev Compiler (DDC)

* [Changed subtyping relations of `package:js` classes][44154] to be more correct and
  consistent with Dart2JS.

[45115]: {{site.repo.dart.sdk}}/issues/45115
[45071]: {{site.repo.dart.sdk}}/issues/45071
[46545]: {{site.repo.dart.sdk}}/issues/46545
[44154]: {{site.repo.dart.sdk}}/issues/44154


## 2.13.0

### Libraries {:.no_toc}

#### `package:js`

* [No longer valid][44211] to use a `String` that matches an `@Native` annotation
  in an `@JS()` annotation for a non-anonymous JS interop class.

[44211]: {{site.repo.dart.sdk}}/issues/44211

## 2.12.0

### Language {:.no_toc}

* [Null safety] is now enabled by default in all code that
  has not opted out.
* [Fixed an implementation bug][44660] where `this` would sometimes undergo type
  promotion in extensions.

### Libraries {:.no_toc}

#### `dart:ffi`

* [Deprecated invocations with a generic `T`][44621] of `sizeOf<T>`,
  `Pointer<T>.elementAt()`, `Pointer<T extends Struct>.ref`, and
  `Pointer<T extends Struct>[]`
* [Deprecated `allocate` in `package:ffi`][44621], as it will no longer be
  able to invoke `sizeOf<T>` generically.
* [Deprecated subtypes of `Struct` without any native member][44622].

### Tools {:.no_toc}

#### Dart VM

* [`Dart_WeakPersistentHandle` no longer auto-deletes itself][42312] when the
  referenced object is garbage collected to avoid race conditions.
* [Renamed `Dart_WeakPersistentHandleFinalizer` to `Dart_HandleFinalizer`][42312] 
  and removed its `handle` argument.

#### Pub 

* [The Dart SDK constraint is now **required** in `pubspec.yaml`][44072].

[Null safety]: /null-safety/understanding-null-safety
[44660]: {{site.repo.dart.sdk}}/issues/44660
[44621]: {{site.repo.dart.sdk}}/issues/44621
[42312]: {{site.repo.dart.sdk}}/issues/42312
[44622]: {{site.repo.dart.sdk}}/issues/44622
[44072]: {{site.repo.dart.sdk}}/issues/44072

## 2.10.0

### Tools {:.no_toc}

#### Dart VM

* [Renamed `dart_api_dl.cc` to `dart_api_dl.c`][42982] and changed to a pure C file.

[42982]: {{site.repo.dart.sdk}}/issues/42982

## 2.9.0

### Libraries {:.no_toc}

#### `dart:convert`

* When encoding a string containing unpaired surrogates as UTF-8, [the unpaired
  surrogates will be encoded as replacement characters][41100] (`U+FFFD`).
* When decoding UTF-8, [encoded surrogates will be treated as malformed input][41100].
* [Changed the number of replacement characters emitted][41100] for malformed
  input sequences to match the [WHATWG encoding standard][] when decoding UTF-8
  with `allowMalformed: true`.

#### `dart:html`

* `CssClassSet.add()` and `CssClassSet.toggle` now return `false` instead of
   `null` if the `CssClassSet` corresponds to multiple elements. 

#### `dart:mirrors`

* [Web compilers (dart2js and DDC) now produce a compile-time error][42714] if
  `dart:mirrors` is imported.

### Tools {:.no_toc}

#### Dart VM

* When printing a string using the `print` function, [the default implementation
  will print any unpaired surrogates in the string as replacement characters][41100]
  (`U+FFFD`).
* The `Dart_StringToUTF8` function in the Dart API [will convert unpaired
  surrogates into replacement characters][41100].


[41100]: {{site.repo.dart.sdk}}/issues/41100
[whatwg encoding standard]: https://encoding.spec.whatwg.org/#utf-8-decoder
[42714]: {{site.repo.dart.sdk}}/issues/42714

## 2.8.1

### Language {:.no_toc}

* [Fixed an implementation bug][40675] where local variable inference would
  incorrectly use the promoted type of a type variable.
* [Fixed an implementation bug][41362] surrounding the clauses
  `implements Function`, `extends Function`, or `with Function` no longer having
  an effect since Dart 2.0.0.

### Libraries {:.no_toc}

#### `dart:async`

* [Changed the return type of `StreamSubscription.cancel()` to `Future<void>`][40676].
* [Split the `runZoned()` function into two functions][40681]:
  `runZoned()` and `runZonedGuarded()`, where the latter has a
  required `onError` parameter, and the former has none.
* Errors passed to `Completer.completeError()`, `Stream.addError()`,
  `Future.error()`, etc. [can no longer be `null`][40683].
* [Made stack traces non-null ][40130].

#### `dart:core`

* Three members on `RuneIterator` [no longer return `null`][40674] when accessed
  before the first call to `moveNext()`.
* The `String.fromEnvironment()` default value for `defaultValue` 
  [is now an empty string instead of `null`][40678].
* The default value for `int.fromEnvironment()`'s `defaultValue` parameter
  [is now zero][40678].

#### `dart:ffi`

* Changed `Pointer.asFunction()` and `DynamicLibrary.lookupFunction()` to
  extension methods.

#### `dart:io`

* [Changed the signature of `HttpHeaders` methods][33501] `add()` and `set`.
* [The `Socket` class now throws a `SocketException`][40702] if the socket has
  been explicitly destroyed or upgraded to a secure socket upon setting or getting socket options.
* [The `Process` class now throws a `StateError`][40483]
  if the process is detached (`ProcessStartMode.detached` and
  `ProcessStartMode.detachedWithStdio`) upon accessing the `exitCode` getter.
* [The `Process` class now also throws][40483] when not connected to the child
  process's stdio (`ProcessStartMode.detached` and `ProcessStartMode.inheritStdio`) upon accessing the `stdin`, `stdout`, and `stderr` getters.
* The dummy object returned if `FileStat.stat()` or `FileStat.statSync()` fail
  [now contains Unix epoch timestamps][40706] instead of `null` for the `accessed`,
  `changed`, and `modified` getters.
* [The `HeaderValue` class now parses more strictly][40709] in two invalid edge cases.

### Tools {:.no_toc}

#### Dart Dev Compiler (DDC)

We fixed several inconsistencies between DDC and Dart2JS so that users less
frequently encounter code that is accepted by one compiler but then fails in the
other.

* Deleted the legacy (analyzer based) version of [DDC][ddc].
* Functions passed to JavaScript using the recommended `package:js` interop
  specification must now be wrapped with a call to `allowInterop`. 
* Constructors in `@JS()` classes must be marked with `external`.

#### `dart2js`

* Corresponding type parameter bounds now only need to be mutual
  subtypes rather than structurally equal up to renaming of bound type variables
  and equating all top types.
* Types are now [normalized].
* Constructors in `@JS()` classes must be marked with `external`.
* Completely removed the `--package-root` flag, which was hidden and disabled
  in Dart 2.0.0.

[40675]: {{site.repo.dart.sdk}}/issues/40675
[41362]: {{site.repo.dart.sdk}}/issues/41362
[40676]: {{site.repo.dart.sdk}}/issues/40676
[40681]: {{site.repo.dart.sdk}}/issues/40681
[40683]: {{site.repo.dart.sdk}}/issues/40683
[40130]: {{site.repo.dart.sdk}}/issues/40130
[40674]: {{site.repo.dart.sdk}}/issues/40674
[40678]: {{site.repo.dart.sdk}}/issues/40678
[33501]: {{site.repo.dart.sdk}}/issues/33501
[40702]: {{site.repo.dart.sdk}}/issues/40702
[40483]: {{site.repo.dart.sdk}}/issues/40483
[40706]: {{site.repo.dart.sdk}}/issues/40706
[40709]: {{site.repo.dart.sdk}}/issues/40709
[ddc]: {{site.repo.dart.sdk}}/issues/38994
[normalized]: {{site.repo.dart.lang}}/blob/main/resources/type-system/normalization.md

## 2.7.1

* [The Dart SDK for macOS is now only available for x64][39810].

[39810]: {{site.repo.dart.sdk}}/issues/39810

## 2.7.0

### Language {:.no_toc}

* [Static extension members are accessible when imported with a prefix][671].

### Libraries {:.no_toc}

#### `dart:io`

* Added `IOOverrides.serverSocketBind` to aid in writing tests that wish to mock
  `ServerSocket.bind`.

## 2.6.0

### Language {:.no_toc}

* [Changed inference when using `Null` values in a `FutureOr` context][37985].
  Namely, constraints of the forms similar to `Null` <: `FutureOr<T>` now yield
  `Null` as the solution for `T`.

### Libraries {:.no_toc}

#### `dart:ffi`

* The API now makes use of static extension members. 
* Removed memory management `Pointer.allocate` and `Pointer.free`.
* `Pointer.offsetBy` was removed, use `cast` and `elementAt` instead.

[671]: {{site.repo.dart.lang}}/issues/671
[37985]: {{site.repo.dart.sdk}}/issues/37985

## 2.5.0

### Libraries {:.no_toc}

* Various methods and properties across various core libraries, which used
  to declare a return type of `List<int>`, were [updated to declare a return type
  of `Uint8List`][36900].

#### `dart:io`

* The `Cookie` class's constructor's `name` and `value` optional positional
  parameters [are now mandatory][37192].
* [The `Cookie` class's `name` and `value` setters now validate][37192]
  that the strings are made from the allowed character set and are not null.

### Tools {:.no_toc}

#### Pub

* Packages published to [pub.dev]({{site.pub}}) [can no longer contain git
  dependencies][36765].

[36900]: {{site.repo.dart.sdk}}/issues/36900
[37192]: {{site.repo.dart.sdk}}/issues/37192
[37192]: {{site.repo.dart.sdk}}/issues/37192
[36765]: {{site.repo.dart.sdk}}/issues/36765

## 2.4.0

### Language {:.no_toc}

* [Covariance of type variables used in super-interfaces is now enforced][35097]. 

### Libraries {:.no_toc}

#### `dart:isolate`

* `Isolate.resolvePackageUri` will always throw an `UnsupportedError` when
  compiled with dart2js or DDC.

#### `dart:async`

* [Fixed a bug in the `StreamIterator` class][36382] where `await for` allowed
  `null` as a stream.

[35097]: {{site.repo.dart.sdk}}/issues/35097
[36382]: {{site.repo.dart.sdk}}/issues/36382

## 2.2.0

### Libraries {:.no_toc}

#### `package:kernel`

* The `klass` getter on the `InstanceConstant` class in the
  Kernel AST API has been renamed to `classNode` for consistency.
* [Updated `Link` implementation][33966] to utilize true symbolic
  links instead of junctions on Windows.

[33966]: {{site.repo.dart.sdk}}/issues/33966

## 2.1.1

### Libraries {:.no_toc}

#### `dart:io`

* [Added to a closed `IOSink` now throws a `StateError`][29554].

[29554]: {{site.repo.dart.sdk}}/issues/29554

### Tools {:.no_toc}

#### Dart VM

* [Fixed a soundness hole when using `dart:mirrors`][35611] to reflectively
  invoke a method in an incorrect way that violates its static types.

[29554]: {{site.repo.dart.sdk}}/issues/29554
[35611]: {{site.repo.dart.sdk}}/issues/35611

## 2.1.0

### Language {:.no_toc}

* A number of static errors that should have been detected
  and reported were not supported in 2.0.0. These are reported now, which means
  existing incorrect code may show new errors:
  * [Mixins must correctly override their superclasses][34235].
  * [Implicit type arguments in extends clauses must satisfy the class bounds][34532].
  * [Instance members should shadow prefixes][34498].
  * [Constructor invocations must use valid syntax, even with optional `new`][34403].
  * [Type arguments to generic typedefs must satisfy their bounds][33308].
  * [Classes can't implement FutureOr][33744].
  * [Abstract methods may not unsoundly override a concrete method][32014].
  * [Constant constructors cannot redirect to non-constant constructors][34161].
  * [Setters with the same name as the enclosing class aren't allowed][34225].

### Tools {:.no_toc}

#### `dart2js`

* Duplicate keys in a const map are not allowed and produce a compile-time error.

[32014]: {{site.repo.dart.sdk}}/issues/32014
[33308]: {{site.repo.dart.sdk}}/issues/33308
[33744]: {{site.repo.dart.sdk}}/issues/33744
[34161]: {{site.repo.dart.sdk}}/issues/34161
[34225]: {{site.repo.dart.sdk}}/issues/34225
[34235]: {{site.repo.dart.sdk}}/issues/34235
[34403]: {{site.repo.dart.sdk}}/issues/34403
[34498]: {{site.repo.dart.sdk}}/issues/34498
[34532]: {{site.repo.dart.sdk}}/issues/34532

## 2.0.0

### Language {:.no_toc}

* Replaced the unsound optional static type system with a sound static type
  system using type inference and runtime checks, formerly called [strong mode].
* [Functions marked `async` now run synchronously][30345] until the first
  `await` statement.

### Libraries {:.no_toc}

* Renamed constants in the core libraries from `SCREAMING_CAPS` to `lowerCamelCase`.
* Added many new methods to core library classes that will need to be implemented
  if you implement the interfaces of these classes.
* `dart:isolate` and `dart:mirrors` are no longer supported when
  using Dart for the web.

### Tools {:.no_toc}

#### Pub

* Replaced pub's transformer-based build system with a [new build system][build system].

[30345]: {{site.repo.dart.sdk}}/issues/30345
[strong mode]: /guides/language/type-system
[build system]: {{site.repo.dart.org}}/build