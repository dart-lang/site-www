---
title: Sound null safety
description: Information about Dart's null safety feature
---

The Dart language comes with sound null safety. 

In Dart 3, you always get null safety. In Dart 2.x,
it must be enabled [with a pubspec setting](#enable-null-safety).

Null safety prevents errors that result from unintentional access
of variables set to `null`.
For example, if a method expects an integer but receives `null`,
your app causes a runtime error. This type of error, a null dereference error,
can be difficult to debug.

With sound null safety variables are 'non-nullable' by default:
They can be assigned only values of the declared type
(e.g. `int i=42`), and never be assigned `null`.
You can specify that a type of a variable is nullable
(e.g. `int? i`),
and only then can they contain either a `null` *or*
a value of the defined type.

Sound null safety changes potential **runtime errors**
into **edit-time** analysis errors, by flagging when
any non-nullable variable hasn't been initialized with a 
non-null value or is being assigned a `null`.
This allows you to fix these errors before deploying your app.


## Introduction through examples

With null safety,
all of the variables in the following code are non-nullable:

```dart
// In null-safe Dart, none of these can ever be null.
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

Dart 3---planned for a mid-2023 release---always has sound null safety.
Dart 3 will prevent code from running without it.

Packages developed without null safety support will cause issues
when resolving dependencies:

```terminal
$ dart pub get

Because pkg1 doesn't support null safety, version solving failed.
The lower bound of "sdk: '>=2.9.0 <3.0.0'" must be 2.12.0 or higher to enable null safety.
```

Libraries that opt out of null safety will cause analysis or compilation
errors:

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

As of late April 2023, **Dart 3 beta** is available from the Dart beta channel
and the Flutter beta channel; see [the download page][] for details.
We recommend you test your code for Dart 3 compatibility using that release:

```terminal
$ dart --version                     # make sure this reports 3.0.0-417.1.beta or higher
$ dart pub get / flutter pub get     # this should resolve without issues
$ dart analyze / flutter analyze     # this should pass without errors
```

If the `pub get` step fails, check the [status of the dependencies][].

If the `analyze` step fails, update your code to resolve the issues
listed by the analyzer.

[the download page]: /get-dart/archive#dart-3-alpha
[status of the dependencies]: /null-safety/migration-guide#check-dependency-status

### Dart 3 backwards compatibility

Packages and apps migrated to use null safety with Dart 2.12 or later will
likely be backwards compatible with Dart 3. Specifically, for any package where
the lower bound of the SDK constraint is 2.12.0 or higher, pub will allow
resolution even when the upper bound is limited to versions below 3.0.0. For
example, a package with the following constraint will be allowed to resolve with
a Dart 3.x SDK:

```yaml
environment:
  sdk: '>=2.14.0 <3.0.0'
```

This allows developers to use Dart 3 sound null safety with packages that have
been migrated to 2.12 null safety without needing a second migration.
Note that this only applies to code that
doesn't depend on Dart 3 breaking changes:

* Several historical core library APIs have been removed; for details,
  see the GitHub issues [#34233][] and [#49529][].
* The historical language syntax for default parameter values
  ([#2357][]) has been discontinued.


## Dart 2.x and null safety {#enable-null-safety}

In Dart 2.12 to 2.19, null safety is a configuration option in the pubspec. Null
safety is not available in SDK versions prior to Dart 2.12.

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

Dart code written without null safety support can be migrated to use null
safety. We recommend using the `dart migrate` tool, included in the Dart SDK
versions 2.12 to 2.19.

```terminal
$ cd my_app
$ dart migrate
```

For more details on how to migrate your code to null safety,
see the [migration guide][].


## Where to learn more

For more information about null safety, see the following resources:

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

