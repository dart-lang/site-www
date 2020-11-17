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

1. [**Wait**](#step1-wait) for the packages
   that you depend on to migrate.
2. [**Migrate**](#step2-migrate) your package's code,
   preferably using the interactive migration tool.
3. [**Statically analyze**](#step3-analyze) your package's code.
4. [**Test**](#step4-test) to make sure your changes work.
5. If the package is already on pub.dev,
   [**publish**](#step5-publish) the null-safe version
   as a **prerelease** version.

{{ site.alert.info }}
  **Migrating an app is technically the same as migrating a package.**
  Before migrating an app,
  consider waiting until null safety is in a stable release
  and all your dependencies are ready.
{{ site.alert.end }}

[null safety]: /null-safety

![Screenshot of migration tool](/null-safety/migration-tool.png)
_The interactive migration tool can simplify migration to null safety._


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

This section tells you how to
check your package's dependencies
by temporarily opting into null safety
and using the `dart pub outdated` command in null-safety mode.

{{ site.alert.warn }}
  These instructions assume your code is under **source control**,
  so that you can easily undo any changes.
{{ site.alert.end }}

### Switch to a 2.12 beta release

**Switch to the latest beta release**
of either the Dart SDK or the Flutter SDK.
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

{{ site.alert.warn }}
  If you return to working on production code, remember to
  **switch back to a stable release**
  (for example, by running `flutter channel stable`).
{{ site.alert.end }}


### Opt into null safety

Setting the minimum SDK constraint to 2.12 (or a later version)
opts the packaging into null safety by
setting the [language version][] to at least 2.12.

**Update `pubspec.yaml`** to use a 2.12 release as
the minimum SDK constraint:

```yaml
environment:
  sdk: '>=2.12.0-0 <3.0.0'
```


[language version]: /guides/language/evolution#language-versioning


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

{{ site.alert.info }}
  **Why do all dependencies need to support null safety?**
  When all of an app's direct dependencies support null safety,
  you can _run the app_ with sound null safety.
  When all the dev dependencies support null safety,
  you can _run tests_ with sound null safety.
  You might also need null-safe dev dependencies for other reasons,
  such as building.
{{ site.alert.end }}

Here's an example of the output for a simple package.
The green checkmarked version for each package supports null safety:

![Output of dart pub outdated, showing that examples_util has no releases with null safety support, but pedantic and test do](/null-safety/pub-outdated-output.png)

Here are the steps to take before migrating this package to sound null safety:

1. Wait for `examples_util` to be migrated.

2. Update `pubspec.yaml` to use the latest compatible releases of
   `pedantic`, `test`, and `examples_util`
   (as listed in the **Resolvable** column).
   For example, the new dev dependencies might look like this:
   ```dart
dev_dependencies:
  examples_util: ^0.0.3-nullsafety.0
  pedantic: ^1.10.0-nullsafety.3
  test: ^1.16.0-nullsafety.9
```

3. Run `dart pub upgrade`.

4. Run `dart pub outdated --mode=null-safety` again,
   to make sure that all dependencies are null safe and up-to-date.


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
make sure you're using the latest 2.12 beta release
of the Dart SDK:

```terminal
$ dart --version
Dart SDK version: 2.12.0-49.0.beta (beta)...
```

Next, update your `pubspec.yaml` file:

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

Now, start the migration tool by running the `dart migrate` command
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
the tool infers that the `ints` list (previously a list of `int`)
in line 1 is nullable, and thus should be a list of `int?`.


#### Understanding migration results

To see the reasons for each change (or non-change),
click its line number in the **Proposed Edits** pane.
The reasons appear in the **Edit Details** pane.

For example, consider the following code,
from before null safety:

```dart
var ints = const <int>[0, null];
var zero = ints[0];
var one = zero + 1;
var zeroOne = <int>[zero, one];
```

The default migration is backward compatible but not ideal:

```dart
var ints = const <int?>[0, null];
var zero = ints[0];
var one = zero! + 1;
var zeroOne = <int?>[zero, one];
```

By clicking line 3, you can see the migration tool's reasons for
adding the `!`.
But if you know that `zero` can't be null,
then you can improve the migration result.


#### Improving migration results

When analysis infers the wrong nullability,
you can override its proposed edits by inserting temporary
`/*?*/` and `/*!*/` markers:

* In the **Edit Details** pane of the migration tool,
  you can insert these markers using the
  **Add `/*?*/` hint** and **Add `/*!*/` hint** buttons.

  These buttons add comments to your file immediately,
  and there's **no Undo**.
  If you don't want a hint that the tool inserted,
  you can use your usual code editor to remove it.

* You can use an editor to add these markers,
  even while the tool is still running.
  Because your code hasn't opted into null safety yet,
  you can't use new null-safety features.
  You can, however, make changes like refactoring
  that don't depend on null-safety features.

  When you've finished editing your code,
  click **Rerun from sources** to pick up your changes.

A single hint can have ripple effects elsewhere in the code.
In the example from before,
adding a `/*!*/` marker where `zero` is assigned its value (on line 2)
makes the migration tool infer the type of `zero` as `int` instead of `int?`.
This type change can affect code that directly or indirectly uses `zero`.

```dart
var zero = ints[0]/*!*/;
```

With the above hint, the migration tool changes its proposed edits,
as the following code snippets show.
Line 3 no longer has a `!` after `zero`,
and in line 4 `zeroOne` is inferred to be
a list of `int`, not `int?`.

<table markdown="1">
<tr>
<th>First migration</th>
<th>Migration with hint</th>
</tr>
<tr markdown="1">
  <td markdown="1">
```dart
var ints = const <int?>[0, null];
var zero = ints[0];
var one = zero! + 1;
var zeroOne = <int?>[zero, one];
```
  </td>
  <td markdown="1">
```dart
var ints = const <int?>[0, null];
var zero = ints[0]/*!*/;
var one = zero + 1;
var zeroOne = <int>[zero, one];
```
  </td>
</tr>
</table>

#### Applying changes

When you like all of the changes
that the migration tool proposes, click
**Apply migration** to tell the tool to save the migrated code
and to update the minimum SDK in your pubspec.

The next step is to [statically analyze your code](#step3-analyze).
If it's valid, then [test your code](#step4-test).
Then, if you've published your code on pub.dev,
[publish a null-safe prerelease](#step5-publish).


### Migrating by hand

Manual migration can be the right choice if you
want to migrate your package incrementally.
Because Dart supports [mixed-version programs][Unsound null safety],
you can migrate one library (generally one Dart file) at a time,
while still being able to run your app and its tests.

[Unsound null safety]: /go/unsound-null-safety

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

   See [Unsound null safety][] for more information.

5. Migrate the code of each Dart file,
   using the analyzer to identify static errors. <br>
   Add `?`, `!`, `required`, `late` and refactoring as needed
   to improve your code and eliminate static errors.

[language version comment]: /guides/language/evolution#per-library-language-version-selection
[package config]: https://pub.dev/packages/package_config


## 3. Analyze {#step3-analyze}

Update your packages
(using `pub get` in your IDE or on the command line).
Then use your IDE or the command line
to perform [static analysis][] on your code:

```terminal
$ dart pub get
$ dart analyze     # or `flutter analyze`
```

[static analysis]: /guides/language/analysis-options

If you haven't migrated the entire package,
see [Unsound null safety][]
for help on analyzing mixed-version code.

## 4. Test {#step4-test}

If your code passes analysis, run tests:

```terminal
$ dart test       # or `flutter test`
```

You might need to update tests that expect null values.
If you haven't migrated the entire package,
see [Unsound null safety][]
for help on running and testing mixed-version code.

If you need to make large changes to your code,
then you might need to remigrate your code.
If so, revert your code changes before using the migration tool again.


## 5. Publish {#step5-publish}

We encourage you to publish packages as prereleases
as soon as you migrate:

* [Set the SDK constraints to the tested beta version.](#sdk-constraints)
* [Set the package version to indicate a breaking change and
  include a `nullsafety` suffix.](#version)

### SDK constraints

Set the lower SDK constraint to the beta version of 2.12
that you used to test the migration,
and the upper SDK constraint to `<3.0.0`.
For example, if you're using 2.12.0-49.0.beta,
then your constraints should look like this:

```yaml
environment:
  sdk: '>=2.12.0-49.0.beta <3.0.0'
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
