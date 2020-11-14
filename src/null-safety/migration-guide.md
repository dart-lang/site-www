---
title: Migrating to null safety
description: How to move your existing Dart code to the world of null safety
---

{{ site.alert.warning }}
**This page is a DRAFT.**
Please give us feedback at
[PR 2739](https://github.com/dart-lang/site-www/pull/2739).
{{ site.alert.end }}

This page describes how and when to migrate your code to [null safety][].
Here are the basic steps for migrating each package that you own:

1. **Wait** for the packages
   that you depend on to migrate.
2. **Migrate** your package's code,
   preferably using the interactive migration tool.
3. **Test** to make sure your changes work.
4. If the package is already on pub.dev,
   **publish** the null-safe version as a **prerelease** version.

{{ site.alert.info }}
  **Migrating an app is the same as migrating a package.**
  Before fully migrating an app,
  consider waiting until null safety is in a stable release.
  In the meantime, you can learn about null safety,
  perhaps adding migration hints to your app
  or refactoring your app code.
{{ site.alert.end }}

[null safety]: /null-safety

![Screenshot of migration tool](/null-safety/migration-tool.png)
_This interactive tool (`dart migrate`) can simplify migration to null safety._

**_[PENDING: flutter-specific stuff?
Only things kevmoo's run into:
--[no-]sound-null-safety (probably applies to `dart` as well)
IDE launch options
flutter run, flutter test flag order might be slightly different.
pub run --enable-experiment=non-nullable test
aka dart test --enable-experiment=non-nullable]_**

## 1. Wait to migrate {#step1-wait}

We strongly recommend migrating code in order, 
with the leaves of the dependency graph being migrated first.
For example, if package C depends on package B, which depends on package A,
then A should be migrated to null safety first, then B, then C.

![Illustration of C/B/A sentence](/null-safety/null-safety-migration-order.png){:width="454px"}<br>

Although you _can_ migrate before your dependencies support null safety,
you might have to change your code when your dependencies migrate.
For example, if you predict that a function will take a nullable parameter but
the package migrates it to be non-nullable,
then passing a nullable argument becomes a compile error.


### Switch to a beta release

Start the migration process by switching to the **latest beta release**
of either the Dart SDK or the Flutter SDK,
and then updating your pubspec to match.

How you get the latest beta release depends on whether
you use the Flutter SDK:

* If you use the Flutter SDK,
  switch to the beta channel:

  ```terminal
$ flutter channel beta
$ flutter upgrade
```
* Otherwise, download a beta release
  from the [Dart SDK archive][].

[Dart SDK archive]: /tools/sdk/archive#beta-channel

Next, **update your pubspec** to the version of Dart you're using.
For example, say you're using 2.12.0-18.0.beta:

```terminal
$ dart --version
Dart SDK version: 2.12.0-18.0.beta (beta)... [PENDING: update version string!]
```

Update the `pubspec.yaml` file to have that version as a lower constraint:
***[PENDING: Is it really necessary to match the release?
Can we just use 2.12.0-0?]***

```yaml
environment:
  sdk: '>=2.12.0-18.0.beta <3.0.0'
```


{{ site.alert.warn }}
  If you return to working on production code, remember to
  **switch back to a stable release**
  (for example, by running `flutter channel stable`).
{{ site.alert.end }}


### Check dependency status

Get the migration state of your package's dependencies,
using the following command:

```terminal
$ dart pub outdated --mode=null-safety
```

If the output says **all the packages fully support null safety**,
then you can start migrating.
Otherwise, use the **Resolvable** column to find
null-safe releases, if they exist.

For example, in the following output for a simple package,
the green, checkmarked versions support null safety:

![Output of dart pub outdated, showing PENDING](/null-safety/pub-outdated-output.png)

Here are the steps to take before migrating this package to sound null safety:

1. Wait for `examples_util` to be migrated.
2. Update `pubspec.yaml` to use the latest compatible releases of
   `pedantic`, `test`, and `examples_util`
   (as listed in the **Resolvable** column).
3. Run `dart pub upgrade`.
4. Run `dart pub outdated --mode=null-safety` once more,
   to make sure that all dependencies are null safe.

{{ site.alert.info }}
  **Why do all dependencies need to support null safety?**
  When all direct dependencies support null safety,
  you can _run your app_ with sound null safety.
  When all dev dependencies support null safety,
  you can _run tests_ with sound null safety.
{{ site.alert.end }}


## 2. Migrate {#step2-migrate}

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

{{ site.alert.tip }}
  For additional help while migrating code, check the
  [null safety FAQ][].
{{ site.alert.end }}

[null safety FAQ]: /null-safety/faq


### Using the migration tool

The migration tool takes a package of null-unsafe Dart code
and converts it to null safety.

Before running the tool,
make sure you're using a 2.12 beta release (or later):

```terminal
$ dart --version
Dart SDK version: 2.12.0-18.0.beta (beta)... [PENDING: check version #/string!]
```

Then update your `pubspec.yaml` file:

* **Keep any null-safe package versions** you chose when you
  [checked dependency status](#check-dependency-status) in step 1.
* If your package's SDK constraints have a minimum version of 2.12 or higher:
  1. **Set the minimum SDK version** back to a version before null safety.
     ```yaml
environment:
    sdk: '>=2.9.0 <3.0.0'
```
  2. **Update dependencies:**
     ```terminal
$ dart pub get
```

Next, start the migration tool by running the `dart migrate` command
in the directory that contains the package's `pubspec.yaml` file:

```terminal
$ dart migrate
```

If your package is ready to migrate,
then the tool produces a line like the following:

```terminal
View the migration suggestions by visiting:

  http://127.0.0.1:60278/Users/you/project/mypkg.console-simple?authToken=Xfz0jvpyeMI%3D
```

Visit that URL in a Chrome browser
to see an interactive UI
where you can guide the migration process:

![Screenshot of migration tool](/null-safety/migration-tool.png)

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

When you like all of the changes
that the migration tool proposes &mdash; all of the
`?`, `required`, `!`, and other changes &mdash; click
**Apply migration** to tell the tool to save the changes.
Congratulations, your package is migrated!


### Migrating by hand

Manual migration can be the right choice if you
want to migrate your package incrementally.
Because Dart supports [mixed-version programs][],
you can migrate one library (generally one Dart file) at a time,
while still being able to run your app and its tests.

[mixed-version programs]: /go/unsound-null-safety

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
  sdk: '>=2.12.0-18.0.beta <3.0.0' [PENDING: check version; would 2.12.0-0 work?]
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
   Add `?`, `!`, `required`, `late` and refactoring as needed
   to improve your code and eliminate static errors.

[language version comment]: /guides/language/evolution#per-library-language-version-selection
[package config]: https://pub.dev/packages/package_config


## 3. Test your code {#step3-test}

If you already have tests, run them.
You might need to update tests that expect null values.

If your package and its dependencies aren't completely null safe,
then see [Unsound null safety](/go/unsound-null-safety)
for help on running and testing mixed-version code.


## 4. Publish your code {#step4-publish}

We encourage you to publish packages as prereleases
as soon as you migrate.

{{ site.alert.note }}
  Although you can deploy apps at any time,
  we generally recommend waiting for a stable SDK release that
  supports null safety without flags.
{{ site.alert.end }}

If your package is already on pub.dev, publish it as a prerelease:

* [Set the SDK constraints to the tested beta version.](#sdk-constraints)
* [Set the package version to indicate a breaking change and
  include a `nullsafety` suffix.](#version)

### SDK constraints

Set the lower SDK constraint to the beta version of 2.12
that you used to test the migration,
and the upper SDK constraint to `<3.0.0`.
For example, if you're using 2.12.0-18.0.beta,
then your constraints should look like this:

```yaml
environment:
  sdk: '>=2.12.0-18.0.beta <3.0.0'
```

With these constraints,
packages that are published during null safety beta
can still work with the next stable release of the Dart SDK.


### Package version

Update the version of the package
to indicate a breaking change and include a `nullsafety` suffix:

* If your package is already at 1.0.0 or greater,
  increase the major version.
  For example, if the previous version is `2.3.2`,
  the new version is **`3.0.0-nullsafety.0`**.

* If your package hasn't reached 1.0.0 yet,
  _either_ increase the minor version _or_ update the version to 1.0.0.
  For example, if the previous version is `0.3.2`,
  the new version is one of the following:
  * **`0.4.0-nullsafety.0`**
  * **`1.0.0-nullsafety.0`**

For subsequent updates to the null-safe prerelease of the package,
increment the prerelease suffix.
For example, if the first null-safe version is `3.0.0-nullsafety.0`,
then the next one is `3.0.0-nullsafety.1`.

Once null safety is available in a stable release of the Dart SDK,
we encourage you to publish a stable version of your null-safe package.


## Welcome to null safety

If you made it this far,
you should have a fully migrated, null-safe Dart package.
If all of the packages you depend on are migrated too,
then your program is sound with respect to null-reference errors.

From all of the Dart team, *thank you* for migrating your code.
