---
title: "Announcing Dart 3.2"
description: "Improved language & developer experience, and an update on web apps & Wasm"
publishDate: 2023-11-15
author: mit-mit
image: images/1u5YRn1uMmXf94b2aPbcLRQ.png
category: announcements
tags:
  - dart
  - dartlang
layout: blog
---


By: [Kevin Moore](https://twitter.com/kevmoo) & [Michael Thomsen](https://medium.com/@mit.mit)

Today we’re announcing Dart 3.2, featuring a new language feature for non-null promotion of private final fields, improved developer experience with new interop capabilities, support for extensions in DevTools, and an update on our web roadmap including support for Wasm (aka WebAssembly).

<DashImage src="images/1u5YRn1uMmXf94b2aPbcLRQ.png" />


## Non-null promotion for private final fields

It’s been a few years since we introduced [sound null safety](https://medium.com/dartlang/announcing-dart-2-12-499a6e689c87) in Dart 2.12. With null safety, you can declare which types are nullable (may contain a value, or `null`) and which are non-nullable (always contain a value). Null safety combined with [flow analysis](https://dart.dev/null-safety/understanding-null-safety#flow-analysis) detects when nullable variables can be “promoted” to their safer, non-null types:

```dart
int definitelyInt(int? aNullableInt) {
  if (aNullableInt == null) {
    return 0;
  }
  // If flow analysis reaches this point, 
  // aNullableInt can safely promote to a non-null int.
  return aNullableInt; 
}
```


Type promotion has been a core part of null safety since Dart 2.12, but was limited to local variables. Fields or top-level variables couldn’t be promoted, such as in a case like this:

```dart
class Container {
  final int? _fillLevel;
  Container(this._fillLevel);
  check() {
    if (_fillLevel != null) {
      int i = _fillLevel; // Prior to Dart 3.2, causes an error.
    }
  }
}
```


This limitation was due to several complex cases where flow analysis could not safely determine when or how a field might change. In the case of field promotion on a class, for example, it could be an issue if a subclass overrides a field with a getter, which sometimes returns null.

In Dart 3.2, we’ve improved our flow analysis engine and are now able to type promote **private final fields**. Now, the code snippet above passes without errors. This leverages the understanding that for a private & final field, the value never changes after the initial assignment, so checking it just once is considered safe. Private final field promotion is available starting with Dart 3.2, and will be applied to projects that have a Dart SDK [lower bound](https://dart.dev/guides/language/evolution#language-versioning) of 3.2 or higher.

## New code analysis options in package:lints 3.0

Speaking of code analysis, we’ve also made a number of improvements to our standard code analysis rules in [package:lints](https://pub.dev/packages/lints). This package contains the default & recommended set of static analysis rules that comes with any new project created by `dart create` or `flutter create` (via [package:flutter_lints](https://pub.dev/packages/flutter_lints) — an extension of package:lints).

A new major version of this lint set, version 3.0, is now available. This revision added six lints to the core set and two lints to the recommended set. It features lints for validating pubspec URLs, validating that collection methods are invoked with the correct arguments, and more. For the full list of changes, check out the [changelog](https://github.com/dart-lang/lints/blob/main/CHANGELOG.md#300). Version 3.0 will be the default for new projects in the coming release. For existing projects, you can [upgrade now](https://github.com/dart-lang/lints#upgrading-to-the-latest-lints).

## Dart interoperability update

Multi-platform support across a [wide range of platforms](https://dart.dev/overview#platform) has always been a core principle of Dart. But even though a line of Dart code can run unchanged across all those platforms, large apps still often have a need to interop with existing code. That could mean code from older projects, or APIs available in other libraries or system APIs. We’ve made a number of investments in this area, starting with FFI for [interop with native C APIs](https://dart.dev/guides/libraries/c-interop). We’re currently working on expanding this to support interop with [Java and Kotlin](https://dart.dev/guides/libraries/java-interop) and [Objective C and Swift](https://dart.dev/guides/libraries/objective-c-interop). For exciting updates on JS interop, check out the Dart web section further down.

As of Dart 3.2, we’ve made a number of improvements to native interop:

* We’ve introduced the [`NativeCallable.isolateLocal`](https://api.dart.dev/stable/dart-ffi/NativeCallable/NativeCallable.isolateLocal.html) constructor for C FFI, which creates a C function pointer from an arbitrary Dart function. This is an extension of functionality provided by [`Pointer.fromFunction`](https://api.dart.dev/stable/dart-ffi/Pointer/fromFunction.html), which can only create function pointers from top-level functions.

* We’ve updated the Objective-C bindings generator to make use of [`NativeCallable.listener`](https://api.dart.dev/stable/dart-ffi/NativeCallable/NativeCallable.listener.html), which we added in Dart 3.1. The generator can now automatically handle APIs which contain asynchronous callbacks, like [Core Motion](https://developer.apple.com/documentation/coremotion), for example. Such APIs previously required writing some of the bindings code by hand.

* We’ve continued to improve [package:jnigen](https://dart.dev/guides/libraries/java-interop) for Java and Kotlin interop. This allowed us to migrate [package:cronet_http](https://pub.dev/packages/cronet_http) — a wrapper around Android’s Cronet HTTP client — away from handwritten bindings code to an automatically [generated](https://github.com/dart-lang/http/blob/master/pkgs/cronet_http/jnigen.yaml) wrapper.

* We’ve made significant progress on the [Native Assets](https://github.com/dart-lang/sdk/issues/50565) feature, which aims to resolve a number of issues associated with the distribution of Dart packages that depend on native code. It does so by providing uniform hooks for integrating with various build systems involved in building Flutter and standalone Dart applications. For a preview, check out the [documentation](http://dart.dev/guides/libraries/c-interop#native-assets).

## DevTools extensions for Dart packages

Dart [DevTools](https://dart.dev/tools/dart-devtools) is a suite of debugging and performance tools that supports both pure-Dart and Flutter apps. In Dart 3.2 & Flutter 3.16 [we’re announcing](https://medium.com/p/c8bc1aaf8e5f/) a new [extensions framework](https://pub.dev/packages/devtools_extensions) which enables package authors to build custom tooling for their package, surfaced directly in DevTools. This allows pub.dev packages that contain frameworks to offer custom tools specific to their use cases. For example, the authors of [Serverpod](https://pub.dev/packages/serverpod) have been hard at work building developer tools for their package and are excited to be shipping a DevTools extension in their upcoming [1.2 release](https://github.com/orgs/serverpod/projects/4).

<DashImage src="images/0N6ZSt1McXO_opQU7.png" alt="*A DevTools extension planned for the upcoming ServerPod 1.2 release*" caption="*A DevTools extension planned for the upcoming ServerPod 1.2 release*" />


## Dart web and Wasm update

Wasm (also known as [WebAssembly](https://webassembly.org/)) is an exciting new instruction format for web browsers, which provides a portable, platform-neutral, binary code format for execution in modern browsers. High-level managed languages like Dart use garbage collection, which is being added to the Wasm standard. As of Chrome 119, [garbage collection support for Wasm](https://developer.chrome.com/blog/wasmgc/) (known as Wasm-GC) is enabled by default. Wasm-GC support is also coming in Firefox 120, their next stable release. So what’s the status with Dart, Flutter, and Wasm-GC?

The Dart-to-Wasm compiler is almost feature complete. The team is very happy with performance and compatibility. Our focus now is on edge cases to make sure our output is fast across a broad range of scenarios.

For Flutter web, we’ve completed a new “Skwasm” rendering engine. To maximize performance, Swasm connects the compiled application code directly to a custom [CanvasKit Wasm module](https://skia.org/docs/user/modules/canvaskit/) with a wasm-to-wasm binding. It’s also the first iteration of multi-threaded rendering support for Flutter web, which further improves frame times.

There are still a few things left before Flutter web with Wasm is ready to graduate out of its current experimental status:

* **Dual compile**: Generating both Wasm and JavaScript outputs and enabling feature detection at runtime to support browsers with and without Wasm-GC support.

* **Modern JavaScript-interoperability**: A new JS interop mechanism based on [extension types](https://github.com/dart-lang/language/issues/2727) to enable concise, type-safe calling between Dart code, browser APIs, and JS libraries, when targeting JavaScript and Wasm.

* **Browser APIs with Wasm support**: A new package:web, replacing dart:html (and related libraries), based on the modern JS interop mechanism. This will provide easy access to browser APIs with support on both JS and Wasm targets.

We are starting to migrate a number of internal projects to package:web and the new JS interop mechanism, and expect to have more updates in the next stable release. In the meantime, you can get the latest details at our [Support for WebAssembly](https://flutter.dev/wasm) page.

## Closing

That’s all we have for today. Dart 3.2 is available now from [dart.dev](https://dart.dev/get-dart), or as part of today’s [Flutter 3.16](https://medium.com/flutter/whats-new-in-flutter-3-16-dba6cb1015d1) release. Until next time, have fun with Dart!