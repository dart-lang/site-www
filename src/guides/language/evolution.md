---
title: Dart language evolution
short-title: Language evolution
description: Notable changes and additions to the Dart programming language.
---

This page lists notable changes and additions to the
Dart programming language.

* To learn specific details about the most recent supported language version,
  check out the [language documentation][] or the [language specification][].
* For a full history of changes to the Dart SDK, see the [SDK changelog][].

To use a language feature introduced after 2.0,
set an [SDK constraint][] no lower than
the release when Dart first supported that feature.

**For example:** To use null safety, introduced in [2.12][],
set `2.12.0` as the lower constraint in the `pubspec.yaml` file.

```yaml
environment:
  sdk: '>=2.12.0 <3.0.0'
```

[2.12]: #dart-212
[SDK constraint]: /tools/pub/pubspec#sdk-constraints
[language versioning section]: #language-versioning

{{site.alert.tip}}
  To review the features being discussed, investigated, and
  added to the Dart language,
  check out the [language funnel][] tracker
  on the Dart language GitHub repo.
{{site.alert.end}}


## Changes in each release

### Dart 3.1
_Released 16 August 2023_
| [Dart 3.1 announcement](https://medium.com/dartlang/dart-3-1-a-retrospective-on-functional-style-programming-in-dart-3-a1f4b3a7cdda)

Dart 3.1 added no new features and made no changes to the language.

### Dart 3.0
_Released 10 May 2023_
| [Dart 3.0 announcement](https://medium.com/dartlang/announcing-dart-3-53f065a10635)

Dart 3.0 introduced several new major language features:

* [Patterns][], a new category of grammar that lets you
  match and destructure values.
* [Records][], a new type that lets you aggregate
  multiple values of different types in a single function return.
* [Class modifiers][], a new set of keywords that let you
  control how a class or mixin can be used.
* [Switch expressions][], a new form of multi-way branching
  allowed where expressions are expected.
* [If-case clauses][], a new conditional construct that matches a value
  against a pattern and executes the then or else branch, depending
  on whether the pattern matches.

Dart 3.0 also introduced a few breaking language changes:

* Class declarations without the [`mixin`][] class modifier
  can no longer be applied as mixins.
* It is now a compile time error if a colon (`:`) is used as the separator
  before the default value of an optional named parameter.
  Use an equal sign (`=`) instead.
* It is now a compile-time error if a `continue` statement targets a
  label that is not attached to a
  loop statement (`for`, `do`, and `while`) or a `switch` member.

{{site.alert.note}}
  The 3.0 release of the Dart SDK dropped support for
  [language versions][] before 2.12.
{{site.alert.end}}

[Patterns]: /language/patterns
[Records]: /language/records
[Class modifiers]: /language/class-modifiers
[Switch expressions]: /language/branches#switch-expressions
[If-case clauses]: /language/branches#if-case
[`mixin`]: /language/mixins#class-mixin-or-mixin-class
[language versions]: #language-versioning

### Dart 2.19
_Released 25 January 2023_

Dart 2.19 introduced some precautions surrounding type inference.
These include:

* More flow analysis flags for unreachable code cases.
* No longer delegate inaccessible private names to `noSuchMethod`.
* Top-level type inference throws on cyclic dependencies.

Dart 2.19 also introduced support for unnamed libraries.
Library directives, used for appending library-level doc comments and
annotations, can and [should][] now be written without a name:

```dart
/// A really great test library.
@TestOn('browser')
library;
```

[should]: /effective-dart/style#dont-explicitly-name-libraries

### Dart 2.18
_Released 30 August 2022_
| [Dart 2.18 announcement](https://medium.com/dartlang/dart-2-18-f4b3101f146c)

Dart 2.18 enhanced type inference.
This change allows information flow between arguments in generic function calls.
Before 2.18, if you didn't specify an argument's type in some methods,
Dart reported errors.
These type errors cited potential null occurrences.
With 2.18, the compiler infers the argument type
from other values in an invocation.
You don't need to specify the argument type inline.

Dart 2.18 also discontinued support for mixin classes that don't extend
`Object`.

To learn more about these features, check out:

* [Type argument inference][]
* [Adding features to a class: mixins][]

[Type argument inference]: /language/type-system#type-argument-inference
[Adding features to a class: mixins]: /language/mixins

### Dart 2.17
_Released 11 May 2022_
| [Dart 2.17 announcement](https://medium.com/dartlang/dart-2-17-b216bfc80c5d)

Dart 2.17 expanded enum functionality with enhanced enums.
Enhanced enums allow enum declarations to define members
including fields, constructors, methods, getters, etc.

Dart 2.17 added support for super-initializer parameters in
constructors.
Super parameters allow you to avoid having to manually pass each
parameter into the super invocation of a non-redirecting constructor.
You can instead use super parameters to forward parameters to a
superclass constructor.

Dart 2.17 removed some restrictions on named arguments.
Named arguments can now be freely interleaved with positional arguments.
As of Dart 2.17, you can write the following code:

```dart
void main() {
  test(skip: true, 'A test description', () {
    // Very long function body here...
  });
}
```

To learn more about these features, check out:

* [Enhanced enums][]
* [Super parameters][]
* [Named parameters][]

[Enhanced enums]: /language/enums#declaring-enhanced-enums
[Super parameters]: /language/constructors#super-parameters
[Named parameters]: /language/functions#named-parameters

### Dart 2.16
_Released 3 February 2022_
| [Dart 2.16 announcement](https://medium.com/dartlang/dart-2-15-7e7a598e508a)

Dart 2.16 added no new features to the Dart language.
It did expand the Dart tools.

### Dart 2.15
_Released 8 December 2021_
| [Dart 2.15 announcement](https://medium.com/dartlang/dart-2-15-7e7a598e508a)

Dart 2.15 improved support for function pointers, known as _tear-offs._
In particular, constructor tear-offs are now supported.

### Dart 2.14
_Released 8 September 2021_
| [Dart 2.14 announcement](https://medium.com/dartlang/announcing-dart-2-14-b48b9bb2fb67)

Dart 2.14 added the unsigned shift (or _triple-shift_) operator (`>>>`).
This new operator works like `>>`,
except that it always fills the most significant bits with zeros.

To learn more about these operators, check out [bitwise and shift operators][].

[bitwise and shift operators]: /language/operators#bitwise-and-shift-operators

Dart 2.14 removed some restrictions on type arguments.
You can pass type arguments to annotations and use a generic function
type as a type argument.
As of Dart 2.14, you can write the following code:

```dart
@TypeHelper<int>(42, "The meaning")
late List<T Function<T>(T)> idFunctions;
var callback = [<T>(T value) => value];
late S Function<S extends T Function<T>(T)>(S) f;
```

### Dart 2.13
_Released 19 May 2021_
| [Dart 2.13 announcement](https://medium.com/dartlang/announcing-dart-2-13-c6d547b57067)

Dart 2.13 expanded support for **[type aliases][]** (`typedef`).
Type aliases used to work only for function types
but now work for any type.
You can use the new name created with a type alias
anywhere the original type could be used.

Dart 2.13 improved the struct support in **[Dart FFI][]**,
adding support for inline arrays and packed structs.

### Dart 2.12
_Released 3 March 2021_
| [Dart 2.12 announcement](https://medium.com/dartlang/announcing-dart-2-12-499a6e689c87)

Dart 2.12 added support for **[sound null safety][]**.
When you opt into null safety, types in your code are non-nullable by default,
meaning that variables can't contain null unless you say they can.
With null safety, your runtime null-dereference errors
turn into edit-time analysis errors.

In Dart 2.12, **[Dart FFI][]** graduated from beta to the stable channel.

### Dart 2.10
_Released 1 October 2020_
| [Dart 2.10 announcement](https://medium.com/dartlang/announcing-dart-2-10-350823952bd5)

Dart 2.10 added no new features to the Dart language.

### Dart 2.9
_Released 5 August 2020_

Dart 2.9 added no new features to the Dart language.

### Dart 2.8
_Released 6 May 2020_
| [Dart 2.8 announcement](https://medium.com/dartlang/announcing-dart-2-8-7750918db0a)

Dart 2.8 didn't add any features to the Dart language. It did
contain a number of preparatory [breaking changes][2.8 breaking changes]
to improve nullability-related usability and performance for [null safety][].

### Dart 2.7
_Released 11 December 2019_
| [Dart 2.7 announcement](https://medium.com/dartlang/dart-2-7-a3710ec54e97)

Dart 2.7 added support for **[extension methods][]**,
enabling you to add functionality to any type
—-even types you don't control—-
with the brevity and auto-complete experience of regular method calls.

The following example extends the `String` class from
`dart:core` with a new `parseInt()` method:

```dart
extension ParseNumbers on String {
  int parseInt() {
    return int.parse(this);
  }
}

void main() {
  int i = '42'.parseInt();
  print(i);
}
```

### Dart 2.6
_Released 5 November 2019_
| [Dart 2.6 announcement](https://medium.com/dartlang/dart2native-a76c815e6baf)

Dart 2.6 introduced a
[breaking change (dart-lang/sdk#37985)](https://github.com/dart-lang/sdk/issues/37985).
Constraints where `Null` serves as a subtype of `FutureOr<T>`
now yield `Null` as the solution for `T`.

For example: The following code now prints `Null`.
Before Dart 2.6, it printed `dynamic`.
The anonymous closure `() {}` returns the `Null` type.

```dart
import 'dart:async';

void foo<T>(FutureOr<T> Function() f) { print(T); }

main() { foo(() {}); }
```

### Dart 2.5
_Released 10 September 2019_
| [Dart 2.5 announcement](https://medium.com/dartlang/announcing-dart-2-5-super-charged-development-328822024970)

Dart 2.5 didn't add any features to the Dart language, but it did add
support for [calling native C code][] from Dart code
using a new **core library, `dart:ffi`.**

### Dart 2.4
_Released 27 June 2019_


Dart 2.4 introduces a breaking change
[dart-lang/sdk#35097](https://github.com/dart-lang/sdk/issues/35097).

Dart now enforces covariance of type variables used in super-interfaces.
For example: Prior to this release Dart accepted, but now rejects,
the following code:

```dart
class A<X> {};
class B<X> extends A<void Function(X)> {};
```

You can now use `async` as an identifier in
asynchronous and generator functions.

### Dart 2.3
_Released 8 May 2019_
| [Dart 2.3 announcement](https://medium.com/dartlang/announcing-dart-2-3-optimized-for-building-user-interfaces-e84919ca1dff)

Dart 2.3 added three operators designed to improve code that performs
list manipulation, such as declarative UI code.

The **[spread operator][]**
enables unpacking the elements from one list into another.
In the following example, the list returned by `buildMainElements()`
is unpacked into the list being passed to the `children` argument:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Header(),
    ...buildMainElements(),
    Footer(),
  ]);
}
```

The **[collection if][]** operator enables adding elements conditionally.
The following example adds a `FlatButton` element unless
the app displays the last page:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Text(mainText),
    if (page != pages.last)
      FlatButton(child: Text('Next')),
  ]);
}
```

The **[collection for][]** operator enables building repeated elements.
The following example adds one `HeadingAction` element for
each section in `sections`:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Text(mainText),
    for (var section in sections)
      HeadingAction(section.heading),
  ]);
}
```


### Dart 2.2
_Released 26 February 2019_
| [Dart 2.2 announcement](https://medium.com/dartlang/announcing-dart-2-2-faster-native-code-support-for-set-literals-7e2ab19cc86d)

Dart 2.2 added support for **[set literals][]**:

```dart
const Set<String> currencies = {'EUR', 'USD', 'JPY'};
```

### Dart 2.1
_Released 15 November 2018_
| [Dart 2.1 announcement](https://medium.com/dartlang/announcing-dart-2-1-improved-performance-usability-9f55fca6f31a)

Dart 2.1 added support for **int-to-double conversion**,
allowing developers to set `double` values using integer literals.
This feature removed the annoyance of being forced to use a
`double` literal (for example, `4.0`)
when the value was an integer in concept.

In the following Flutter code, `horizontal` and `vertical` have type `double`:

```dart
padding: const EdgeInsets.symmetric(
  horizontal: 4,
  vertical: 8,
)
```

### Dart 2.0
_Released 22 February 2018_
| [Dart 2.0 announcement](https://medium.com/dartlang/announcing-dart-2-80ba01f43b6)

Dart 2.0 implemented a new **[sound type system][]**.
Before Dart 2.0, types weren't fully sound, and
Dart relied heavily on runtime type checking.
Dart 1.x code had to be migrated to Dart 2.

## Language versioning

A single Dart SDK can simultaneously support
multiple versions of the Dart language.
The compiler determines what version the code is targeting,
and it interprets the code according to that version.

Language versioning becomes important on the rare occasions when Dart
introduces an incompatible feature like [null safety][].
When Dart introduces a breaking change, code that
did compile might no longer compile.
Language versioning allows you to set each library's language version
to maintain compatibility.

In the case of null safety, Dart SDKs 2.12 through 2.19 allowed you
to _choose_ to update your code to use null safety.
Dart uses language versioning to permit non-null-safe code to run
alongside null-safe code.
This decision enabled migration from non-null-safe to null-safe code.
To review an example of how an app or package can migrate to a new
language version with an incompatible feature, check out
[Migrating to null safety](/null-safety/migration-guide).

Each package has a default language version equal to the **lower bound**
of the SDK constraint in the `pubspec.yaml` file.

**For example:** The following entry in a `pubspec.yaml` file
indicates that this package defaults to the Dart 2.18 language version.

```yaml
environment:
  sdk: '>=2.18.0 <3.0.0'
```

### Language version numbers

Dart formats its language versions as two numbers separated with a period.
It reads as a major version number and a minor version number.
Minor version numbers might introduce breaking changes.

Dart releases might append a patch number to a language version.
Patches should not change the language except for bug fixes.
To illustrate: Dart 2.18.3 serves as the latest release of the
Dart 2.18 SDK language version.

Each Dart SDK supports all of the language versions within
its major version number.
That means that Dart SDK 2.18.3 supports language versions
2.0 through 2.18 inclusive, but not Dart 1.x.

Deriving the language version from the SDK version implies the following:

* Whenever a minor version of the SDK ships, a new language version appears.
  In practice, many of these language versions work in a very similar manner
  to previous versions and have with full compatibility between them.
  For example: The Dart 2.9 language works much like the Dart 2.8 language.

* When a patch release of the SDK ships,
  it cannot introduce new language features.
  For example: The 2.18.3 release _remains_ language version 2.18.
  It must remain compatible with 2.18.2, 2.18.1, and 2.18.0.

### Per-library language version selection

By default, every Dart file in a package uses the same language version.
Dart identifies the default language version as the
lower-bound of the SDK constraint specified in the `pubspec.yaml` file.
Sometimes, a Dart file might need to use an older language version.
For example, you might not be able to migrate all the files in a package
to null safety at the same time.

Dart supports per-library language version selection.
To opt to have a different language version from
the rest of a package, a [Dart library][] must
include a comment in the following format:

```dart
// @dart = <major>.<minor>
```

For example:

```dart
// Description of what's in this file.
// @dart = 2.17
import 'dart:math';
...
```

The `@dart` string must be in a `//` comment (not `///` or `/*`),
and it must appear before any Dart code in the file.
Whitespace (tabs and spaces) doesn't matter,
except within the `@dart` and version strings.
As the previous example shows,
other comments can appear before the `@dart` comment.

To learn how and why the Dart team developed this versioning method,
check out the [language versioning specification][].

[2.8 breaking changes]: https://github.com/dart-lang/sdk/issues/40686
[calling native C code]: /guides/libraries/c-interop
[collection for]: /language/collections#control-flow-operators
[collection if]: /language/collections#control-flow-operators
[Dart library]: /guides/libraries/create-packages#organizing-a-package
[Dart FFI]: /guides/libraries/c-interop
[extension methods]: /language/extension-methods
[language funnel]: https://github.com/dart-lang/language/projects/1
[language specification]: /guides/language/spec
[language documentation]: /language
[language versioning specification]: https://github.com/dart-lang/language/blob/main/accepted/2.8/language-versioning/feature-specification.md#dart-language-versioning
[null safety]: /null-safety
[SDK changelog]: https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md
[set literals]: /language/collections#sets
[sound null safety]: /null-safety
[sound type system]: /language/type-system
[spread operator]: /language/collections#spread-operators
[type aliases]: /language/typedefs
