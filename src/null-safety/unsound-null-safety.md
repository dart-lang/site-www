---
title: Unsound null safety
description: Mixing language versions lets you migrate to null safety at your own pace, with some of the benefits of null safety.
---

{{site.alert.version-note}}
Dart 3 and later does not support code without
null safety or with unsound null safety.
All code must be soundly null safe.
To learn more, check out the [Dart 3 sound null safety tracking issue][].
{{site.alert.end}}

A Dart program may contain some libraries that
are [null safe][] and some that aren't.
These **mixed-version programs**
rely on **unsound null safety**.

[null safe]: /null-safety
[migrated]: /null-safety#migrate
[Dart 3 sound null safety tracking issue]: https://github.com/dart-lang/sdk/issues/49530

The ability to mix [language versions][]
frees package maintainers to migrate their code,
with the knowledge that even legacy users can get new
bug fixes and other improvements.
However, mixed-version programs don't get all the advantages
that null safety can bring.

[language versions]: /guides/language/evolution#language-versioning

This page describes the differences between sound and unsound null safety,
with the goal of helping you decide when to migrate to null safety.
After the conceptual discussion are instructions for migrating incrementally,
followed by details on testing and running mixed-version programs.

{{site.alert.note}}
  We recommend that, if possible, you wait for dependencies to migrate
  before you migrate your package.
  For details, see the [migration guide][].
{{site.alert.end}}

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

* Mixed-version programs run with **unsound null safety**.
  It's possible for `null` reference errors to occur at runtime,
  but only because a `null` or nullable type escaped from
  some null-unsafe library and got into null-safe code.

* When a program is fully migrated and _all_ its libraries are null safe,
  then it runs with **sound null safety**, with
  all of the guarantees and compiler optimizations that soundness enables.

Sound null safety is what you want if possible.
Dart tools automatically run your program in sound mode if
the main entrypoint library of your program has opted into null safety.
If you import a null-unsafe library,
the tools print a warning to let you know that
they can only run with unsound null safety.


## Migrating incrementally

Because Dart supports mixed-version programs,
you can migrate one library (generally one Dart file) at a time,
while still being able to run your program and its tests.

We recommend that you **first migrate leaf libraries**—libraries 
that don't import other files from the package.
Then migrate libraries that directly depend on the leaf libraries.
End by migrating the libraries that have the most
intra-package dependencies.

For example, say you have a `lib/src/util.dart` file
that imports other (null-safe) packages and core libraries,
but that doesn't have any `import '<local_path>'` directives.
Consider migrating `util.dart` first,
and then migrating files that depend only on `util.dart`.
If any libraries have cyclic imports
(for example, A imports B which imports C, and C imports A),
consider migrating those libraries together.

### Using the migration tool

You can migrate incrementally using the
[migration tool][].
To opt out files or directories, click the green checkbox.
In the following screenshot,
all files in the `bin` directory are opted out.

![Screenshot of file viewer in migration tool](/assets/img/null-safety/migration-tool-incremental.png)

[migration tool]: /null-safety/migration-guide#step2-migrate

Each opted out file will be unchanged
except for a 2.9 [language version comment][].
You can later run `dart migrate` again to continue the migration.
Any files that are already migrated feature a disabled checkbox:
you cannot un-migrate a file once it has been migrated.

### Migrating by hand

If you want to incrementally migrate a package by hand, follow these steps:

1. Edit the package's `pubspec.yaml` file,
   setting the minimum SDK constraint to at least `2.12.0`:

   ```yaml
   environment:
     sdk: '>=2.12.0 <3.0.0'
   ```

2. Regenerate the [package configuration file][]:

   ```terminal
   $ dart pub get
   ```

   [package configuration file]: https://github.com/dart-lang/language/blob/main/accepted/2.8/language-versioning/package-config-file-v2.md

   Running `dart pub get` with a lower SDK constraint of `2.12.0`
   sets the default language version of
   every library in the package to 2.12,
   opting them all in to null safety.

3. Open the package in your IDE. <br>
   You're likely to see a lot of analysis errors.
   That's OK.

4. Add a [language version comment][] to the top of
   any Dart files that you don't want to consider during your current migration:
   
   ```dart
   // @dart=2.9
   ```

   Using language version 2.9 for a library that's in a 2.12 package
   can reduce analysis errors (red squiggles) coming from unmigrated code.
   However, **unsound null safety reduces the
   information the analyzer can use.**
   For example, the analyzer might assume a
   parameter type is non-nullable,
   even though a 2.9 file might pass in a null value.

5. Migrate the code of each Dart file,
   using the analyzer to identify static errors. <br>
   Eliminate static errors by adding `?`, `!`, `required`, and `late`,
   as needed.


## Testing or running mixed-version programs

To test or run mixed-version code,
you need to disable sound null safety.
You can do this in two ways:

* Disable sound null safety using the `--no-sound-null-safety` flag
  to the `dart` or `flutter` command:

  ```terminal
  $ dart --no-sound-null-safety run
  $ flutter run --no-sound-null-safety
  ```

* Alternatively, set the language version in the 
  entrypoint—the file that contains `main()` function—to 2.9.
  In Flutter apps, this file is often named `lib/main.dart`.
  In command-line apps, this file is often named `bin/<packageName>.dart`.
  You can also opt out files under `test`,
  because they are also entrypoints.
  Example:

  ```dart
  // @dart=2.9
  import 'src/my_app.dart';

  void main() {
    //...
  }
  ```
  
Opting out tests using either of these mechanisms can be useful
for testing **during** your incremental migration process,
but doing so means that you aren't testing your code with
full null safety enabled.
It's important to opt your tests back _in_ to null safety
when you've finished the incremental migration of your libraries.


[language version comment]: /guides/language/evolution#per-library-language-version-selection
