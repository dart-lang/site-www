---
title: "The road to Dart 3: A fully sound, null safe language"
description: "Preparing for the next major release, where Dart only supports sound null safety"
publishDate: 2022-12-08
author: "mit-mit"
image: images/05XfWLgEBx4iJvuqA.png
category: other
tags:
  - dart
  - dartlang
  - null-safety
---


Over the last four years, we’ve evolved Dart into a fast, portable, and modern language. Our next release, Dart 3, completes the journey to a **fully sound null safe language**. As the last step of that journey, we’re removing several historical Dart language and SDK artifacts, including **removing support for running without sound null safety**. This makes Dart easier to learn, and enables us to evolve the Dart SDK to support new features with greater speed. To learn about the main changes in Dart 3 and how to best prepare your apps and packages, keep reading!

<DashImage src="images/05XfWLgEBx4iJvuqA.png" alt="The road to Dart 3. *(Photo by[ Niklas Ohlrogge](https://unsplash.com/@ohlrogge?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on[ Unsplash](https://unsplash.com/s/photos/road-denmark?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText))*" caption="The road to Dart 3. *(Photo by[ Niklas Ohlrogge](https://unsplash.com/@ohlrogge?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on[ Unsplash](https://unsplash.com/s/photos/road-denmark?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText))*" />


## Why sound null safety?

