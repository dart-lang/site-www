---
title: dart migrate
description: >-
  Command-line tool for migrating Dart projects to newer SDK versions.
---

:::version-note
Support for `dart migrate` was introduced in Dart 3.14.
:::

To upgrade your Dart project (app or package)
to a newer [language version][],
use the `dart migrate` command.
It updates the minimum Dart SDK version constraint (`environment.sdk`)
in your `pubspec.yaml` file and
applies any automated code fixes required by that version change.
The `dart migrate` command supports projects whose minimum SDK constraint
requires Dart 3.0 or later.

The `dart migrate` command only updates your project's SDK constraint
and source code.
It doesn't upgrade the Dart or Flutter SDK installed on your machine.
To upgrade your installed SDK first,
refer to [Get the Dart SDK][] or the [`flutter upgrade`][] command.

## Migrate a project

Run the `dart migrate` command from your project's root directory.
Preview the proposed changes first by using the `--dry-run` option,
and then apply them to your `pubspec.yaml` file and source files
by using the `--apply` option:

```console
$ dart migrate --dry-run
$ dart migrate --apply
```

Because the `dart migrate` command doesn't check for uncommitted changes
in version control, save all open files and commit or stash any
uncommitted work before running `dart migrate --apply`.

### Migrate multiple projects

By default, the `dart migrate` command migrates the project
in the current working directory.
To migrate multiple projects at once,
pass their directory paths as arguments:

```console
$ dart migrate --apply my_app packages/my_pkg
```

The `dart migrate` command doesn't automatically expand [Pub workspaces][].
To migrate packages in a workspace,
pass each package's directory path to the command.

## Options for `dart migrate`

The following options are available for the `dart migrate` command.

### `-h`, `--help`

Print usage information for the `dart migrate` command.

```console
$ dart migrate --help
```

### `-n`, `--dry-run`

Preview the proposed migration changes without modifying any files.

```console
$ dart migrate -n
```

### `--apply`

Apply the proposed changes directly to your `pubspec.yaml` file
and source files.

```console
$ dart migrate --apply
```

### `--target-sdk`

Specify the target Dart SDK version to migrate to.
Without this option, the `dart migrate` command raises the lower SDK constraint
in the `pubspec.yaml` file by one minor version
(for example, from `^3.12.0` to `^3.13.0`).
The target version can't be newer than the Dart SDK version
currently installed on your machine.

When you specify a `--target-sdk` version
that is multiple minor versions ahead,
the `dart migrate` command runs the migration incrementally,
one minor version at a time, until it reaches the target version:

```console
$ dart migrate --apply --target-sdk=3.13.0
```

### `--step`

Specify which migration steps to run:
`prepare`, `bump`, `cleanup`, or `all`.
For details about each step,
refer to the [How migration works][] section of this page.
You can pass a single step or a comma-separated list of steps.
If you omit this option,
the `dart migrate` command runs `prepare,bump` by default.

Running specific steps is useful for larger codebases
where you want to review fixes before or after bumping the SDK constraint:

```console
# Run only preparatory fixes without bumping the constraint
$ dart migrate --apply --step=prepare

# After applying preparatory fixes, bump the constraint and apply cleanups
$ dart migrate --apply --step=bump,cleanup
```

:::note
All preparatory fixes for the target SDK version must be completed
before running the `bump` step.
If you run `--step=bump` while required `prepare` fixes remain unapplied,
the `dart migrate` command stops without updating your `pubspec.yaml` file.
:::

## How migration works

When you run the `dart migrate` command,
the tool automatically runs the relevant migration lints and quick fixes
for the target version, even if your [`analysis_options.yaml`][] file
doesn't enable those lints.
It performs the following stages in order:

1. **Dependency check.**
   It verifies that your project's dependencies in the `pubspec.yaml` file
   support the target Dart SDK version.
   If any dependencies are incompatible,
   the tool stops and reports which packages need to be updated first.
1. **The `prepare` step (pre-bump fixes).**
   It applies automated fixes for code that breaks or changes behavior
   in the target [language version][] before changing the `pubspec.yaml` file.
1. **The `bump` step (SDK constraint update).**
   It raises the lower `environment.sdk` constraint in the `pubspec.yaml` file
   and re-analyzes your project under the new language version.
1. **The `cleanup` step (optional post-bump fixes).**
   It applies optional fixes that help your code adopt new language features
   introduced in the target version.
   By default, the `dart migrate` command doesn't apply `cleanup` fixes
   automatically.
   Instead, it lists available cleanups in its summary output
   so you can choose whether to apply them
   by using the `--step=cleanup` or `--step=all` option.

