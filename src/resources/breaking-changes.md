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

[breaking change policy]: https://github.com/dart-lang/sdk/blob/main/docs/process/breaking-changes.md
[changelog]: https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md
[sdk]: /get-dart
[language version]: /guides/language/evolution#language-versioning
[Dart announce]: {{site.announce}}

## Not yet released to stable

### Language
{: .no_toc}

* **Language versioned**: [Changed the split point for refutable patterns][53167]
  to the top level pattern so type promotion in if-case statements is consistent
  regardless of whether the scrutinee might throw an exception.

### Libraries
{: .no_toc}

#### `dart:convert`

* [Changed return types of `utf8.encode()` and `Utf8Codec.encode()`][52801]
 from `List<int>` to `Uint8List`.

#### `dart:developer`

* **Deprecated**: The `Service.getIsolateID` method.

#### `dart:io`

* [Eliminated trailing whitespace from HTTP headers][53005].

#### `dart:js_interop`

* **Experimental** **Removed**: `JSNumber.toDart` in favor of `toDartDouble` and
  `toDartInt`.
* **Experimental** **Removed**: `Object.toJS` in favor of `Object.toJSBox.`

### Tools
{: .no_toc}

#### Dart Dev Compiler (DDC) and Dart2js

* [Added interceptors for JavaScript `Symbol` and `BigInt` types][53106];
  they should no longer be used with `package:js` classes.


[53167]: https://github.com/dart-lang/sdk/issues/53167
[52801]: https://github.com/dart-lang/sdk/issues/52801
[53005]: https://github.com/dart-lang/sdk/issues/53005
[53106]: https://github.com/dart-lang/sdk/issues/53106


{% comment %}
Create new section from these headers for each release.
If no changes exist in a section (e.g. Language, `dart:async`, etc.),
don't include the section header.

## Released in x.x.x

### Language
{: .no_toc}

### Libraries
{: .no_toc}

#### (`dart:core`, `package:js`, etc)

### Tools
{: .no_toc}

#### (Dart VM, Pub, Linter, `dart2js`, etc)
{% endcomment %}

## Released in 3.1.0

### Libraries
{: .no_toc}

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

[52334]: https://github.com/dart-lang/sdk/issues/52334
[51486]: https://github.com/dart-lang/sdk/issues/51486
[52027]: https://github.com/dart-lang/sdk/issues/52027

## Released in 3.0.0

{{site.alert.tip}}
  The [Dart 3.0 migration guide][dart3] covers the complete details
  on all the changes in this section.
{{site.alert.end}}

### Language
{: .no_toc}

* **Language versioned**: Changed interpretation of [switch cases] from constant
  expressions to patterns.

* **Language versioned**: Class declarations from libraries that have been upgraded
  to Dart 3.0 [can no longer be used as mixins by default][mixin class].

* [Dart reports a compile-time error][50902] if a `continue` statement targets
  a [label] that is not a loop (`for`, `do` and `while` statements) or a `switch`
  member.

### Libraries
{: .no_toc}

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
[switch cases]: https://dart.dev/language/branches#switch
[mixin class]: https://dart.dev/language/mixins#class-mixin-or-mixin-class
[label]: https://dart.dev/language/branches#switch
[50902]: https://github.com/dart-lang/sdk/issues/50902
[collection]: /resources/dart-3-migration#dartcollection
[49529]: https://github.com/dart-lang/sdk/issues/49529
[`DeferredLibrary`]: https://api.dart.dev/stable/2.18.4/dart-async/DeferredLibrary-class.html
[`deferred as`]: https://dart.dev/guides/language/language-tour#deferred-loading
[`MAX_USER_TAGS`]: https://api.dart.dev/stable/dart-developer/UserTag/MAX_USER_TAGS-constant.html
[`maxUserTags`]: https://api.dart.dev/beta/2.19.0-255.2.beta/dart-developer/UserTag/maxUserTags-constant.html
[50231]: https://github.com/dart-lang/sdk/issues/50231
[`Metrics`]: https://api.dart.dev/stable/2.18.2/dart-developer/Metrics-class.html
[`Metric`]: https://api.dart.dev/stable/2.18.2/dart-developer/Metric-class.html
[`Counter`]: https://api.dart.dev/stable/2.18.2/dart-developer/Counter-class.html
[`Gauge`]: https://api.dart.dev/stable/2.18.2/dart-developer/Gauge-class.html
[49536]: https://github.com/dart-lang/sdk/issues/49536
[51035]: https://github.com/dart-lang/sdk/issues/51035