Many modern programming languages support null safety (also known as [void safety](https://en.wikipedia.org/wiki/Void_safety)). This avoids null dereferencing issues, which Tony Hoare coined a billion-dollar mistake: *“This has led to innumerable errors, vulnerabilities, and system crashes, which have probably caused a billion dollars of pain and damage in the last forty years”* ([*Hoare 2009*](https://web.archive.org/web/20090119110704/http://qconlondon.com/london-2009/presentation/Null+References%3A+The+Billion+Dollar+Mistake)). To resolve this, languages like Swift, C#, and Kotlin support a type system where you can declare variables to either be *non-null* (can *never* hold a null value), or *nullable* (can hold a value or null). This type system can be combined with static analysis to detect any assignment of null to non-nullable variables. The null safety support in the Dart language uses a similar model, making variables non-nullable by default, and only allowing nulls when explicitly declared.

Taking it one step further, **Dart introduces *sound null safety* in an existing language**. A sound system guarantees that a non-nullable variable *never* contains a null value. During the early planning of Dart null safety, [we explored](https://github.com/dart-lang/language/blob/master/accepted/2.12/nnbd/roadmap.md) this topic, and the tradeoffs other languages had taken. The Swift design included soundness from the beginning. TypeScript is inherently unsound, as its underlying type system allows for viewing any object as any static type. As you can see in [this TypeScript example](https://www.typescriptlang.org/play?#code/MYGwhgzhAECyCeAVeAHApgHkQPmgbwChpoA3MEAVzWgC5pEBuI6YAewDsIAXAJwuC6seACgD6ZStTqIAlPi4ALAJYQAdBKrQAvNHHkqDAL4FjBAGYV2ApR2hgAJvYCC7eIqXsA5hgCi2YWA8PGDwdE5BIb7YADTQaCBoALZo7Fx0PnKExMSBwfCqKBQQCsLxSSlcMkymZDykAIx0CMjoGOwUiQBGaHUAPtDtICC4OuxoAO5wSKhowgAsAExVBLWkC9oNTGycrAmqIKyewgAGAMSNDdAq0AAkeCT16vpohrEk69d370+ShscyBAISjM0GEDx+mgAhKMKENMswAPQI6AAETQoEC1AAHnYYOwOABaQbgToJWKdChcaDjajAMDsaDcJRDXEQJSeBnE6CCK5pZjfDTUGFDJjEVY4ujtLo9DbgwUMYjMbYQXZofaHE6nBaSwlcnEqOh3LF-AGmJHQJzQEAqKmsEH49hE2EgaAASVSahWgWgiXgABkbWEIvA2h1ujwRtAANr1WILWKLAC6TAI5qcjjsA2dqgt7HsmYdTulPBzAAUeB4qYpqDw0BBYVxVAQHM5XO4vMJfQHuLFicsWy43MovBgAPKdABW6K4-i7NtiACJEMoYNd8VS0CQUgWwz0F8tlar1UcF6cAMx0a3cK4QGgL2Jz7jLIA), we can assign a null value to a non-null variable. For both ergonomic reasons and to avoid migration of all existing code, C# has several [exceptions](https://devblogs.microsoft.com/dotnet/nullable-reference-types-in-csharp/#avoiding-dereferencing-of-nulls) to their null checks. Kotlin has several unsound [exceptions](https://kotlinlang.org/docs/null-safety.html#nullable-types-and-non-null-types), in part due to its goal to interoperate with Java. As you can see in this Kotlin example, [generic types](https://play.kotlinlang.org/embed?short=yOc5EY5E8&theme=darcula) can trigger cases where null values can flow into a list declared as holding non-null elements.

For Dart, we chose the path of sound null safety. This involved a tradeoff. In a few cases, this made migrating to null safety a bit more expensive but results in a sound type system with complete trust in the non-null type annotations. We can make implementation [optimizations](https://medium.com/dartlang/dart-and-the-performance-benefits-of-sound-types-6ceedd5b6cdc) in our compilers and runtimes based on the nullability aspect of the type system. We *know* exactly when a variable isn’t null. We think these were the right set of tradeoffs for Dart.

## In Dart 3, all Dart code will use sound null safety

*Tracking issue: [SDK #49530](https://github.com/dart-lang/sdk/issues/49530).*

It’s been three years since we introduced null safety to the Dart language in [Dart 2.12](https://dart.dev/guides/language/evolution#dart-212). As mentioned in the previous section, we recognize the impact needed to migrate existing Dart packages and apps. To help migration, Dart has supported running your app code in three ways. It can run without null safety, in a mixed mode with partial null safety, or with full sound null safety. Full sound null safety occurs when 100% of the code, including all dependencies, has been migrated. This gave Dart developers time to migrate existing code one step at a time. However, having support for several modes added overhead and complexity.

First, Dart developers need to be aware of all three modes. Whenever you read a piece of Dart code, you must check the language version to see if types are non-null by default, nullable by default, or some combination thereof.

Second, supporting all three modes in our compilers and runtimes slows down evolving the Dart SDK. This support increases the cost and complexity of adding new features.

In Dart 3, sound null safety will be, as [mentioned](https://medium.com/dartlang/dart-2-18-f4b3101f146c) and [announced](https://groups.google.com/a/dartlang.org/g/announce/c/P3UygvbXPgY) earlier, the [only supported mode](https://github.com/dart-lang/sdk/issues/49530). Pubspec files with an SDK constraint having a lower bound of less than 2.12 will **stop resolving** in Dart 3 and later. Any source code containing language markers, will fail when you set the constraint to less than 2.12 (e.g. `// @dart=2.9`).

From our telemetry, we believe that around 85% of all executions of flutter run use sound null safety at this time. If you have apps or packages in the remaining 15%, please [migrate](https://dart.dev/null-safety/migration-guide) before Dart 3 ships, which we expect around mid-2023.

We understand that migrations of large codebases can take some time. We believe you will find the migration worth the effort. BMW recently migrated their main MyBMW app, [a very large app](https://www.press.bmwgroup.com/global/article/detail/T0328610EN/the-my-bmw-app:-new-features-and-tech-insights-for-march-2021?language=en) created by a team of around 300 developers:

*“While the migration to null-safety was certainly not easy for a large-scale codebase like the MyBMW app, Google’s tools gave us great assistance in the migration process. After having the migration completed we enjoy having a less error-prone codebase.”, Christian Schmid, BMW AG*

To learn more about migration, see the following video, or check out the [migration guide](https://dart.dev/null-safety/migration-guide).

<YoutubeEmbed id="eBr5tlumwlg" title="How to migrate Dart packages to null safety" fullwidth="true"/>


## Breaking language and API changes

Alongside the null safety change, we’re making a few other changes to remove historical artifacts in the Dart language and core library APIs. These changes include removing discontinued core library APIs ([#49529](https://github.com/dart-lang/sdk/issues/49529)), removing a historical syntax for default parameter values ([#2357](https://github.com/dart-lang/language/issues/2357)), and requiring tear-offs to be explicit ([#2399](https://github.com/dart-lang/language/issues/2399)).

We believe these changes to have low impact on code migrated to use null safety. When we release the first Dart 3 alpha build, you will be able to quickly test if any of these smaller breaking changes apply to your packages or apps.

## New Dart 3 features and capabilities

Dart 3 is also expected to contain a number of new capabilities, including improved interoperability with other programming languages and new language features. We’ll talk much more about this topic at our next major event, [Flutter Forward](https://flutter.dev/events/flutter-forward) on January 25, 2023.

Let’s take a sneak preview at one language feature, called ***patterns***. Patterns make the Dart language much more expressive, add support for more structured data, and enable a more functional style with algebraic data types.

The following code shows an example of using multiple return values on a function, paired with the ability to *destructure* these into individual variables:

```dart
// A function which returns a record -- in this case a pair of two doubles:
(double x, double y) getLocation(String name) {
  if (name == 'Aarhus') {
    return (56.1629, 10.2039);
  } else {
    ...
  }
}

// Deconstructing the returned record back into individual variables:
void main(List<String> arguments) {
  final (lat, long) = getLocation('Aarhus');
  print('Current location: $lat, $long');
}

// You can also define a hierarchy of classes, and then pattern match on those:
sealed class Shape {
  double calculateArea();
}

class Square implements Shape {
  final double length;
  Square(this.length);
  double calculateArea() => length * length;
}

class Circle implements Shape {
  final double radius;
  ...
}

double calculateArea(Shape shape) => switch (shape) {
  Square(length: var l) => l * l,
  Circle(radius: var r) => math.pi * r * r
};

```

We’ll share many more details about this new feature early next year. To see a sneak preview, you can check out the [language specification](https://github.com/dart-lang/language/blob/master/accepted/future-releases/0546-patterns/feature-specification.md)

## Beyond Dart 3

We work on a multitude of potential new features in parallel, moving from ideation to experimentation to potential launch. As a consequence, some current work will be completed after Dart 3.

First, as we [mentioned last year](https://medium.com/dartlang/experimenting-with-dart-and-wasm-ef7f1c065577), we’re working on support for compiling Dart code to WebAssembly (**Wasm**). Wasm enables Flutter Web apps to run as full native code in browsers. This is a large undertaking, requires work, beyond updating the Dart compilers. It requires collaborating with the W3C and browser vendors on adding support for garbage collected languages in Wasm via the [WasmGC](https://github.com/WebAssembly/gc/blob/master/proposals/gc/Charter.md) extension.

Second, we’re working on **macros**. These enable [static metaprogramming](https://github.com/dart-lang/language/blob/master/working/macros/feature-specification.md). This powerful mechanism allows a piece of code (a macro) to modify and extend the source code of a program during compilation of the program. For example, this can reduce the boilerplate needed to deserialize JSON or to create data classes.

You should expect these features, and other exciting ones, after Dart 3.

## The road to Dart 3

As mentioned in previous sections, if you haven’t migrated to sound null safety, that is the first step. We recommend that you do so now!

Next, Dart 3 will be rolled out in a series of milestones. Our current expectations revolve around these dates:

* **Around January/February 2023**: Dart 3 alpha released. It focuses on enabling early Dart 3 compatibility testing. We expect that you’ll be able to run static analysis (`dart analyze` / `flutter analyze`). It’s our goal that any app or package which passes static analysis with Dart 3 alpha should support Dart 3 stable.

* **Around March/April 2023**: Dart 3 beta released. This release previews the new features in Dart 3. You can use this to experiment with the new features and give feedback on issues or suggestions for improvements.

* **Around mid 2023**: Dart 3 stable released. Sound null safety becomes the only supported mode.

## Summary

The Dart 3 release is scheduled for launch around mid 2023. It will contain several breaking changes, primarily the discontinuation of running without sound null safety. We hope to have a Dart 3 alpha build ready around January or February 2023, which you can use for Dart 3 compatibility testing.

To prepare your apps:

* Complete any outstanding [null safety migrations](https://dart.dev/null-safety/migration-guide)

* Verify that your code doesn’t use any deprecated APIs

* Run [`dart fix`](https://dart.dev/tools/dart-fix).

Dart 3 will also contain several new powerful features, such as patterns. We hope to have a Dart 3 beta release in the spring which demonstrates all the new functionality.