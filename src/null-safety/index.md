---
title: Sound null safety
description: Information about Dart's null safety feature
---

The Dart language comes with sound null safety. 

Null safety prevents errors that result from unintentional access
of variables set to `null`.

For example, if a method expects an integer but receives `null`,
your app returns a runtime error.
This type of error, a null dereference error, can be difficult to debug.

With sound null safety, variables default to 'non-nullable'.
You can assigned values of the declared type only, like `int i=42`.
You can never assign the value to `null` to default variable types.
To specify that a variable type can be nullable, you add a `?` after
the type label: `int? i`.
These specific types can contain either a `null` *or*
a value of the defined type.

Sound null safety changes potential **runtime errors**
into **edit-time** analysis errors.
Null safety does flagging that a non-null variable has either:

* Not been initialized with a non-null value
* Been assigned a `null` value.

This check allows you to fix these errors _before_ deploying your app.

## Introduction through examples

With null safety, all variables in the following code can't be `null`:

```dart
// In Dart 3, none of these can ever be null.
var i = 42; // Inferred to be an int.
String name = getFileName();
final b = Foo();
```

<a id="creating-variables"></a>
To indicate that a variable might have the value `null`,
just add `?` to its type declaration:

```dart
int? aNullableInt = null;
```

- To try an interactive example,
  see the [null safety codelab][Null safety codelab].
- To learn more about this topic, see
  [Understanding null safety](/null-safety/understanding-null-safety).


## Null safety principles

Dart null safety support is based on the following three core design principles:

* **Non-nullable by default**. Unless you explicitly tell Dart that a variable
   can be null, it's considered non-nullable. This default was chosen
   after research found that non-null was by far the most common choice in APIs.

* **Incrementally adoptable**. You choose _what_ to migrate to null safety, and _when_.
  You can migrate incrementally, mixing null-safe and
  non-null-safe code in the same project. We provide tools to help you
  with the migration.

* **Fully sound**. Dart’s null safety is sound, which enables compiler optimizations.
  If the type system determines that something isn’t null, then that thing can _never_ be
  null. Once you migrate your whole project
  and its dependencies to null safety, 
  you reap the full benefits of soundness—not only 
  fewer bugs, but smaller binaries and faster execution.


## Dart 3 and null safety

Dart 3 always has sound null safety.
Dart 3 prevents code without it from running.

To learn how to migrate to Dart 3, 
check out the [Dart 3 migration guide](/resources/dart-3-migration).
Packages developed without null safety support cause issues
when resolving dependencies:

```terminal
$ dart pub get

Because pkg1 doesn't support null safety, version solving failed.
The lower bound of "sdk: '>=2.9.0 <3.0.0'" must be 2.12.0 or higher to enable null safety.
```

Libraries incompatible with Dart 3 cause analysis or compilation errors.

```terminal
$ dart analyze .
Analyzing ....                         0.6s

  error • lib/pkg1.dart:1:1 • The language version must be >=2.12.0. 
  Try removing the language version override and migrating the code.
  • illegal_language_version_override
```

```terminal
$ dart run bin/my_app.dart
../pkg1/lib/pkg1.dart:1:1: Error: Library doesn't support null safety.
// @dart=2.9
^^^^^^^^^^^^
```

To resolve these issues, check for 
[null safe versions](/null-safety/migration-guide#check-dependency-status)
of any packages you installed from pub.dev, and [migrate](#migrate) all
of your own source code to use sound null safety.

**Dart 3** has been released to the Dart and Flutter stable channels.
To learn more, check out [the download page][] for details.
To test your code for Dart 3 compatibility, use Dart 3 or later.

```terminal
$ dart --version                     # make sure this reports 3.0.0-417.1.beta or higher
$ dart pub get / flutter pub get     # this should resolve without issues
$ dart analyze / flutter analyze     # this should pass without errors
```

If the `pub get` step fails, check the [status of the dependencies][].

If the `analyze` step fails, update your code to resolve the issues
listed by the analyzer.

[the download page]: /get-dart/archive
[status of the dependencies]: /null-safety/migration-guide#check-dependency-status

## Dart 2.x and null safety {#enable-null-safety}

From Dart 2.12 to 2.19, you need to enable null safety.
To enable null safety, set the `sdk` option to `'>=2.12.0'`
in the `pubspec.yaml` file.
You cannot use null safety in SDK versions earlier than Dart 2.12.

<a id="constraints"></a>
To enable sound null safety, set the
[SDK constraint lower-bound](/tools/pub/pubspec#sdk-constraints)
to a [language version][] of 2.12 or later.
For example, your `pubspec.yaml` file might have the following constraints:

```yaml
environment:
  sdk: '>=2.12.0 <3.0.0'
```

[language version]: /guides/language/evolution#language-versioning

## Where to learn more

To learn more about null safety, see the following resources:

* [Null safety codelab][]
* [Understanding null safety][]
* [Migration guide for existing code][migration guide]
* [Null safety FAQ][]
* [Null safety sample code][calculate_lix]

[calculate_lix]: https://github.com/dart-lang/samples/tree/main/null_safety/calculate_lix
[migration guide]: /null-safety/migration-guide
[Null safety FAQ]: /null-safety/faq
[Null safety codelab]: /codelabs/null-safety
[Understanding null safety]: /null-safety/understanding-null-safety
[#34233]: https://github.com/dart-lang/sdk/issues/34233
[#49529]: https://github.com/dart-lang/sdk/issues/49529
[#2357]: https://github.com/dart-lang/language/issues/2357