If any step fails, the `dart migrate` command leaves your source files
and the `pubspec.yaml` file unchanged.
Instead, it outputs a summary of the incompatible dependencies
or files with errors so you can resolve them manually
and run the `dart migrate` command again.

### Example

Suppose your project (`my_pkg`) has a `pubspec.yaml` file
with a minimum SDK constraint of `3.12.0`:

```yaml title="pubspec.yaml"
name: my_pkg
environment:
  sdk: ^3.12.0
```

Suppose also that your `lib/greeter.dart` file defines an empty exception class
and uses the `final` modifier on non-declaring function parameters
(which became a compile-time error in Dart 3.13
when [primary constructors][] reserved `final` and `var`
for declaring parameters):

```dart title="lib/greeter.dart"
class EmptyNameException implements Exception {}

void greet(final String greeting, final String name) {
  if (name.isEmpty) {
    throw EmptyNameException();
  }
  print('$greeting, $name!');
}
```

First, preview the migration by running `dart migrate --dry-run`:

```console
$ dart migrate --dry-run
```

The `dart migrate` command outputs a summary of the proposed `prepare`
and `bump` changes, along with any optional `cleanup` fixes available
for the target version:

```text
my_pkg:
  3.12.0 -> 3.13.0:
    Preparatory changes:
      2 changes would be made in 1 file.

      my_pkg/lib/greeter.dart
        avoid_final_parameters • 2 changes

    SDK constraint:
      Would bump ^3.12.0 -> ^3.13.0

Optional cleanup fixes can modernize your code further:

  my_pkg: 1 change in 1 file
    empty_container_bodies • 1 change

To preview them, apply this migration, run 'dart pub get', and then run 'dart migrate --dry-run --step=cleanup' on the same packages.

To apply the proposed changes, run:
  dart migrate --apply
```

Once you're satisfied with the preview, you can run `dart migrate --apply`
(and include `--step=all` or `--step=prepare,bump,cleanup` if you also want
to apply the optional `cleanup` fixes shown in the summary):

```console
$ dart migrate --apply --step=all
```

The `dart migrate` command performs the following changes:

1. It runs the `prepare` step,
   which removes the `final` modifiers from the parameters
   in the `lib/greeter.dart` file ([`avoid_final_parameters`][]).
1. It runs the `bump` step,
   which updates the `pubspec.yaml` file to require Dart 3.13:

   ```yaml title="pubspec.yaml"
   name: my_pkg
   environment:
     sdk: ^3.13.0
   ```

1. It runs the `cleanup` step,
   which replaces the empty `{}` class body with `;`
   ([`empty_container_bodies`][]), resulting in the updated
   `lib/greeter.dart` file:

   ```dart title="lib/greeter.dart"
   class EmptyNameException implements Exception;

   void greet(String greeting, String name) {
     if (name.isEmpty) {
       throw EmptyNameException();
     }
     print('$greeting, $name!');
   }
   ```

## When to use `dart migrate` versus `dart fix`

While both tools apply automated fixes to your code,
they serve different purposes:

* The **`dart migrate`** command upgrades your project's minimum
  Dart SDK constraint in the `pubspec.yaml` file and
  migrates your code to a newer [language version][].
  It runs its own set of required and recommended migrations
  for each SDK version, regardless of which lint rules are enabled
  in your [`analysis_options.yaml`][] file.
* The **[`dart fix`][]** command fixes analyzer diagnostics, lint warnings,
  and outdated package API usages ([data-driven fixes][])
  in your existing code without changing your project's SDK version constraint.
  For lint rules, `dart fix` only applies fixes for lints that are
  enabled in your project's [`analysis_options.yaml`][] file.

[language version]: /language/versioning
[Get the Dart SDK]: /get-dart
[`flutter upgrade`]: {{site.flutter-docs}}/release/upgrade
[Pub workspaces]: /tools/pub/workspaces
[How migration works]: #how-migration-works
[`analysis_options.yaml`]: /tools/analysis
[primary constructors]: /language/primary-constructors
[`avoid_final_parameters`]: /tools/linter-rules/avoid_final_parameters
[`empty_container_bodies`]: /tools/linter-rules/empty_container_bodies
[`dart fix`]: /tools/dart-fix
[data-driven fixes]: /tools/pub/data-driven-fixes
