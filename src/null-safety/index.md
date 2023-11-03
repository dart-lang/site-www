---
title: Sound null safety
description: Information about Dart's null safety feature
---

The Dart language enforces sound null safety.

Null safety prevents errors that result from unintentional access
of variables set to `null`.

For example, if a method expects an integer but receives `null`,
your app causes a runtime error.
This type of error, a null dereference error, can be difficult to debug.

With sound null safety, all variables require a value.
This means Dart considers all variables _non-nullable_.
You can assign values of the declared type only, like `int i=42`.
You can never assign a value of `null` to default variable types.
To specify that a variable type can have a `null` value, add a `?` after
the type annotation: `int? i`.
These specific types can contain either a `null` _or_
a value of the defined type.

Sound null safety changes potential **runtime errors**
into **edit-time** analysis errors.
With null safety, the Dart analyzer and compilers
flag if a non-nullable variable has either:

* Not been initialized with a non-null value
* Been assigned a `null` value.
These checks allows you to fix these errors _before_ deploying your app.

## Introduction through examples

With null safety, none of the variables in the following code can be `null`:

```dart
// With null safety, none of these can ever be null.
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

Dart supports null safety using the following two core design principles:

* **Non-nullable by default**. Unless you explicitly tell Dart that a variable
   can be null, it's considered non-nullable. This default was chosen
   after research found that non-null was by far the most common choice in APIs.

* **Fully sound**. Dart's null safety is sound, which enables compiler optimizations.
  If the type system determines that something isn't null, then that thing can _never_ be
  null. Once you migrate your whole project
  and its dependencies to null safety, 
  you reap the full benefits of soundness—not only 
  fewer bugs, but smaller binaries and faster execution.


## Dart 3 and null safety

Dart 3 has built-in sound null safety.
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

To resolve these issues:

1. Check for [null safe versions](/null-safety/migration-guide#check-dependency-status)
   of any packages you installed from pub.dev
2. [migrate](#migrate) all of your source code to use sound null safety.

Dart 3 can be found in the stable channels for Dart and Flutter.
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

## Migrating existing code {#migrate}

{{site.alert.warning}}
  Dart 3 removes the `dart migrate` tool.
  If you need help migrating your code,
  run the tool with the 2.19 SDK, then upgrade to Dart 3.

  You can migrate without the tool, but it involves
  hand editing code.
{{site.alert.end}}

Dart code written without null safety support can be migrated to use null
safety. We recommend using the `dart migrate` tool, included in the Dart SDK
versions 2.12 to 2.19.

```terminal
$ cd my_app
$ dart migrate
```

To learn how to migrate your code to null safety,
check out the [migration guide][].

## Where to learn more

To learn more about null safety, check out the following resources:

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

