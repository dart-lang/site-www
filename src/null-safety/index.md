---
title: Sound null safety
description: Information about Dart's null safety feature
---

The Dart language comes with sound null safety.

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

{{site.alert.warn}}
In Dart 2.x SDKs, you can enable or disable sound null safety 
through configuration of the project SDK constraint.
To learn more, see [Enabling/disabling null safety](#enable-null-safety).

Dart 3--planned for a mid-2023 release--
will require sound null safety. It will prevent code from running without it.
All existing code must be [migrated](#migrate) to sound null safety
to be compatible with Dart 3.
To learn more, see the [Dart 3 sound null safety tracking issue][].
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


## Enabling/disabling null safety {#enable-null-safety}

You can use sound null safety in Dart 2.12 and Flutter 2.0 or later.
Dart 3 and later will [_only_ support sound null safety][Dart 3 sound null safety tracking issue].

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

