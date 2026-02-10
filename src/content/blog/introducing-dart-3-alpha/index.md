---
title: "Introducing Dart 3 alpha"
description: "Preview the most productive, portable, and approachable version of Dart yet. Now available for early testing and experimentation."
publishDate: 2023-01-25
author: "mit-mit"
image: images/0evGHZJd_7cahb08X.png
category: other
tags:
  - dart
  - dartlang
  - flutter
---


In December, we gave a glimpse into the future with our first blog post discussing Dart 3. Today — live from the [Flutter Forward](https://flutter.dev/events/flutter-forward) developer event in Nairobi, Kenya — we’re sharing the broader vision for Dart’s next major release, and our first preview build, **Dart 3 alpha**.

<DashImage src="images/0evGHZJd_7cahb08X.png" />


Our mission for Dart is to create the best programming language for building high-quality apps across any app platform. Dart is **approachable**, easy to learn, avoids unnecessary complexity, and is internally consistent. Dart is **productive;** app developers are under constant pressure to deliver apps with ever changing requirements, in less time, yet with uncompromised quality and finish. So, we built Dart with a deep focus on enabling fast development, rapid iteration, and high quality. And Dart is **portable**, spanning the widest set of platforms, to enable you to deploy apps to the devices of today and tomorrow.

We’ve worked on establishing these qualities over many years. With Dart 3, we intend to take another big step, refining and expanding on approachability, productivity, and portability in significant ways.

Dart 3 is a new *major* release. Partly to signify the large step forward in new functionality, and partly because it’s a *breaking release* in terms of semantic versioning: We’re changing the type system to *only* support **sound null safety** (in Dart 2.12 and later this was *opt-in*), and have made the corresponding breaking changes in Dart’s core libraries. Let’s dive into the details!

## Dart 3 productivity enhancements

### A more expressive Dart language: Records, patterns, and access controls

We’ve evolved the Dart language at a rapid pace the past few years, [adding 23 new features](https://dart.dev/guides/language/evolution) since 2.0. In Dart 3 we expect to add two new major features, records and patterns, with the goal of making working with structured data more productive.

Records allow you to efficiently and concisely create anonymous composite values from any existing data, without the conceptual overhead of needing to declare a class to hold the values. With records, you can easily build new data structures that combine existing data. For example, to return a pair of values:

```dart
(double x, double y) geoLocation(String name) {
  if (name == 'Nairobi') {
    return (-1.2921, 36.8219);
  } else {
    ...
  }
}
```

Where records allow you to combine data, patterns can destructure composite data into its constituents. For example, to destructure the return value of `geoLocation` above (a record consisting of a pair of ints) into two individual `int` variables, `lat` and `long`, you can use a pattern declaration like this:

```dart
void main(List<String> arguments) {
  final (lat, long) = geoLocation('Nairobi');
  print('Current location: $lat, $long');
}
```

Patterns are fully type safe, and checked during development.

You can also pattern match on the type of values, for example from a hierarchy of classes. A `switch` can use patterns that match on the type, and the individual fields of each type, as in the body of `calculateArea` here:

```dart
sealed class Shape {
}

class Square implements Shape {
  final double length;
  Square(this.length);
  
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);
}

double calculateArea(Shape shape) => switch (shape) {
  Square(length: var l) => l * l,
  Circle(radius: var r) => math.pi * r * r
};
```

Overall, we’re adding a large selection of patterns that, when combined, make Dart much more expressive for structured data.

In conjunction with patterns, we’re also adding [capability controls](https://github.com/dart-lang/language/blob/master/accepted/future-releases/class-modifiers/feature-specification.md) to classes, via several new modifiers:

* **`interface class`**: Cannot be extended.

* **`base class`**: Disables the implicit interface, so cannot be implemented.

* **`final class`**: Cannot extend, implement, or mix in the class (outside the current library).

* **`sealed class`**: Same as abstract + final + the type is considered the root of a sealed type family for exhaustiveness checking. As an example, take the `Shape` class hierarchy above. In switch statements on the `Shape` type (like the `calculateArea` function), the analyzer will trigger errors if the switch statement does not handle all possible subtypes of the sealed type.

* **`mixin class`:** A class which may be used as a mixin.

Every new feature adds complexity to the language. To ensure Dart remains approachable, classes default to be fully permissive just like today, with the small exception that classes intended to be used as mixins must now use the `mixin` keyword.

### Productive platform integration via direct platform library interop

We’re working on expanding Dart language interoperability for **calling platform libraries directly from Dart**. On Apple platforms, we’re building on our work on [FFI for C interoperability](https://dart.dev/guides/libraries/c-interop), which supports calling any C module that follows the C calling convention from Dart. This has so far supported languages such as C, Go, and Rust. Now, we’re adding support for Swift and Objective-C on [iOS/macOS](https://dart.dev/guides/libraries/objective-c-interop). On Android, you can call into Jetpack libraries written in Kotlin and Android libraries written in Java by leveraging FFI and Android’s Java Native Interface (JNI).

Powered by new tools, Dart can automatically create bindings that have a Dart interface and behind those cross-language interop code based on the header/interface files of the original C/ObjC/Swift/Java/Kotlin code. For a demonstration of using this to call into Apple’s [Core Motion API](https://developer.apple.com/documentation/coremotion) and Android’s [HealthConnect API](https://developer.android.com/guide/health-and-fitness/health-connect), checkout [the sample app](https://github.com/flutter/samples/blob/main/experimental/pedometer/README.md).

These new interop mechanisms are currently experimental, but we hope that they will reach at least beta quality in Dart 3.0 stable. Feedback is appreciated in the issue trackers for [Java/Kotlin](https://github.com/dart-lang/jnigen), or [C/ObjectiveC/Swift](https://github.com/dart-lang/ffigen). Finally, we’re also working on improved Dart to JavaScript interop; we’ll have more news about that in a future blog post.

## Portability advancements

Dart already supports a wide range of target platforms with our native and web compilers. On the Web, we currently compile to JavaScript. On native devices, we currently support the Intel 32-bit and 64-bit, and ARM 32-bit and 64-bit architectures. There are a number of emerging devices and standards we’re working on adding support for, to ensure Dart is ready for the devices of the future.

For the web, we’re working on support for [WebAssembly](https://webassembly.org/) (Wasm), which has been growing in maturity as a platform-neutral binary instruction format across [all modern browsers](https://caniuse.com/wasm). It’s our hope Wasm can enable Dart web apps to start as fast as apps on native devices.

Another platform architecture growing in interest is [RISC-V](https://en.wikipedia.org/wiki/RISC-V), an open standard instruction set architecture (ISA) designed for broad usage. The Android team recently gave a talk on [their work to support RISC-V](https://www.youtube.com/watch?v=70O_RmTWP58), and we think it will have broad applicability for embedded devices, too. Support for RISC-V is available to preview in Dart 3 alpha.

Finally, we’re working on expanding our current support for ARM devices to also encompass ARM64 support on Windows.

## Dart 3 breaking changes

With the new Dart 3 capabilities covered, let’s turn to the breaking changes we’re making in the spirit of a more consistent and approachable Dart.

### Dart 3 type system: 100% sound null safety

We introduced sound null safety in [Dart 2.12](https://medium.com/dartlang/announcing-dart-2-12-499a6e689c87) in 2021. In a sound typing system, you can trust the types, meaning a variable is *never* null when the types state that it isn’t. This raises productivity by catching issues during development rather than in production, and enables the Dart compilers to produce [smaller and more optimized code](https://medium.com/dartlang/dart-and-the-performance-benefits-of-sound-types-6ceedd5b6cdc). As we [discussed in December](https://medium.com/dartlang/the-road-to-dart-3-afdd580fbefa), Dart is unique in introducing 100% sound null safety to an existing language.

Since Dart 2.12, null safety has been a configuration option that could either be *on* or *off*. **In Dart 3, all code runs with sound null safety *on***. It is no longer possible to run apps without null safety or in a mixed mode with partial null safety.

We realize that discontinuing support for running without null safety can pose issues for existing apps and packages. However, we feel now is the right time to move forward with this change. Having a single type system, where null safety is always on, reduces overhead and complexity. Whenever developers read a piece of Dart 3 code, they can rest assured that all variables are non-null by default. On the implementation side, Dart’s compilers and runtimes can focus on supporting a single way of running Dart code, which lowers the cost and complexity of adding new features.

The Dart ecosystem has demonstrated a strong dedication and willingness to migrate existing code to null safety. As of today,

* 100% of the top-250 packages on pub.dev support null safety

* 98% of the top-1000 packages on pub.dev support null safety

* Only 14% of flutter run sessions still run without null safety

Thank you to the ecosystem for the migration effort!

### Cleanup of Dart 3 core libraries and language

As the Dart language and type system have evolved, several of the APIs in our core libraries have become redundant or suboptimal. To ensure Dart remains approachable, we’ve made a number of breaking changes to clean up unnecessary APIs. For details, see the GitHub issues, [#34233](https://github.com/dart-lang/sdk/issues/34233) and [#49529](https://github.com/dart-lang/sdk/issues/49529). We’ve also removed a historical syntax for default parameter values ([#2357](https://github.com/dart-lang/language/issues/2357)).

With Dart 3 alpha done, our attention has now turned to Dart 3 beta. There, we hope to further refine the Dart core libraries by adding a number of new APIs. You can offer input on this in the [feedback issue](https://github.com/dart-lang/sdk/issues/49928).

### Preparing your code for Dart 3 stable

Generally, we believe most code that has already migrated to use null safety, using Dart 2.12 or later, will work with Dart 3. However, some small subset of packages and apps may be impacted by the breaking changes discussed above. So, to give you time to prepare for the Dart 3 stable release later this year, we have not planned any further breaking changes to the Dart language and core libraries after Dart 3 alpha.

To leverage code that has already migrated to use null safety, we’ve implemented backwards compatibility in Dart 3 that will allow migrated packages to resolve with `pub get` in Dart 3 despite having a SDK version constraint like `&gt;=2.12 &lt;3.0.0`, as long as they don’t depend on other discontinued core library APIs or language features. For more details, including how to test with a locally installed [Dart 3 alpha SDK](https://dart.dev/get-dart/archive#dart-3-alpha), see our [Dart 3 null safety documentation](https://dart.dev/null-safety#dart-3-and-null-safety).

For packages published on the [pub.dev](https://pub.dev/) repository, we’ve run analysis with Dart 3 alpha, and tagged packages that pass with a **“Dart 3 ready”** tag. This signifies that the package is likely to work with Dart 3 when it launches to stable later this year.

<DashImage src="images/0dB-NsWj2y3JljZZh.png" />


### Dart 3 tools cleanup

Leading up to Dart 3, we made [a number of changes](https://github.com/dart-lang/sdk/issues/46100) to move all our terminal developer tools into a unified dart developer tool, which made Dart a lot more approachable for new developers. We’re planning on making [additional tools changes](https://github.com/dart-lang/sdk/issues/50707) over the coming months to further cleanup. Hopefully these changes won’t be too disruptive, but some minor breakage should be expected for tooling in Dart 3 beta.

## Next steps

Dart 3 alpha [is available today](https://dart.dev/get-dart/archive#dart-3-alpha) in the Dart dev channel and in the Flutter master channel. We invite you to try it out, whether it’s to experiment with the new language features like records & patterns, try our new direct access platform interop, or test your apps & packages for [Dart 3 compatibility](https://dart.dev/null-safety#dart-3-and-null-safety).

We’ll continue to refine Dart 3 over the coming months, and hope to have a complete Dart 3 stable release later this year. Note that most of the features are still undergoing development, and therefore subject to change until the stable release. Until then, have fun with your Dart code!