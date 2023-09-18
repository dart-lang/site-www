---
title: Migrating to null safety
description: How to move your existing Dart code to the world of null safety
---

{{site.alert.version-note}}
  Dart 2.19 is the final release that supports null-safety migration,
  including the `dart migrate` tool.
  To migrate your package to null safety,
  use the latest Dart 2.19 SDK.
  To learn more,
  see [Dart 3 and null safety](/null-safety#dart-3-and-null-safety).
{{site.alert.end}}

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

{{site.alert.tip}}
  If your application or library is large, check out
  [Gradual null safety migration for large Dart projects][].
{{site.alert.end}}

{{site.alert.info}}
  **Migrating an app is technically the same as migrating a package.**
  Before migrating an app,
  make sure that all of your dependencies are ready.
{{site.alert.end}}

For an informal look at the experience of using the migration tool, watch this video:

<iframe width="560" height="315" src="https://www.youtube.com/embed/eBr5tlumwlg" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

[null safety]: /null-safety
[Gradual null safety migration for large Dart projects]: https://medium.com/dartlang/gradual-null-safety-migration-for-large-dart-projects-85acb10b64a9


## 1. Wait to migrate {#step1-wait}

We strongly recommend migrating code in order, 
with the leaves of the dependency graph being migrated first.
For example, if package C depends on package B, which depends on package A,
then A should be migrated to null safety first, then B, then C.

![Illustration of C/B/A sentence](/assets/img/null-safety/null-safety-migration-order.png){:width="454px"}<br>

Although you [_can_ migrate][Unsound null safety]
before your dependencies support null safety,
you might have to change your code when your dependencies migrate.
For example, if you predict that a function will take a nullable parameter but
the package migrates it to be non-nullable,
then passing a nullable argument becomes a compile error.

{{site.alert.info}}
  **You can—and should—migrate your package before
  packages that depend on it are migrated.**
  Your null-safe package is usable by packages and apps that
  don't use null safety yet,
  as long as they use Dart 2.12 or later.
  For example, the Dart and Flutter core libraries are null safe,
  and they're still usable by apps that haven't migrated to null safety.
{{site.alert.end}}

This section tells you how to
check and update your package's dependencies,
with the help of the `dart pub outdated` command in null-safety mode.
The instructions assume your code is under **source control**,
so that you can easily undo any changes.

<a id="switch-to-the-latest-stable-dart-release"></a>
### Switch to the latest Dart 2.19 release

Switch to the latest **Dart 2.19 release** of the Dart SDK. 
This is included in the Flutter 3.7 SDK.

Check that you have Dart 2.19:

```terminal
$ dart --version
Dart SDK version: 2.19.6
```

### Check dependency status

Get the migration state of your package's dependencies,
using the following command:

```terminal
$ dart pub outdated --mode=null-safety
```

If the output says that all the packages support null safety,
then you can start migrating.
Otherwise, use the **Resolvable** column to find
null-safe releases, if they exist.

{{site.alert.info}}
  **Why do all dependencies need to support null safety?**
  When all of an app's direct dependencies support null safety,
  you can _run the app_ with sound null safety.
  When all the dev dependencies support null safety,
  you can _run tests_ with sound null safety.
  You might also need null-safe dev dependencies for other reasons,
  such as code generation.
{{site.alert.end}}

Here's an example of the output for a simple package.
The green checkmarked version for each package supports null safety:

![Output of dart pub outdated](/assets/img/null-safety/pub-outdated-output.png)

The output shows that all of the package's dependencies
have resolvable prereleases that support null safety.

If any of your package's dependencies _don't_ yet support null safety,
we encourage you to reach out to the package owner.
You can find contact details on the package page on [pub.dev][].

[pub.dev]: {{site.pub}}


### Update dependencies

Before migrating your package's code,
update its dependencies to null-safe versions:

1. Run `dart pub upgrade --null-safety` to upgrade to the latest versions
   supporting null safety.
   **Note:** This command changes your `pubspec.yaml` file.

2. Run `dart pub get`.


## 2. Migrate {#step2-migrate}

Most of the changes that your code needs to be null safe
are easily predictable.
For example, if a variable can be `null`,
[its type needs a `?` suffix][nullable type]. 
If a named parameter shouldn't be nullable,
mark it [`required`][required]
or give it a [default value][].

You have two options for migrating:

* [Use the migration tool][migration tool],
  which can make most of the easily predictable changes for you.
* [Migrate your code by hand.](#migrating-by-hand)

{{site.alert.tip}}
  For additional help while migrating code, check the
  [null safety FAQ][].
{{site.alert.end}}

[nullable type]: /null-safety#creating-variables
[required]: /null-safety/understanding-null-safety#required-named-parameters
[default value]: /language/functions#default-parameters
[migration tool]: #migration-tool
[null safety FAQ]: /null-safety/faq


### Using the migration tool {#migration-tool}

The migration tool takes a package of null-unsafe Dart code
and converts it to null safety.
You can guide the tool's conversion by
adding [hint markers][] to your Dart code.

[hint markers]: #hint-markers

Before starting the tool, make sure you're ready:

* Use the latest 2.19 release of the Dart SDK.
* Use `dart pub outdated --mode=null-safety` to make sure that
  all dependencies are null safe and up-to-date.
  
Start the migration tool by running the `dart migrate` command
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

![Screenshot of migration tool](/assets/img/null-safety/migration-tool.png)

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

The default migration when this code is outside a function
(it's different within a function)
is backward compatible but not ideal:

```dart
var ints = const <int?>[0, null];
var zero = ints[0];
var one = zero! + 1;
var zeroOne = <int?>[zero, one];
```

By clicking the **line 3** link,
you can see the migration tool's reasons for
adding the `!`.
Because you know that `zero` can't be null,
you can improve the migration result.


#### Improving migration results {#hint-markers}

When analysis infers the wrong nullability,
you can override its proposed edits by inserting temporary hint markers:

* In the **Edit Details** pane of the migration tool,
  you can insert hint markers using the
  **Add `/*?*/` hint** and **Add `/*!*/` hint** buttons.

  These buttons add comments to your file immediately,
  and there's **no Undo**.
  If you don't want a hint that the tool inserted,
  you can use your usual code editor to remove it.

* You can use an editor to add hint markers,
  even while the tool is still running.
  Because your code hasn't opted into null safety yet,
  you can't use new null-safety features.
  You can, however, make changes like refactoring
  that don't depend on null-safety features.

  When you've finished editing your code,
  click **Rerun from sources** to pick up your changes.

The following table shows the hint markers that you can use
to change the migration tool's proposed edits.

|------------------+--------------------------------------------------------------------------|
| Hint marker      | Effect on the migration tool                                             |
|------------------|--------------------------------------------------------------------------|
| <code><em>expression</em>&nbsp;/*!*/</code> | Adds a `!` to the migrated code, casting _expression_ to its underlying non-nullable type. |
| <code><em>type</em> /*!*/</code> | Marks _type_ as non-nullable. |
| `/*?*/`          | Marks the preceding type as nullable.                       |
| `/*late*/`       | Marks the variable declaration as `late`, indicating that it has late initialization. |
| `/*late final*/` | Marks the variable declaration as `late final`, indicating that it has late, one-time initialization. |
| `/*required*/`   | Marks the parameter as `required`.                                        |
{:.table .table-striped}

A single hint can have ripple effects elsewhere in the code.
In the example from before,
manually adding a `/*!*/` marker where `zero` is assigned its value (on line 2)
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

#### Opting out files

Although we recommend migrating all at once,
sometimes that isn't practical,
especially in a large app or package.
To opt out a file or directory,
click its green checkbox.
Later, when you apply changes,
each opted out file will be unchanged
except for a 2.9 [version comment][].

For more information about incremental migration, see
[Unsound null safety][].

Note that only fully migrated apps and packages 
are compatible with Dart 3.

[version comment]: /guides/language/evolution#per-library-language-version-selection


#### Applying changes

When you like all of the changes
that the migration tool proposes, click **Apply migration**.
The migration tool deletes the hint markers and
saves the migrated code.
The tool also updates the minimum SDK constraint in the pubspec,
which opts the package into null safety.

The next step is to [statically analyze your code](#step3-analyze).
If it's valid, then [test your code](#step4-test).
Then, if you've published your code on pub.dev,
[publish a null-safe prerelease](#step5-publish).


### Migrating by hand

If you prefer not to use the migration tool,
you can migrate manually.

We recommend that you **first migrate leaf libraries**—libraries 
that don't import other files from the package.
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

   Running `dart pub get` with a lower SDK constraint of at least `2.12.0`
   sets the default language version of
   every library in the package to a minimum of 2.12,
   opting them all in to null safety.

3. Open the package in your IDE. <br>
   You're likely to see a lot of analysis errors.
   That's OK.

4. Migrate the code of each Dart file,
   using the analyzer to identify static errors. <br>
   Eliminate static errors by adding `?`, `!`, `required`, and `late`,
   as needed.

See [Unsound null safety][]
for more help on migrating code by hand.

[Unsound null safety]: /null-safety/unsound-null-safety


## 3. Analyze {#step3-analyze}

Update your packages
(using `dart pub get` in your IDE or on the command line).
Then use your IDE or the command line
to perform [static analysis][] on your code:

```terminal
$ dart pub get
$ dart analyze     # or `flutter analyze`
```

[static analysis]: /tools/analysis


## 4. Test {#step4-test}

If your code passes analysis, run tests:

```terminal
$ dart test       # or `flutter test`
```

You might need to update tests that expect null values.

If you need to make large changes to your code,
then you might need to remigrate it.
If so, revert your code changes before using the migration tool again.


## 5. Publish {#step5-publish}

We encourage you to publish packages—possibly as prereleases—as 
soon as you migrate:

* [Set the package version to indicate a breaking change.](#package-version)
* [Update the SDK constraints and package dependencies.](#check-your-pubspec)
* [Publish the package](/tools/pub/publishing).
  If you don't consider this version to be a stable release, 
  then [publish the package as a prerelease][].

[publish the package as a prerelease]: /tools/pub/publishing#publishing-prereleases

### Update the package version {#package-version}

Update the version of the package
to indicate a breaking change:

* If your package is already at `1.0.0` or greater,
  increase the major version.
  For example, if the previous version is `2.3.2`,
  the new version is `3.0.0`.

* If your package hasn't reached `1.0.0` yet,
  _either_ increase the minor version _or_ update the version to `1.0.0`.
  For example, if the previous version is `0.3.2`,
  the new version is either `0.4.0` or `1.0.0`.

### Check your pubspec

Before you publish a stable null safety version of a package, 
we strongly recommend following these pubspec rules:

* Set the Dart lower SDK constraint to the lowest stable version
  that you've tested against (at least `2.12.0`).
* Use stable versions of all direct dependencies.

## Welcome to null safety

If you made it this far,
you should have a fully migrated, null-safe Dart package.

If all of the packages you depend on are migrated too,
then your program is sound with respect to null-reference errors.
You should see output like this when running or compiling your code:

```terminal
Compiling with sound null safety
```

From all of the Dart team, *thank you* for migrating your code.
