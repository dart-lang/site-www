---
title: Migrating to null safety
description: How to move your existing Dart code to the world of null safety
---

This page describes how and when to migrate your code to [null safety][].
Here are the basic steps for migrating each package that you own:

1. _Optional but recommended:_ Wait for the packages
   that you depend on to migrate.
2. Migrate your package's code,
   preferably using the interactive migration tool (`dart migrate`).
3. Test to make sure your changes work.
4. If the package is already on pub.dev,
   publish the null-safe version.

{{ site.alert.info }}
  **Migrating an app is the same as migrating a package.**
  Before fully migrating an app,
  consider waiting until null safety is in a stable release.
  In the meantime, you can add migration hints to your app
  and take the opportunity to refactor your app code.
  **_[PENDING: is that good/helpful advice?]_**
{{ site.alert.end }}

[null safety]: /null-safety

![Screenshot of migration tool](/null-safety/migrating-to-null-safety/migration-tool.png)
_This interactive tool (`dart migrate`) can simplify migration to null safety._

**_[PENDING: flutter-specific stuff?
Only things kevmoo's run into:
--[no-]sound-null-safety (probably applies to `dart` as well)
IDE launch options
flutter run, flutter test flag order might be slightly different.
pub run --enable-experiment=non-nullable test
aka dart test --enable-experiment=non-nullable]_**

## Prepare to migrate

We strongly recommend migrating code in order, 
with the leaves of the dependency graph being migrated first.
For example, if package C depends on package B, which depends on package A,
then A should be migrated to null safety first, then B, then C.

![Illustration of C/B/A sentence](/null-safety/migrating/null-safety-migration-order.png){:width="454px"}<br>

Although you _can_ migrate before your dependencies support null safety,
you might have to change your code when your dependencies migrate.
For example, if you predict that a function will take a nullable parameter but
the package migrates it to be non-nullable,
then passing a nullable argument becomes a compile error.


### Switch to a beta release

Start the migration process by switching to the **latest beta release**
of either the Dart SDK or the Flutter SDK:

* If you use the Dart SDK, download a beta release
  from the [Dart SDK archive][].
* If you use the Flutter SDK,
  switch to the beta channel:

  ```terminal
$ flutter channel beta
$ flutter upgrade
```

[Dart SDK archive]: /tools/sdk/archive#beta-channel

{{ site.alert.warn }}
  When you return to working on production code,
  **switch back to a stable release**
  (for example, by running `flutter channel stable`).
{{ site.alert.end }}


### Wait for dependencies

Get the migration state of your package's dependencies
by using the following command:

```terminal
$ dart pub outdated --mode=null-safety
```

If the output says **all the packages fully support null safety**,
then you can start migrating.

Otherwise, check whether you can update to
package versions that support null safety.
Many packages have null-safe prerelease versions.
For example, while the [pedantic package][] stable release was 1.9.2,
it also had prereleases 1.10.0-nullsafety, 1.10.0-nullsafety.1, and so on.

[pedantic package]: {{site.pub-pkg}}/pedantic

If you update your pubspec, remember to upgrade before
checking for outdated packages:

```terminal
$ dart pub upgrade
$ dart pub outdated --mode=null-safety
```

**_[PENDING: Offer more help here. What should the SDK constraints be?
Show updating the pubspec? Is there anything else they need to do/change?]_**


## Migrate

Most of the changes that your code needs to be null safe
are easily predictable.
For example, if a variable can be `null`,
its type needs a `?` suffix.
A named parameter that shouldn't be nullable
needs to be marked `required`.

