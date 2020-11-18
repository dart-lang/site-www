---
title: Unsound null safety
description: Mixing language versions lets you migrate to null safety at your own pace, with some of the benefits of null safety.
---

An app can use some libraries that
are [null safe][] and some that aren't.
These apps — called **mixed-version programs** —
execute with **unsound null safety**.

[null safe]: /null-safety

Mixing language versions lets you migrate to null safety at your own pace.
It also frees package maintainers to migrate their code,
with the knowledge that even legacy users can get new
bug fixes and other improvements.
However, mixed-version programs don't get all the advantages
that null safety can bring.

This page describes the differences between sound and unsound null safety,
to help you decide whether to migrate before
all your dependencies support null safety.
After the conceptual discussion are instructions for migrating incrementally,
followed by details on analyzing, testing, and running mixed-version programs.

{{ site.alert.note }}
  We recommend that, if possible, you wait for dependencies to migrate
  before you migrate your app.
  For details, see the [migration guide][].
{{ site.alert.end }}

[migration guide]: /null-safety/migration-guide


## Sound and unsound null safety

Dart provides sound null safety through a combination of
static and runtime checks.
Each Dart library that opts in to null safety gets
all the _static_ checks, with stricter compile-time errors.
This is true even in a mixed-version program that contains
null-unsafe libraries.
You start getting these benefits
as soon as you start migrating some of your code to null safety.

However, a mixed-version program can't have the
_runtime_ soundness guarantees that a fully null-safe app has.
It's possible for `null` to leak out of the null-unsafe libraries
into the null-safe code, because
preventing that would break the existing behavior of the unmigrated code.

To maintain runtime compatibility with legacy libraries
while offering soundness to completely null-safe programs,
Dart tools support two modes:

* When you run a mixed-version program,
  it runs with **unsound null safety**.
  It's possible for `null` reference errors to occur at runtime,
  but only because a `null` or nullable type escaped from
  some null-unsafe library and got into your null-safe code.

* When your program is fully migrated and _all_ libraries are null safe,
  then your program automatically runs with **sound null safety**.
  That mode gives you the full null safety experience with
  all of the guarantees and compiler optimizations that soundness enables.

Sound null safety is what you want if possible.
Dart tools automatically run your program in sound mode if
the main entrypoint library of your program has opted into null safety.
If you import a null-unsafe library,
the tools print a warning to let you know that
they can only [run with unsound null safety](#analyzing-and-testing).

{{ site.alert.info }}
  Except for a few edge cases,
  a mixed-version program should do exactly what you expect.
  One example of an edge case is an `is` test
  on an instance of a generic type from a closure
  that crosses the boundary between null-safe and null-unsafe libraries.
{{ site.alert.end }}


## Migrating incrementally

The [migration tool][] is aimed at migrating a whole package at once.
If you want to migrate your package piecemeal,
the migration tool can still help,
but you'll need to do more by hand.

[migration tool]: /null-safety/migration-guide#step2-migrate

Because Dart supports mixed-version programs,
you can migrate one library (generally one Dart file) at a time,
while still being able to run your app and its tests.

We recommend that you **first migrate leaf libraries** —
libraries that don't import other files from the package.
Then migrate libraries that directly depend on the leaf libraries.
End by migrating the libraries that have the most
intra-package dependencies.

For example, say you have a `lib/src/util.dart` file
that imports other (null-safe) packages and core libraries,
but that doesn't have any `import '<local_path>'` directives.
Consider migrating `util.dart` first,
and then migrating simple files that depend only on `util.dart`.
If any libraries have cyclic imports
(for example, A imports B which imports C, and C imports A),
consider migrating those libraries together.

To migrate a package by hand, follow these steps:

1. Modify the SDK constraints in the package's `pubspec.yaml` file,
   setting the language version to 2.12 beta or later:
   ```yaml
environment:
  sdk: '>=2.12.0-0 <3.0.0'
```

2. Update dependencies: <br>
   ```terminal
$ dart pub get
```

   Running `dart pub get` with a lower constraint of 2.12.0
   sets the default language version of
   every library in your package to 2.12,
   opting them all in to null safety.


3. Open the package in your IDE. <br>
   You're likely to see a lot of analysis errors.
   That's OK.

4. _Optional:_ Add a [language version comment][] to the top of
   any Dart files that you don't want to consider during your current migration:
   ```dart
// @dart=2.9
```

   Using language version 2.9 for a library that's in a 2.12 package
   can reduce analysis errors (red squiggles) if you disable sound null safety.
   However, **unsound null safety reduces the
   information the analyzer can use.**
   For example, the analyzer might assume a
   parameter type is non-nullable,
   even though a 2.9 file might pass in a null value.

5. Migrate the code of each Dart file,
   using the analyzer to identify static errors. <br>
   Eliminate static errors by adding `?`, `!`, `required`, and `late`,
   as needed.
   Consider refactoring your code, as needed.


## Analyzing, testing, and running mixed-version code

To analyze, test, or run mixed-version code,
you need to disable sound null safety.
You can do this in two ways:

* Disable sound null safety using the `--no-sound-null-safety` flag.
  Example:

  ```terminal
  $ dart run --no-sound-null-safety
  ```

* Alternatively, set the language version in the entrypoint —
  the file that contains `main()` function — to 2.9.
  In Flutter apps, this file is often named `lib/main.dart`.
  In command-line apps, this file is often named `bin/<packageName>.dart`.
  Example:

  ```dart
  // @dart=2.9
  import 'src/my_app.dart';

  main() {
    //...
  }
  ```

[language version comment]: /guides/language/evolution#per-library-language-version-selection
[package config]: https://pub.dev/packages/package_config

