---
title: Macros (experimental)
description: Learn about the experimental macros feature as it develops.
---

[The Dart macro system][spec] is a major new language feature
***currently under development*** which adds support for
[static meta-programming][motivation] to the Dart language.

A Dart macro is a user-definable piece of code that takes in other code as parameters
and operates on it in real-time to create, modify, or add declarations.

You can think about the macro system in two parts: using macros and writing macros.
This page covers each (at a high level, as ***the feature is still in preview***)
in the following sections:

- [**The `JsonCodable` macro**](#the-jsoncodable-macro):
A ready-made macro you can try out today (behind an experimental flag)
that offers a seamless solution to the
common issue of tedious JSON serialization and deserialization in Dart.

- [**The macros feature in general**](#the-macros-language-feature):
Why we're adding macros to Dart, motivating use cases,
benefits over existing code gen solutions,
and a cursory overview of how writing macros will work in the future once
the feature is complete.

[spec]: {{site.repo.dart.lang}}/blob/main/working/macros/feature-specification.md
[motivation]: {{site.repo.dart.lang}}/blob/main/working/macros/motivation.md

## The `JsonCodable` macro

:::important
The `JsonCodable` macro is not stable and currently behind an [experimental flag][].
It only works with Dart `3.5.0-152` or later. 
This is available from the [Dart dev channel][channel] 
or from the [Flutter master channel][flutter-channel].

Functionality is subject to change.
:::

The [`JsonCodable`][] macro encodes and decodes
user-defined Dart classes to JSON maps of type `Map<String, Object?>`.
It generates two members, a `toJson` serialization method,
and a `fromJson` deserialization constructor.

[experimental flag]: /tools/experiment-flags
[`JsonCodable`]: {{site.pub-pkg}}/json/versions/0.20.0
[channel]: https://dart.dev/get-dart#release-channels
[flutter-channel]: {{site.flutter-docs}}/release/upgrade#other-channels

### Set up the experiment

1. Switch to the [Dart dev channel][channel] or the
  [Flutter master channel][flutter-channel].

2. Run `dart --version` and make sure you have Dart version `3.5.0-152` or later.

3. Edit the [SDK constraint][] in your pubspec to require the Dart version: `sdk: ^3.5.0-152`.

4. [Add the package][] `json` to `dependencies`: `dart pub add json`.

5. [Enable the experiment][] in your package's `analysis_options.yaml` file.
  file at the root of your project:

   ```yaml
   analyzer:
    enable-experiment:
      - macros
   ```

6. Import the package in the file you plan to use it:

   ```dart
   import 'package:json/json.dart';
   ```

7. Run your project with the experimental flag:

   ```console
   dart run --enable-experiment=macros bin/my_app.dart
   ```

[SDK constraint]: /tools/pub/pubspec#sdk-constraints
[Add the package]: /guides/packages
[Enable the experiment]: /tools/experiment-flags#using-experiment-flags-with-the-dart-analyzer-command-line-and-ide

### Use the macro

To use the `JsonCodable` macro, attach the annotation to the class you want to serialize:

```dart
import 'package:json/json.dart';

@JsonCodable() // Macro annotation.
class User {
 final int? age;
 final String name;
 final String username;
}
```

The macro introspects the `User` class and derives the implementations of
`fromJson` and `toJson` using the `User` class's fields.

So, without needing to define them yourself, `toJson` and `fromJson` are now
available to use on objects of the annotated class:

```dart
void main() {
 // Given some arbitrary JSON:
 var userJson = {
   'age': 5,
   'name': 'Roger',
   'username': 'roger1337'
 };

 // Use the generated members:
 var user = User.fromJson(userJson);
 print(user);
 print(user.toJson());
}
```

### View the generated code

Sometimes it can be useful to view the generated code to better understand
how a macros works, or to inspect the details of what it offers.

Click on the "**Go to Augmentation**" link that appears under the annotation
in your IDE (supported in VSCode)
to see how the macro generates `toJson` and `fromJson`.

If you change anything in the annotated class, you can watch the generated augmentation
adjust in real time alongside your application code:

![A side-by-side gif of the generated augmentation updating as the code it's augmenting is updated](/assets/img/language/macro-augmentation.gif)

### Trigger custom diagnostics

The `JsonCodable` macro has built-in diagnostics that are emitted just like
diagnostics from the language itself. For example, if you try to manually
declare a `toJson` method where the macro is applied, the analyzer will emit
the error:

```dart
@JsonCodable()
class HasToJson {
 void [!toJson!]() {}
 // Error: Cannot generate a toJson method due to this existing one.
}
```

You can search "`DiagnosticMessage`" in the [the definition of `JsonCodable`][json]
for other errors the macro will throw. For example, extending a class that isn't
also serializable, or if field names don't exactly match the key names in the given JSON.

:::note
To learn more about using the `JsonCodable` macro, like supported field types,
treatment of null and generics, and more, check out [the README][].
:::

[the definition of `JsonCodable`]: {{site.repo.dart.sdk}}/blob/master/pkg/json/lib/json.dart
[the README]: {{site.pub-pkg}}/json

## The macros language feature

Dart macros are a *static* metaprogramming, or code generation, solution.
Unlike *runtime* code generation solutions (like [build_runner][]),
macros are fully integrated into the Dart language
and executed automatically in the background by Dart tools.
This makes macros much more efficient than relying on an secondary tool:

- **Nothing extra to run**;
 macros build in real-time as you write your code.
- **No duplicated work** or constant recompiling hurting performance;
 all the building and code generation happen directly in the compiler,
 automatically.
- **Not written to disk**, so no part files or pointers to generated references;
 macros directly augment the *existing* class.
- **No confusing/obfuscated testing**;
 custom diagnostics are emitted like any other message from the analyzer,
 directly in the IDE.

And also far more efficient, and far less error prone, than manually
writing solutions to these types of problems yourself.

{% comment %}
Check out these examples showing the same JSON serialization
implemented three different ways:

- Using the [`JsonCodable` macro][].
- Using the [`json_serializable` code gen package][].
- Manually, [with `dart:convert`][].
{% endcomment %}

[build_runner]: /tools/build_runner
[`JsonCodable` macro]: https://github.com/mit-mit/sandbox/blob/main/explorations/json/dart_jsoncodable/bin/main.dart
[`json_serializable` code gen package]: https://github.com/mit-mit/sandbox/blob/main/explorations/json/dart_json_serializable/bin/main.dart
[with `dart:convert`]: https://github.com/mit-mit/sandbox/blob/main/explorations/json/dart_convert/bin/main.dart

### Use cases

Macros provide reusable mechanisms to address patterns characterized by tedious
boilerplate, and often times the need to iterate over the fields of a class.
Some common examples that we hope to solve with macros in the future are:

- **Json serialization.** The extra tooling required to serialize JSON,
 like the [json_serializable][] package, isn't as efficient as it should be.
 The `JsonCodable` macro provides a much cleaner way to
 generate serialization code; [try it today](#the-jsoncodable-macro).

- **Data classes.** Dart's [most requested][] feature is for data classes
 that automatically provide a constructor, and implementations of the `==`,
 `hashCode`, and `copyWith()` methods for each field.
 Implementing the solution with macros would mean users can customize the
 their data classes however they see fit.

- **Verbose Flutter patterns.** One example is breaking down a complex `build`
 method into an aggregation of smaller widget classes. It's
 better for performance and makes the code more maintainable. Unfortunately,
 writing all those smaller classes requires tons of boilerplate, which discourages
 users. Macros could potentially provide a solution that iterates over a
 complex `build` method to generates smaller widget classes,
 greatly improving productivity and quality of Flutter code.
 You can check out one exploration into this topic in this
 [proposal][stateful-macro] from the Flutter team.

[json_serializable]: {{site.pub-pkg}}/json_serializable
[most requested]: {{site.repo.dart.lang}}/issues/314
[stateful-macro]: {{site.flutter-docs}}/go/stateful-macro

### How macros work

:::important
The macros language feature is not stable and currently behind an
[experimental flag][]. Functionality is highly subject to change.
This section will remain very high-level until stable.
:::

To create a macro, you write a macro declaration similar to a class,
using the `macro` keyword.
A macro declaration must also include an `implements` clause to define
which interface the macro can be applied to.

For example, a macro that is applicable to classes, and adds new declarations to the class,
would implement the `ClassDeclarationsMacro` interface:

```dart
macro class MyMacro implements ClassDeclarationsMacro {
   const MyMacro();

   // ...
}
```

While the feature is still in development, you can find the full list of
macro interfaces [in the source code][types].

The `MyMacro` constructor in the above example corresponds to the annotation
you would use to apply the macro to a declaration.
The syntax is the same as Dart's existing metadata annotation syntax:

```dart
@MyMacro()
class A {}
```

Within the body of the macro declaration is where you define the code you want
the macro to [generate](#view-the-generated-code), as well as any
[diagnostics](#trigger-custom-diagnostics) you want the macro to emit.

At a very high-level, writing macros essentially works by using builder methods
to piece together the *properties* of a declaration with *identifiers* on those
properties. The macro gathers this information through deep [introspection][] of
the program.

Macros are still under development, so that's as much detail we can go into for now.
If you're curious, or would like to try it yourself behind an experimental flag,
the best guidance is to take a look at the implementation of exisiting macros:

- Check out the [definition][json] of the `JsonCodable` macro,
- Or any of the [examples][] available in the language repo.

[types]: {{site.repo.dart.sdk}}/blob/main/pkg/_macros/lib/src/api/macros.dart
[json]: {{site.repo.dart.sdk}}/blob/master/pkg/json/lib/json.dart
[augmentation]: {{site.repo.dart.lang}}/blob/main/working/augmentation-libraries/feature-specification.md
[examples]: {{site.repo.dart.lang}}/tree/main/working/macros/example

## Timeline

The stable release date for macros is currently unknown.
This is due to the complexity of their implementation.

Macros work by deeply [introspecting][introspection] the program in which
they're applied. A macro may end up traversing distant parts of the program
to gather necessary information on properties and type annotations
for the declaration it's augmenting.

Considering their application in large code bases, where multiple macros can
introspect and augment the base continuously in different places,
the design of [ordering][] and [phases][] of execution is especially challenging
and requires careful consideration.

We are working towards a stable release of the [`JsonCodable`][] macro
later this year (2024), and a stable release of the full language feature
(namely, writing your own macros) early next year (2025).

[introspection]: {{site.repo.dart.lang}}/blob/main/working/macros/feature-specification.md#introspection
[ordering]: {{site.repo.dart.lang}}/blob/main/working/macros/feature-specification.md#ordering-in-metaprogramming
[phases]: {{site.repo.dart.lang}}/blob/main/working/macros/feature-specification.md#phases