## Released in 2.19.0

### Language
{: .no_toc}

* [Flagged additional code as unreachable][49635] due to types `Null` and `Never`.
* [Don't delegate inaccessible private names to `noSuchMethod`][49687].
* [Report a compile-time error][50383] for all cyclic dependencies during
  top-level type inference.

### Libraries
{: .no_toc}

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

[49635]: https://github.com/dart-lang/sdk/issues/49635
[49687]: https://github.com/dart-lang/sdk/issues/49687
[50383]: https://github.com/dart-lang/sdk/issues/50383
[34233]: https://github.com/dart-lang/sdk/issues/34233
[`ServiceExtensionResponse`]: https://api.dart.dev/stable/2.17.6/dart-developer/ServiceExtensionResponse-class.html#constants
[49935]: https://github.com/dart-lang/sdk/issues/49935
[49305]: https://github.com/dart-lang/sdk/issues/49305
[49647]: https://github.com/dart-lang/sdk/issues/49647
[49878]: https://github.com/dart-lang/sdk/issues/49878
[`SendPort.send`]: https://api.dart.dev/stable/dart-isolate/SendPort/send.html
[34233]: https://github.com/dart-lang/sdk/issues/34233
[49473]: https://github.com/dart-lang/sdk/issues/49473
[48730]: https://github.com/dart-lang/sdk/issues/48730
[49941]: https://github.com/dart-lang/sdk/issues/49941
[49350]: https://github.com/dart-lang/sdk/issues/49350


## Released in 2.18.0

### Language
{: .no_toc}

* [Removed support for mixin of classes that don't extend `Object`][48167].

### Libraries
{: .no_toc}

#### `dart:io`

* [Changed the `uri` property of `RedirectException` in `dart:io` to be nullable][49045].
* [Removed constants in `dart:io` networking APIs following the `SCREAMING_CAPS`
  convention][34218].
* [The Dart VM no longer automatically restores the initial terminal settings][45630]
  upon exit.

### Tools
{: .no_toc}

* [Fully discontinued the `.packages` file][48272]. 

#### Dart command line

* [Removed the standalone `dart2js` and `dartdevc` tools][46100].
* [Removed the standalone `dartanalyzer` tool][46100].

[48167]: https://github.com/dart-lang/sdk/issues/48167
[49045]: https://github.com/dart-lang/sdk/issues/49045
[34218]: https://github.com/dart-lang/sdk/issues/34218
[45630]: https://github.com/dart-lang/sdk/issues/45630
[48272]: https://github.com/dart-lang/sdk/issues/48272
[46100]: https://github.com/dart-lang/sdk/issues/46100

## Released in 2.17.0

### Libraries
{: .no_toc}

#### `dart:io`

* [Added new `connectionFactory` property to `HttpClient`][47887].
* [Added new `keyLog` property to `HttpClient`][48093], which allows TLS keys to
  be logged for debugging purposes.
* [Removed constants in `dart:io` following the `SCREAMING_CAPS`][34218]
* [Added a new `allowLegacyUnsafeRenegotiation` property to `SecurityContext`][48513],
  which allows TLS renegotiation for client secure sockets.

### Tools
{: .no_toc}

#### Dart command line

* **Deprecated**: [Deprecated the standalone `dart2js` tool][46100].
* **Deprecated**: [Deprecated the standalone `dartdevc` tool][46100].
* **Removed**: [Removed the standalone `dartdoc` tool][46100].

[47887]: https://github.com/dart-lang/sdk/issues/47887
[48093]: https://github.com/dart-lang/sdk/issues/48093
[34218]: https://github.com/dart-lang/sdk/issues/34218
[48513]: https://github.com/dart-lang/sdk/issues/48513
[46100]: https://github.com/dart-lang/sdk/issues/46100

## Released in 2.16.0

### Libraries
{: .no_toc}

#### `dart:io`

* On Windows, [`Directory.rename` will no longer delete a directory][47653] if
  `newPath` specifies one. Instead, a `FileSystemException` will be thrown.
* **Removed**: [Removed the `Platform.packageRoot` API][47769].

#### `dart:isolate`

* **Removed**: [Removed the `Isolate.packageRoot` API][47769].

### Tools 
{: .no_toc}

#### Dart command line

* **Deprecated**: [Deprecated the standalone `dartanalyzer` tool][46100].
* **Deprecated**: [Deprecated the standalone `dartdoc` tool][46100].
* **Removed**: [Removed the deprecated standalone `pub` tool][46100].

[47653]: https://github.com/dart-lang/sdk/issues/47653
[47769]: https://github.com/dart-lang/sdk/issues/47769
[46100]: https://github.com/dart-lang/sdk/issues/46100

## Released in 2.15.0

### Libraries
{: .no_toc}

#### `dart:io`

* [Updated the `SecurityContext` class][46875] to set the minimum
  TLS protocol version to TLS1_2_VERSION (1.2) instead of TLS1_VERSION.

#### `dart:web_sql`

* [Completely deleted the `dart:web_sql` library][46316].

#### `dart:html`

* [Removed `window.openDatabase`][46316] (related to `dart:web_sql` deletion above).

### Tools
{: .no_toc}

#### Dart command line

* [Removed the standalone `dart2native` tool][46100].
* Removed the standalone `dartfmt` tool.

#### Dart VM

* [Removed support for `dart-ext:`-style native extensions][45451]
* [Grouped isolates spawned via the `Isolate.spawn()` API][46754] to operate on the
  same managed heap, and therefore share various VM-internal data structures.

[46875]: https://github.com/dart-lang/sdk/issues/46875
[46316]: https://github.com/dart-lang/sdk/issues/46316
[45451]: https://github.com/dart-lang/sdk/issues/45451
[46754]: https://github.com/dart-lang/sdk/issues/46754

## Released in 2.14.0

### Libraries
{: .no_toc}

#### `dart:io`

* The setter callbacks `.authenticate` and `.authenticateProxy` in `HttpClient`
  must now accept a nullable `realm` argument (for pre-migrated null safe code).

#### `dart:typed_data`

* Most types exposed by this library [can no longer be extended, implemented or
  mixed-in][45115].

### Tools
{: .no_toc}

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

[45115]: https://github.com/dart-lang/sdk/issues/45115
[45071]: https://github.com/dart-lang/sdk/issues/45071
[46545]: https://github.com/dart-lang/sdk/issues/46545
[44154]: https://github.com/dart-lang/sdk/issues/44154


## Released in 2.13.0

### Libraries
{: .no_toc}

#### `package:js`

* [No longer valid][44211] to use a `String` that matches an `@Native` annotation
  in an `@JS()` annotation for a non-anonymous JS interop class.

[44211]: https://github.com/dart-lang/sdk/issues/44211

## Released in 2.12.0

### Language
{: .no_toc}

* [Null safety] is now enabled by default in all code that
  has not opted out.
* [Fixed an implementation bug][44660] where `this` would sometimes undergo type
  promotion in extensions.

### Libraries
{: .no_toc}

#### `dart:ffi`

* [Deprecated invocations with a generic `T`][44621] of `sizeOf<T>`,
  `Pointer<T>.elementAt()`, `Pointer<T extends Struct>.ref`, and
  `Pointer<T extends Struct>[]`
* [Deprecated `allocate` in `package:ffi`][44621], as it will no longer be
  able to invoke `sizeOf<T>` generically.
* [Deprecated subtypes of `Struct` without any native member][44622].

### Tools
{: .no_toc}

#### Dart VM

* [`Dart_WeakPersistentHandle` no longer auto-deletes itself][42312] when the
  referenced object is garbage collected to avoid race conditions.
* [Renamed `Dart_WeakPersistentHandleFinalizer` to `Dart_HandleFinalizer`][42312] 
  and removed its `handle` argument.

#### Pub 

* [The Dart SDK constraint is now **required** in `pubspec.yaml`][44072].

[Null safety]: https://dart.dev/null-safety/understanding-null-safety
[44660]: https://github.com/dart-lang/sdk/issues/44660
[44621]: https://github.com/dart-lang/sdk/issues/44621
[42312]: https://github.com/dart-lang/sdk/issues/42312
[44622]: https://github.com/dart-lang/sdk/issues/44622
[44072]: https://github.com/dart-lang/sdk/issues/44072

## Released in 2.10.0

### Tools
{: .no_toc}

#### Dart VM

* [Renamed `dart_api_dl.cc` to `dart_api_dl.c`][42982] and changed to a pure C file.

[42982]: https://github.com/dart-lang/sdk/issues/42982

## Released in 2.9.0

### Libraries
{: .no_toc}

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

### Tools
{: .no_toc}

#### Dart VM

* When printing a string using the `print` function, [the default implementation
  will print any unpaired surrogates in the string as replacement characters][41100]
  (`U+FFFD`).
* The `Dart_StringToUTF8` function in the Dart API [will convert unpaired
  surrogates into replacement characters][41100].


[41100]: https://github.com/dart-lang/sdk/issues/41100
[whatwg encoding standard]: https://encoding.spec.whatwg.org/#utf-8-decoder
[42714]: https://github.com/dart-lang/sdk/issues/42714

## Released in 2.8.1

### Language
{: .no_toc}

* [Fixed an implementation bug][40675] where local variable inference would
  incorrectly use the promoted type of a type variable.
* [Fixed an implementation bug][41362] surrounding the clauses
  `implements Function`, `extends Function`, or `with Function` no longer having
  an effect since Dart 2.0.0.

### Libraries
{: .no_toc}

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

### Tools
{: .no_toc}

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

[40675]: https://github.com/dart-lang/sdk/issues/40675
[41362]: https://github.com/dart-lang/sdk/issues/41362
[40676]: https://github.com/dart-lang/sdk/issues/40676
[40681]: https://github.com/dart-lang/sdk/issues/40681
[40683]: https://github.com/dart-lang/sdk/issues/40683
[40130]: https://github.com/dart-lang/sdk/issues/40130
[40674]: https://github.com/dart-lang/sdk/issues/40674
[40678]: https://github.com/dart-lang/sdk/issues/40678
[33501]: https://github.com/dart-lang/sdk/issues/33501
[40702]: https://github.com/dart-lang/sdk/issues/40702
[40483]: https://github.com/dart-lang/sdk/issues/40483
[40706]: https://github.com/dart-lang/sdk/issues/40706
[40709]: https://github.com/dart-lang/sdk/issues/40709
[ddc]: https://github.com/dart-lang/sdk/issues/38994
[normalized]: https://github.com/dart-lang/language/blob/main/resources/type-system/normalization.md

## Released in 2.7.1

* [The Dart SDK for macOS is now only available for x64][39810].

[39810]: https://github.com/dart-lang/sdk/issues/39810

## Released in 2.7.0

### Language
{: .no_toc}

* [Static extension members are accessible when imported with a prefix][671].

### Libraries
{: .no_toc}

#### `dart:io`

* Added `IOOverrides.serverSocketBind` to aid in writing tests that wish to mock
  `ServerSocket.bind`.

## Released in 2.6.0

### Language
{: .no_toc}

* [Changed inference when using `Null` values in a `FutureOr` context][37985].
  Namely, constraints of the forms similar to `Null` <: `FutureOr<T>` now yield
  `Null` as the solution for `T`.

### Libraries
{: .no_toc}

#### `dart:ffi`

* The API now makes use of static extension members. 
* Removed memory management `Pointer.allocate` and `Pointer.free`.
* `Pointer.offsetBy` was removed, use `cast` and `elementAt` instead.

[671]: https://github.com/dart-lang/language/issues/671
[37985]: https://github.com/dart-lang/sdk/issues/37985

## Released in 2.5.0

### Libraries
{: .no_toc}

* Various methods and properties across various core libraries, which used
  to declare a return type of `List<int>`, were [updated to declare a return type
  of `Uint8List`][36900].

#### `dart:io`

* The `Cookie` class's constructor's `name` and `value` optional positional
  parameters [are now mandatory][37192].
* [The `Cookie` class's `name` and `value` setters now validate][37192]
  that the strings are made from the allowed character set and are not null.

### Tools
{: .no_toc}

#### Pub

* Packages published to [pub.dev](https://pub.dev) [can no longer contain git
  dependencies][36765].

[36900]: https://github.com/dart-lang/sdk/issues/36900
[37192]: https://github.com/dart-lang/sdk/issues/37192
[37192]: https://github.com/dart-lang/sdk/issues/37192
[36765]: https://github.com/dart-lang/sdk/issues/36765

## Released in 2.4.0

### Language
{: .no_toc}

* [Covariance of type variables used in super-interfaces is now enforced][35097]. 

### Libraries
{: .no_toc}

#### `dart:isolate`

* `Isolate.resolvePackageUri` will always throw an `UnsupportedError` when
  compiled with dart2js or DDC.

#### `dart:async`

* [Fixed a bug in the `StreamIterator` class][36382] where `await for` allowed
  `null` as a stream.

[35097]: https://github.com/dart-lang/sdk/issues/35097
[36382]: https://github.com/dart-lang/sdk/issues/36382

## Released in 2.2.0

### Libraries
{: .no_toc}

#### `package:kernel`

* The `klass` getter on the `InstanceConstant` class in the
  Kernel AST API has been renamed to `classNode` for consistency.
* [Updated `Link` implementation][33966] to utilize true symbolic
  links instead of junctions on Windows.

[33966]: https://github.com/dart-lang/sdk/issues/33966

## Released in 2.1.1

### Libraries
{: .no_toc}

#### `dart:io`

* [Added to a closed `IOSink` now throws a `StateError`][29554].

[29554]: https://github.com/dart-lang/sdk/issues/29554

### Tools
{: .no_toc}

#### Dart VM

* [Fixed a soundness hole when using `dart:mirrors`][35611] to reflectively
  invoke a method in an incorrect way that violates its static types.

[29554]: https://github.com/dart-lang/sdk/issues/29554
[35611]: https://github.com/dart-lang/sdk/issues/35611

## Released in 2.1.0

### Language
{: .no_toc}

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

### Tools
{: .no_toc}

#### `dart2js`

* Duplicate keys in a const map are not allowed and produce a compile-time error.

[32014]: https://github.com/dart-lang/sdk/issues/32014
[33308]: https://github.com/dart-lang/sdk/issues/33308
[33744]: https://github.com/dart-lang/sdk/issues/33744
[34161]: https://github.com/dart-lang/sdk/issues/34161
[34225]: https://github.com/dart-lang/sdk/issues/34225
[34235]: https://github.com/dart-lang/sdk/issues/34235
[34403]: https://github.com/dart-lang/sdk/issues/34403
[34498]: https://github.com/dart-lang/sdk/issues/34498
[34532]: https://github.com/dart-lang/sdk/issues/34532

## Released in 2.0.0

### Language
{: .no_toc}

* Replaced the unsound optional static type system with a sound static type
  system using type inference and runtime checks, formerly called [strong mode].
* [Functions marked `async` now run synchronously][30345] until the first
  `await` statement.

### Libraries
{: .no_toc}

* Renamed constants in the core libraries from `SCREAMING_CAPS` to `lowerCamelCase`.
* Added many new methods to core library classes that will need to be implemented
  if you implement the interfaces of these classes.
* `dart:isolate` and `dart:mirrors` are no longer supported when
  using Dart for the web.

### Tools
{: .no_toc}

#### Pub

* Replaced pub's transformer-based build system with a [new build system][build system].

[30345]: https://github.com/dart-lang/sdk/issues/30345
[strong mode]: /guides/language/type-system
[build system]: https://github.com/dart-lang/build