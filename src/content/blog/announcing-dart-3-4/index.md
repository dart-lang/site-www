---
title: "Announcing Dart 3.4"
description: "Dart 3.4 is out today! This release showcases the joint efforts of Dart and Flutter together in the Flutter 3.22 / Dart 3.4 / IO24 post, so…"
publishDate: 2024-05-14
author: mit-mit
image: images/0hAcsCFLU0Ze7pej6.png
category: announcements
tags:
  - dart
  - dartlang
  - wasm
  - webassembly
layout: blog
---


Dart 3.4 is out today! This release showcases the joint efforts of Dart and Flutter together in the [Flutter 3.22 / Dart 3.4 / IO24](https://medium.com/flutter/io24-5e211f708a37) post, so make sure to get the full scoop there. This post introduces our support for WebAssembly, and then details one of the major roadmap items for the Dart language this year: *macros.*

<DashImage src="images/0hAcsCFLU0Ze7pej6.png" />


## WebAssembly updates

Today, we’re delighted to announce complete support for WebAssembly (Wasm) is available for [Flutter Web apps](https://docs.flutter.dev/platform-integration/web/wasm) with the latest Flutter 3.22 stable release!

This has been a multi-year investment across Dart & Flutter. If you’ve been following the developments, you’ve seen our incremental developments:

* Standardizing the [WasmGC](https://developer.chrome.com/blog/wasmgc/) proposal,

* Adding a brand new Dart compiler backend to generate WasmGC code, and

* [Revamping](https://dart.dev/interop/js-interop) our web and JavaScript interop offerings to best support Wasm.

We’ll continue to invest in WebAssembly. Our next effort will enable full support for Wasm in pure Dart apps, and completing a few missing features (e.g. deferred loading). The end-to-end tooling for Wasm compilation in Dart is still under development, but you can [try the preview](http://dart.dev/web/wasm) in stable now with some temporary steps. Later, we also hope to support Wasm in Dart [outside of JS-environments](https://github.com/dart-lang/sdk/issues/53884), such as standard Wasm run-times like wasmtime and wasmer.

## Dart macros: Raising the development abstraction level

We’ve invested many years into designing the Dart macros system. To improve the development experience in Dart, macros provide a metaprogramming solution, like code generation. This solution is built into the Dart language to give developers maximum performance, efficiency, and productivity. Now, we’re ready to offer a preview of this experience!

A long standing pain point for Dart developers has been the trivial yet tedious pattern of serializing and deserializing JSON data. Crafting a reusable, sufficiently powerful solution is a challenge in Dart, as it doesn’t support runtime reflection for performance reasons. As an alternative, we’ve relied on code generation solutions like [`JsonSerializable`](https://docs.flutter.dev/data-and-backend/serialization/json#serializing-json-using-code-generation-libraries). These depend on external tools that run before the code itself, complicating the developer experience.

Today, we’re announcing a preview of a radical new approach for JSON serialization and deserialization: the [`JsonCodable`](https://dart.dev/go/json-codable) macro.

A macro is a type of code that generates *more* code through introspecting *other* code at compile time. For example, here’s a Dart class Vehicle with the new JsonCodable macro applied:

```dart
@JsonCodable()
class Vehicle {
  final String description;
  final int wheels;
  Vehicle(this.description, this.wheels);
}
void main() {
  final jsonString = Vehicle('bicycle', 2).toJson();
  print('Vehicle serialized: $jsonString');
}
```


So, how does it work? Where did the `toJson()` method (and the companion `fromJson()` constructor) come from? This is an experimental implementation of our new macro system designed to simplify developer experience. When the Dart compiler sees the `@JsonCodable()` annotation, it immediately locates the definition of the JsonCodable macro in real time and starts executing it. This causes the macro to:

1. Create a new “[augmentation class](https://github.com/dart-lang/language/blob/main/working/augmentation-libraries/feature-specification.md)”; a new language construct which enables adding new declarations to existing classes.

1. Read the developer’s definition of the `Vehicle` class to determine it has two fields, `description` and `wheels`.

1. Add a new `toJson` method signature to the augmentation class.

1. Fill in the body of the `toJson` method to handle the serialization of the description and wheels fields.

All this happens without delay. The integrated experience supports our existing developer workflows, such as hot reload, as this screencast illustrates:

<DashImage src="images/0aOAKYwKdjXURuZN9.gif" alt="Screencast showing the experience of using a macro: Initially no toJson code completion exists, but after adding [@JsonCodable](http://twitter.com/JsonCodable) to the class, the toJson code completion shows up immediately." caption="Screencast showing the experience of using a macro: Initially no toJson code completion exists, but after adding [@JsonCodable](http://twitter.com/JsonCodable) to the class, the toJson code completion shows up immediately." />


## Long term macro goals

The eventual goal is to enable the community to create their own macros. This raises the abstraction level of Dart programming. Take data classes, for example, the [highest voted](https://github.com/dart-lang/language/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc) Dart language feature. We looked at adding built-in support for data classes in Dart, but learned that the opinions varied significantly on what such a construct should support to set a standard ourselves. Should the fields be `immutable`? Should it support equals? What about `hashCode`? Maybe `toString` too? We concluded that supporting a macro system would be the better approach. The community can create their own kinds of abstractions, allowing for more scalable experimentation and variety.

Designing and implementing such a powerful macro system is a substantial undertaking. We’re determined to do it in a way that doesn’t have a detrimental performance impact on core Dart developer use cases, such as code assistance and completions, code analysis, and hot reload. With that in mind, we’re taking a staged approach:

* In today’s release, we’re making a preview of a single macro, `JsonCodable`, available so users can start familiarizing themselves with the developer experience of using a macro.

* If the roll-out of this macro goes well, then we hope to graduate the JSON macro to stable in a later release.

* Concurrently, we’re working on completing the design and implementation of the underlying macro system. Once we feel confident in its performance and stability, the eventual goal will be to enable the Dart developer community to define their own macros.

A lot of work remains to complete these stages. In the meantime, you can read the documentation to learn more about [the Dart macro system](https://dart.dev/go/macros), and try out a preview of [the JsonCodable macro](https://dart.dev/go/json-codable) today.

## Other improvements

As always, this release contains all of the continuous developments that go into providing the best version of Dart possible. In this release, we made the following improvements:

* Resolved over 50% of analyzer code completion bugs. (Please keep filing [issues](https://github.com/dart-lang/sdk/labels/analyzer-completion-correctness)!)

* Improved the alignment of the type analysis of conditional expressions, if-null expressions, and switch expressions with the language spec ([changelog](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#language-1)).

* Removed incomplete and inconsistent tooling from the dart:cli library to pay down technical debt in the Dart VM.

* Addressed a handful of inadequacies to improve the new *`*dart:js_interop` library.

Check out the [Changelog](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#340) for the full story! Don’t forget to read the joint [Dart and Flutter blog post](https://medium.com/flutter/io24-5e211f708a37) for this release for the full story of our joint efforts!