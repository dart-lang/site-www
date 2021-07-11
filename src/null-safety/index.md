---
title: Sound null safety
description: Information about Dart's null safety feature
---

The Dart language now supports sound null safety!

When you opt into null safety,
types in your code are non-nullable by default, meaning that
variables can’t contain `null` _unless you say they can._
With null safety, your **runtime** null-dereference errors
turn into **edit-time** analysis errors.

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

You can
[use null safety](#enable-null-safety) in your normal development environment,
[migrate existing code][migration guide] to use null safety,
enable null safety in [DartPad]({{site.dartpad}}),
or learn about null safety using
[DartPad with Null Safety][nullsafety.dartpad.dev]
(shown in the following screenshot).

![Screenshot of DartPad in null-safe mode](/null-safety/dartpad-snippet.png)

For an interactive, example-driven introduction to null safety language features,
see the [null safety codelab][Null safety codelab].
For an in-depth discussion, see
[Understanding null safety](/null-safety/understanding-null-safety).


## Null safety principles

Dart null safety support is based on the following three core design principles:

*  **Non-nullable by default**. Unless you explicitly tell Dart that a variable
   can be null, it's considered non-nullable. This default was chosen
   after research found that non-null was by far the most common choice in APIs.

* **Incrementally adoptable**. You choose _what_ to migrate to null safety, and _when_.
  You can migrate incrementally, mixing null-safe and
  non-null-safe code in the same project. We provide tools to help you
  with the migration.

* **Fully sound**. Dart’s null safety is sound, which enables compiler optimizations.
  If the type system determines that something isn’t null, then that thing can _never_ be
  null. Once you migrate your whole project
  and its dependencies to null safety, you reap the full benefits of soundness
  — not only fewer bugs, but smaller binaries and faster execution.


## Enabling null safety {#enable-null-safety}

Sound null safety is available in Dart 2.12 and Flutter 2.


### Migrating an existing package or app {#migrate}

For instructions on how to migrate your code to null safety,
see the [migration guide][].

{{site.alert.version-note}}
  Before Dart 2.13, the templates used by the [`dart create`][] command
  and IDEs aren't null safe, so you need to migrate the code they create.
  For example:

  ```terminal
  $ dart create -t console-full my_cli
  $ cd my_cli
  $ dart migrate --apply-changes
  ```
{{site.alert.end}}

### Behind the scenes: SDK constraints {#constraints}

To make Dart treat your code as null safe,
the [SDK constraints](/tools/pub/pubspec#sdk-constraints)
must require a [language version][] that has null safety support.
For example, your `pubspec.yaml` file might have the following constraints:

{% prettify yaml tag=pre+code %}
environment:
  sdk: ">=2.12.0 <3.0.0"
{% endprettify %}

[language version]: /guides/language/evolution#language-versioning

## Known issues

Some parts of the Dart ecosystem still need additional work to
[migrate to null safety][migration guide].

The Dart team is currently aware of the following issues:

  * Migration of the pub.dev packages owned by the Dart team
    is nearly complete, but a few are still missing. See pub.dev for
    [null-safe packages from the Dart team][ns-dart-pkgs].
  * Packages that have unit tests typically have
    a dev dependency on the [`test` package][`test`].
    A few packages extend the framework in package:test,
    and might have a direct dependency on it.
    When publishing these packages you might get pub warnings about
    the `test` package not being fully migrated.
    As long as your package doesn't ignore any of the
    `import_of_legacy_library_into_null_safe` or
    [`export_legacy_symbol`][] analyzer warnings,
    then you can ignore this warning and safely publish your package.

[`export_legacy_symbol`]: /tools/diagnostic-messages#export_legacy_symbol
[`test`]: {{site.pub-pkg}}/test

[ns-dart-pkgs]: {{site.pub-pkg}}?q=publisher%3Adart.dev&null-safe=1

## Where to learn more

For more information about null safety, see the following resources:

* [Null safety codelab][]
* [Understanding null safety][]
* [Migration guide for existing code][migration guide]
* [Null safety FAQ][]
* [DartPad with null safety][nullsafety.dartpad.dev]
* [Null safety sample code][calculate_lix]
* [Null safety tracking issue][110]
* [Dart blog][]

[110]: https://github.com/dart-lang/language/issues/110
[calculate_lix]: https://github.com/dart-lang/samples/tree/master/null_safety/calculate_lix
[`dart create`]: /tools/dart-create
[Dart blog]: https://medium.com/dartlang
[migration guide]: /null-safety/migration-guide
[Null safety FAQ]: /null-safety/faq
[Null safety codelab]: /codelabs/null-safety
[nullsafety.dartpad.dev]: https://nullsafety.dartpad.dev
[Understanding null safety]: /null-safety/understanding-null-safety

