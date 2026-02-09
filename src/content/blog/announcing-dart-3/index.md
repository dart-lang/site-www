---
title: "Announcing Dart 3"
description: "100% sound null safety. Records, patterns, and class modifiers. 
And a peek into the future."
publishDate: 2023-05-10
author: "mit-mit"
image: images/12XwxNKHrKb3SGaWEyqg2nA.png
category: announcements
tags:
  - dart
  - dartlang
  - releases
---


### 100% sound null safety. Records, patterns, and class modifiers. And a peek into the future.

Hello from Google I/O 2023. Today, live from Mountain View, we’re announcing Dart 3 — the largest Dart release to date! Dart 3 contains three major advancements. First, we’ve completed the journey to 100% sound null safety. Second, we’ve added major new language features for records, patterns, and class modifiers. Third, we’re giving a preview of the future, where we broaden our platform support with native code for the web via Wasm compilation. Let’s get into the details.

<DashImage src="images/12XwxNKHrKb3SGaWEyqg2nA.png" />


## 100% sound null safety

Over the last four years, we’ve evolved Dart into a fast, portable, and modern language. Now with Dart 3, it is a 100% sound null safe language! As we’ve [discussed before](https://medium.com/dartlang/the-road-to-dart-3-afdd580fbefa), we don’t believe any other programming language has ever added sound null safety to an existing language. So, it’s been quite a journey.

<DashImage src="images/1KPbxBAjFYPCSk2OqwjKs7A.png" />


With 100% null safety in Dart, we have a *sound* type system. You can trust that if a type says a value isn’t `null`, then it never can be `null`. This avoids certain classes of coding errors, like null pointer exceptions. It also allows our compilers and runtimes to optimize code in ways it couldn’t without null safety. This design choice involved a tradeoff. Though migrations became a bit harder, we believe we made the right choice for Dart.

### Migrating to Dart 3

A critical part in achieving sound null safety has been the unwavering support from the Dart community: 99% of the top 1000 packages on pub.dev support null safety!

Given this, we expect the vast majority of packages and apps that have been migrated to null safety to work with Dart 3. In just a few cases, a smaller amount of related cleanup in Dart 3 might impact some code. Some legacy core library APIs have been removed ([#34233](https://github.com/dart-lang/sdk/issues/34233), [#49529](https://github.com/dart-lang/sdk/issues/49529)) and some tools have been adjusted ([#50707](https://github.com/dart-lang/sdk/issues/50707)). Should you experience any issues migrating to using the Dart 3 SDK, please consult the [Dart 3 migration guide](https://dart.dev/resources/dart-3-migration). Other than that, we hope you’ll enjoy the new rationalized core libraries and tools.

## Major language features — Record, patterns, and class modifiers

Dart 3 isn’t just about changing the existing language. It’s also about adding significant new features and capabilities! These include records, patterns, and class modifiers.

### Building up structured data with records

Traditionally, a Dart function could only return a single value. As a result, functions that needed to return multiple values had to either package these into other data types such as maps or lists or to define new classes that could hold the values. Using untyped data structures weakened type safety. Having to define new classes just to carry data adds friction during the coding process. You made this pretty clear to us: the language request for multiple return values is our [fourth highest rated](https://github.com/dart-lang/language/issues?q=is%3Aissue+sort%3Areactions-%2B1-desc+) issue.

With records, you can build up structured data with a nice and crisp syntax. Consider this function. It reads out the name and age of a JSON blob and returns them both in a record:

```dart
(String, int) userInfo(Map<String, dynamic> json) {
  return (json['name'] as String, json['height'] as int);
}
```


This should look familiar to all Dart developers. A record looks like a list literal such as `[‘Michael’, ‘Product Manager’]` but uses parentheses instead of brackets. In Dart, records are a general feature. They can be used for more than function return values. You also store them in variables, put them into a list, use them as keys in a map, or create records containing other records. You can add both unnamed fields, like we did in the prior example, and named fields like `(42, description: ‘Meaning of life’)`.

Records are value types and don’t have an identity. This enables our compilers to completely erase the record object in some cases. Records also come with an automatically defined `==` operator and `hashCode` functions. The [records documentation](https://dart.dev/language/records) has more details.

### Working with structured data with patterns and pattern matching

Records simplify how you build up structured data. This does not replace using classes to build up more formal type hierarchies. It just offers another option. In either case, you might want to break that structured data into its individual elements to work with them. This is where pattern matching comes into play.

Consider a basic form of a pattern. The following record pattern destructures a record into two new variables `name` and `height`. These variables can then be used like any other variable, such as in a call to `print`:

```dart
var (String name, int height) = userInfo({'name': 'Michael', 'height': 180});
print('User $name is $height cm tall.');
```


Similar patterns exist for lists and maps. For all of these, you can skip individual elements with the underscore pattern:

```dart
var (String name, _) = userInfo(…);
```


Patterns shine when used in a switch statement. Dart has had limited support for switch since the beginning. In Dart 3 we’ve broadened the power and expressiveness of the `switch` statement. We now support pattern matching in these cases. We’ve removed the need for adding `break` at the end of each case. We also support logical operators to combine cases. The following example shows a nice and crisp `switch` statement that parses a character code:

```dart
switch (charCode) {
  case slash when nextCharCode == slash:
    skipComment();

  case slash || star || plus || minus:
    operator(charCode);

  case >= digit0 && <= digit9:
    number();

  default:
    invalid();
}
```


The switch statement provides a great help when you need one or more statements for each `case`. In some cases, all you want to do is to calculate a value. For that use case, we provide a very succinct switch *expression*. This resembles the switch *statement*, but uses different syntax that’s fine tuned for expressions. The following sample function returns the value of a switch expression to calculate a description of today’s weekday:

```dart
String describeDate(DateTime dt) =>
  switch (dt.weekday) {
      1 => 'Feeling the Monday blues?',
      6 || 7 => 'Enjoy the weekend!',
      _ => 'Hang in there.'
  };
```


A powerful feature of patterns is the ability to check for “exhaustiveness”, This feature ensures that the switch handles all the possible cases. In the previous example, we’re handling all possible values of weekday, which is an `int`. We exhaust all possible values through the combination of match statements for the specific values `1`, `6 `or `7`, and then using a default case `_` for the remaining cases. To enable this check for user-defined data hierarchies, such as a class hierarchy, use the new `sealed` modifier on the top of the class hierarchy as in the following example:

```dart
sealed class Animal { … }
class Cow extends Animal { … }
class Sheep extends Animal { … }
class Pig extends Animal { … }

String whatDoesItSay(Animal a) =>
    switch (a) { Cow c => '$c says moo', Sheep s => '$s says baa' };
```


This returns the following error, alerting us that we missed handling the last possible subtype, Pig:

```
line 6 • The type 'Animal' is not exhaustively matched by the switch cases
since it doesn't match 'Pig()'.
```


Finally, `if` statements can use patterns too. In the next example, we’re using *if-case* matching against a map-pattern to destructure the JSON map. Inside that, we’re matching against constant values (strings like `'name'` and `'Michael'`) and a type test pattern `int h` to read out a JSON value. If the pattern matches fail, Dart executes the `else` statement.

```dart
final json = {'name': 'Michael', 'height': 180};

// Find Michael's height.
if (json case {'name': 'Michael', 'height': int h}) {
  print('Michael is $h cm tall.'); 
} else { 
  print('Error: json contains no height info for Michael!');
}
```


This just touches on all the things you can do with patterns. We believe they will become pervasive across all Dart code. To learn more, check out the [patterns documentation](http://dart.dev/language/patterns) and [patterns codelab](https://codelabs.developers.google.com/codelabs/dart-patterns-records).

### Fine grained access controls for classes with class modifiers

A third Dart 3 language feature is class modifiers. Unlike records & patterns that we expect every Dart developer to use, this is more of a power-user feature. It addresses the needs of Dart developers crafting large API surfaces or building enterprise-class apps.

Class modifiers enable API authors to support only a specific set of capabilities. The defaults remain unchanged though. We want Dart to remain simple and approachable. So, like before, regular classes can be *constructed*, *extended* and *implemented*, as shown in the following examples:

```dart
class Vehicle {
  String make; String model;
  void moveForward(int meters) { … }
}

// Construct.
var myCar = Vehicle(make: 'Ford', model: 'T',);

// Extend.
class Car extends Vehicle {
  int passengers;
}

// Implement.
class MockVehicle implements Vehicle {
  @override void moveForward …
}
```


Class modifiers support adding restrictions to this. Consider some sample uses cases:

* With an `interface class`, you can define a contract for others to implement. An interface class cannot be extended.

* With a `base class`, you can ensure that all of the subtypes of your class inherit from it, instead of implementing its interface. This ensures that private methods are available on all instances.

* With a `final class`, you can close the type hierarchy preventing any subclasses outside of your own library. As a sample benefit, this allows the API owner to add new members without risking breaking changes to the consumers of the API.

For details, see the new [class modifiers documentation](https://dart.dev/language/class-modifiers).

## A view towards the future

Dart 3 is not just a significant step forward in terms of new features you can use today. We’re also giving you a preview of what’s next.

### Dart language

Records, patterns, and class modifiers are very large new features, so it’s possible that there are parts of their design that could be improved. We’ll continue to monitor [your feedback](https://github.com/dart-lang/language/issues), and see if updates are needed in minor releases following Dart 3.

We’re also looking at some smaller, more incremental features that are entirely non-breaking and focused on increasing developer productivity without migration cost. Two examples we’re exploring are [inline classes](https://github.com/dart-lang/language/issues/2727) for wrapping existing types with zero-cost “wrappers”, and [primary constructors](https://github.com/dart-lang/language/issues/2364); a feature that introduces a much more concise syntax for defining classes with a few fields and a primary constructor.

We’ve previously discussed macros (also referred to as [meta-programming](https://github.com/dart-lang/language/blob/main/working/macros/feature-specification.md)). We’re in particular focused on this for enabling better deserialization of JSON (and similar), and for enabling data classes. Given the size and inherent risk in metaprogramming, we’re taking a very thorough approach, and we thus have no concrete timeline to share, even for finalizing design decisions.

### Native interop

Apps on mobile and desktop typically rely on lots of APIs provided by the native platform, whether it’s notifications, payments, or getting the phone’s location. Traditionally in Flutter these are accessed by building plugins, which require writing both Dart code for the API and a bunch of platform-specific code to provide the implementation.

We already support interop with code that compiles to C libraries with [`dart:ffi`](https://dart.dev/guides/libraries/c-interop). We’re currently working on expanding this to support [Java and Kotlin interop](https://dart.dev/guides/libraries/java-interop) on Android, and [Objective C and Swift interop](https://dart.dev/guides/libraries/objective-c-interop) on iOS/macOS. For an introduction to the Android interop, checkout the new Google I/O 23 [Android interoperability video](https://io.google/2023/program/2f02692d-9a41-49c0-8786-1a22b7155628/).

### Compilation to WebAssembly — targeting the web with native code

[WebAssembly](https://webassembly.org/) (abbreviated Wasm) has been growing in maturity as a platform-neutral binary instruction format across [all modern browsers](https://caniuse.com/wasm). The Flutter framework has used Wasm for a while. It’s how we deliver the SKIA graphics rendering engine, written in C++, to the browser via a Wasm compiled module. We’ve long had an interest in using Wasm to deploy Dart code too, but we’ve been blocked. Dart, like many other object oriented languages, uses garbage collection. Over the past year, we’ve collaborated with several teams across the Wasm ecosystem to add a new WasmGC feature to the WebAssembly standard. This is now near-stable in the Chromium and Firefox browsers.

Our work on compiling Dart to Wasm modules has two high-level goals for web apps:

* **Load time:** we hope that we can deliver deployment payloads with Wasm that the browser can load faster, thus improving the time it takes to get to the point where the user can interact with the web app.

* **Performance: **Web apps powered by JavaScript require just-in-time compilation to achieve good performance. Wasm modules are more low-level and closer to machine code, so we think they can deliver higher performance with less jank and more consistent frame rates.

* **Semantic consistency**: Dart takes pride in being highly consistent between our supported platforms. However, on the web, there are a few exceptions to this. For example, Dart web currently differs in how[ numbers are represented](https://dart.dev/guides/language/numbers). With Wasm modules, we’d be able to treat the web like a “native” platform with semantics similar to other native targets.

We’re excited to announce the first preview of Dart to Wasm compilation today! Our initial focus is on Flutter web support. It’s still early, and we have lots of work to complete, but we [invite you to experiment ](https://flutter.dev/wasm)and see if this has you as excited as we are.

## Closing

Thanks for reading until the end. We hope this post has made you excited about Dart 3, available today in both the stand-alone [Dart SDK](https://dart.dev/get-dart) and in the [Flutter 3.10 SDK](https://medium.com/flutter/whats-new-in-flutter-3-10-b21db2c38c73).

We’ve completed a major overhaul of the Dart language with sound null safety, and core library and tools cleanup. There are major new language features that make Dart more expressive and crisp with records and patterns. For large API surfaces, class modifiers enable detailed control. We’re also including a preview of the future with our coming support for WebAssembly.

With all of these features, we think Dart 3 illustrates our long-term vision: *To build the most productive programming language for building fast apps on any platform*. We hope you think so too!