The migration tool can make most of these changes,
and you can add hints to customize the changes.
Alternatively, you can
[migrate your code by hand](#migrating-by-hand).


### Using the migration tool

**_[PENDING: Minimum sdk version in pubspec?
dart --version requirements?]_**

The migration tool takes a package of null-unsafe Dart code
and converts it to null safety.
To start the tool, run the `dart migrate` command
in the directory that contains the package's `pubspec.yaml` file:

```terminal
$ dart migrate
```

**_[PENDING: what potential outputs should we cover here?
Is there anywhere we should link to for more info?]_**

If your package is ready to migrate,
then the tool produces a line like the following:

```terminal
View the migration suggestions by visiting:

  http://127.0.0.1:60278/Users/you/project/mypkg.console-simple?authToken=Xfz0jvpyeMI%3D
```

Visit that URL in a Chrome browser **_[PENDING: check]_**
to see an interactive UI
where you can guide the migration process:

![Screenshot of migration tool](/null-safety/migrating-to-null-safety/migration-tool.png)

For every variable and type annotation,
you can see what nullability the tool infers.
For example, in the preceding screenshot,
the tool infers that the `bar2()` function returns a non-nullable type (`int`).

{{ site.alert.tip }}
  To see the reason for each change (or non-change),
  click the type.
{{ site.alert.end }}

When analysis infers the wrong nullability,
you can override its choice by inserting temporary `/*?*/` and `/*!*/` markers.

* In the tool UI, you can insert these markers using the
  **Add `/*?*/` hint** and **Add `/*!*/` hint** buttons.
* Alternatively, switch back to your editor and change the code yourself,
  even while the tool is still running.
  When you've finished editing your code,
  click **Rerun from sources** to pick up your changes.

{{ site.alert.important }}
  Don't use new null safety features yet.
  Your code is still null-unsafe for now.
{{ site.alert.end }}

Once you like all of the changes
that the migration tool proposes &mdash;all of the
`?`, `required`, `!`, and other changes&mdash;click
**Apply migration** to tell the tool to save the changes.
Congratulations, your package is migrated!

**_[PENDING:
CHECK: Does the tool update the pubspec?
Should we be encouraging people to migrate their apps yet?
Maybe we should just encourage marking their code but
not saving the migrated version?]_**


### Migrating by hand

Manual migration can be the right choice if you
want to migrate your package incrementally.
Because Dart supports _mixed-mode_ programs
**_[PENDING: link to mixed-mode info, which should probably be in another page]_**,
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
**_[PENDING: is everyone OK with those recommendations and examples?]_**

To migrate a package by hand, follow these steps:

1. Modify the SDK constraints in the package's `pubspec.yaml` file,
   setting the language version to 2.12 or later:
   ```yaml
environment:
  sdk: >=2.12.0 <3.0.0
```

2. Run `dart pub get`. <br>
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
   enables mixed mode and can reduce analysis errors (red squiggles).
   However, **mixed mode reduces the
   information the analyzer can use.**
   For example, the analyzer might assume a
   parameter type is non-nullable,
   even though a 2.9 file might pass in a null value.

5. Migrate the code of each Dart file,
   using the analyzer to identify static errors. <br>
   Add `?`, `!`, `required`, `late` and refactoring as needed
   to improve your code and eliminate static errors.

[language version comment]: /guides/language/evolution#per-library-language-version-selection

**_[PENDING: Do we need to talk about `pub get` generating a [package config][]?
That link isn't as helpful as it could be.
Should/do we cover this on dart.dev?]_**

[package config]: https://pub.dev/packages/package_config


## Test your code

If you already have tests, run them.
You might need to update tests that expect null values.

**_[PENDING:
See https://github.com/flutter/flutter/wiki/Experimenting-with-null-safety-in-Flutter
for details (on testing and otherwise; it's sort of this doc, but for pre-beta.
]_**


## Publish your code

We encourage you to publish non-app packages as soon as you migrate.


### Publishing a migrated package

If your package is already on pub.dev, publish it.
Treat the migrated version of your package as a breaking change:

* If your package is already at 1.0.0 or greater,
  increase the major version. <br>
  For example, if the previous version is 2.3.2,
  the new version is 3.0.0.

* If your package hasn't reached 1.0.0 yet,
  increase the minor version or update the version to 1.0.0. <br>
  For example, if the previous version is 0.3.2,
  the new version is 0.4.0 or 1.0.0.


### Deploying a migrated app

Although you can deploy your app at any time,
we generally recommend waiting for a stable SDK release that
supports null safety without flags.


## Welcome to null safety

If you made it this far,
you should have a fully migrated, null-safe Dart package.
If all of the packages you depend on are migrated too,
then your program is fully sound with respect to null-reference errors.

From all of the Dart team, *thank you* for migrating your code.


--------------

## MOVE TO ANOTHER PAGE


### Mixed-mode programs

What if your null-safe app depends on a package that
isn't null safe?
More generally, what happens when your program contains
some libraries at a null-safe language version and
others that are using a null-unsafe language?
Is this allowed?

The answer is "yes".
We called these **mixed-mode programs.**
In the context of null safety,
this means a program can contain some libraries that
are null safe and some that aren't.

A mixed-mode program is still get a perfectly meaningful Dart program that
you can run and use.
Except for esoteric edge cases
(think `is` tests on instances of generic types from
closures that cross the boundary between unsafe and safe libraries),
it should do exactly what you expect.

This is very valuable because it lets you
*incrementally* migrate your program to null safety.
Critically, it means that packages you depend on
can migrate to null safety before you do.
You can even upgrade to those migrated null-safe versions before you migrate.
This frees package maintainers to migrate their code knowing that
even legacy users will still be able to take any
bug fixes or other improvements they ship.

#### Unsound and sound null safety

Dart provides sound null safety through a combination of
static checks (compile-time errors) and
runtime checks (exceptions thrown from code like the `!` or `as` operators).
Each Dart library that opts in to null safety gets
all the static checks and stricter compile errors.
This is true even in a mixed-mode program containing
other null-unsafe libraries.
You immediately start getting static safety benefits
as soon as you start migrating some of your code to null safety.

However, we can't give you the same *runtime* soundness guarantees
in a mixed-mode program that we can give you in a fully null-safe application.
It is possible for `null` to leak out of the null-unsafe libraries
into the null-safe code.
Preventing that would break the existing behavior of the unmigrated code.
To maintain runtime compatibility with legacy libraries
while offering soundness to completely null-safe programs,
our tools support two modes:

*   When you run a mixed-mode program,
    it runs with **partial null-safety**.
    That means it is possible for `null` reference errors to occur at runtime,
    but only because a `null` or nullable type escaped from
    some null-unsafe library and got into your null-safe code.

*   Once your program is fully migrated and *all* libraries are null safe
    (in other words, you're no longer in mixed mode),
    then your program automatically runs with **sound null safety**.
    That mode gives you the full null safety experience with
    all of the guarantees and compiler optimizations that soundness enables.

The second mode is the mode you want if possible.
Our tools will automatically run your program in sound mode if
the main entrypoint library of your program has opted into null safety.
If they see that you import a null-unsafe library,
they'll print a warning to let you know that
they can only run with partial null safety.

