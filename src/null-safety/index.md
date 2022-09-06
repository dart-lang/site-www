---
title: Sound null safety
description: Information about Dart's null safety feature
---

The Dart language comes with sound null safety.

When using sound null safety,
types in your code are non-nullable by default, meaning that
variables can’t contain `null` _unless you say they can._
With null safety, your **runtime** null-dereference errors
turn into **edit-time** analysis errors, enabling you to fix
errors before deploying to customers.

{{site.alert.warn}}
In Dart 2.x SDKs, sound null safety is enabled or disabled
via configuration of the project SDK constraint;
see [Enabling/disabling null safety](#enable-null-safety) for details.

In Dart 3 -- tentatively planned for release by mid 2023 --
sound null safety will always be enabled,
and running _without_ sound null will no longer be possible.
All existing code must be [migrated](#migrate) to sound null safety
to be compatible with Dart 3.
For details, see the [Dart 3 sound null safety tracking issue][].
{{site.alert.end}}

[Dart 3 sound null safety tracking issue]: https://github.com/dart-lang/sdk/issues/49530

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

For more interactive examples,
see the [null safety codelab][Null safety codelab].
For an in-depth discussion, see
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


## Enabling/disabling null safety {#enable-null-safety}

Sound null safety is available in Dart 2.12 or later,
and in Flutter 2.0 and later. Dart 3 and later will
[_only_ support sound null safety][Dart 3 sound null safety tracking issue].

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

### Migrating an existing package or app {#migrate}

The Dart SDK includes the `dart migrate` tool.
This tool helps you migrate code that supports sound null safety. 
Use `dart migrate` if you wrote Dart code with Dart 2.12 or earlier.

```terminal
$ cd my_app
$ dart migrate
```

To learn how to migrate your code to null safety,
see the [migration guide][].


## Where to learn more

For more information about null safety, see the following resources:

* [Null safety codelab][]
* [Understanding null safety][]
* [Migration guide for existing code][migration guide]
* [Null safety FAQ][]
* [DartPad with null safety]({{site.dartpad}})
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
[Understanding null safety]: /null-safety/understanding-null-safety

