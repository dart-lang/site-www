---
title: "New in Dart 3.3: Extension Types, JavaScript Interop, and More"
description: "Dart 3.3 has landed, and it’s a game-changer for performance and cross-platform development! Get ready to supercharge your apps with…"
publishDate: 2024-02-15
author: "kevmoo"
image: images/1p4TBp0I66rJTq0LvnSuE7g.png
category: other
tags:
  - dart-programming-language
  - webassembly
  - javascript
---


![](images/1p4TBp0I66rJTq0LvnSuE7g.png)

**Dart 3.3 has landed, and it’s a game-changer for performance and cross-platform development!** Get ready to supercharge your apps with **Extension Types**, revolutionizing performance optimization and how you interact with native code. Plus, our revamped **JavaScript interop** model introduces robust type safety and a developer-friendly way to tap into the power of the web platform. All this paves the way for **WebAssembly** support. Oh, and **Google AI in your Dart apps**? Yes, please! It’s all here in Dart 3.3. Let’s dive in!

## Introducing Extension Types

Extension types introduce zero-cost wrappers for types. Use them to optimize performance-sensitive code, especially when interoperating with host platforms. Extension types provide the convenience of custom types with specific members while eliminating the typical wrapper allocation overhead.

```dart
extension type Wrapper(int i) {
  void showValue() {
    print('my value is $i');
  }
}

void main() {
  final wrapper = Wrapper(42);
  wrapper.showValue(); // Prints 'my value is 42'
}
```


The previous example defines **`Wrapper`** as an extension type, but uses it like a trivial Dart type. You can instantiate it and invoke functions. The key difference that Dart compiles it as a normal Dart **`int`**. Extension types allow the convenience of creating a type with unique members without the indirection cost of allocating a typical wrapper type. So, while the [extension members](https://dart.dev/language/extension-methods) feature (available in Dart since 2.7) allows adding functions and properties to an existing type, the extension type feature can do the same, *and also* allows defining a new API that hides the underlying representation.

This is particularly useful for interoperability with host platforms. Native types can be used directly without the cost of creating wrappers and the associated indirection while still providing a clean, production Dart API. Learn more in the [new documentation on extension types](http://dart.dev/language/extension-types).

## Evolving JavaScript Interop

Dart 3.3 introduces a new model for interoperating with JavaScript libraries and the web. It starts with a new set of APIs for interacting with JavaScript: the [dart:js_interop](https://api.dart.dev/dart-js_interop/dart-js_interop-library.html) library. Now Dart developers have access to a typed API for interacting with JavaScript. This API clearly defines the boundary between the two languages with static enforcement. This eliminates an entire class of issues *before* compile time. In addition to new APIs to access JavaScript code, Dart now includes a new model for representing JavaScript types in Dart using extension types.

```dart
import 'dart:js_interop';

/// Represents the `console` browser API.
extension type MyConsole(JSObject _) implements JSObject {
  external void log(JSAny? value);
  external void debug(JSAny? value);
  external void info(JSAny? value);
  external void warn(JSAny? value);
}
```


The syntax, based on extension types, allows for more expression and soundness than extension members. This simplifies leveraging JavaScript APIs from Dart. Learn more in the [new documentation on JS interop](https://dart.dev/interop/js-interop).

## Improving browser libraries

Since version 1.0, the Dart SDK has included a comprehensive set of browser libraries. These include the core [dart:html](https://api.dart.dev/dart-html/dart-html-library.html) library along with libraries for SVG, WebGL, and others.

The improved JavaScript interop model offered the chance to reimagine these libraries. Going forward, our browser library support will focus on [package:web](https://pub.dev/packages/web). This simplifies versioning, accelerates updates, and aligns with [MDN](https://developer.mozilla.org/) resources.

This chain of improvements leads to the next big thing: compiling Dart to [WebAssembly](https://webassembly.org/).

## Start today to enable a WebAssembly future

With Dart 3.3, package and application authors can lay the groundwork for web applications compiled to [WebAssembly](https://webassembly.org/). While WebAssembly support in Flutter Web remains experimental, the team is working hard to stabilize the implementation. To run Flutter applications on the web using WebAssembly, you need to migrate all code — from the application and all dependencies — to use the new JavaScript Interop mechanism and the [package:web](https://pub.dev/packages/web). The legacy JavaScript and browser libraries remain unchanged and supported for compiling to JavaScript code. However, compiling to WebAssembly requires a migration.

We’ve created a[ migration guide](https://dart.dev/go/package-web) to help authors start including Wasm. We hope that the most popular packages support Wasm by the time we include it in a stable release.

## One more thing: Introducing the Google AI Dart SDK

Google has released the Google AI Dart SDK to beta. You can build generative AI features into your Dart or Flutter app. These apps use Gemini, Google’s latest family of AI models. Take a look at the [package:google_generative_ai](https://pub.dev/packages/google_generative_ai). Learn how to build with the Google AI Dart SDK in [this blog post](https://medium.com/flutter/harness-gemini-in-your-dart-and-flutter-apps-00573e560381) or jump straight into the [quickstart](https://ai.google.dev/tutorials/dart_quickstart).

![](images/00DiCLVhk_ipZIHKd.png)