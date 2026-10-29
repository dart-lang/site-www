---
title: dart migrate
description: >-
  Command-line tool for migrating Dart projects to newer SDK versions.
---

:::version-note
Support for `dart migrate` was introduced in Dart 3.14.
:::

Use the `dart migrate` command to upgrade your Dart project
(app or package) to a newer [language version][].
It updates the minimum Dart SDK version constraint (`environment.sdk`)
in your `pubspec.yaml` file and
applies any automated code fixes required by that version change.

`dart migrate` only updates your project's SDK constraint and source code—it
doesn't upgrade the Dart or Flutter SDK installed on your machine.
To upgrade your installed SDK first,
refer to [Get the Dart SDK][] or [`flutter upgrade`][].

## Migrate a project

Run `dart migrate` from your project's root directory.
Preview the proposed changes first with `--dry-run`,
then apply them to `pubspec.yaml` and your source files with `--apply`:

```console
$ dart migrate --dry-run
$ dart migrate --apply
```

Because `dart migrate` doesn't check for uncommitted changes
in version control, save all open files and commit or stash any
uncommitted work before running `dart migrate --apply`.

### Migrate multiple projects

By default, `dart migrate` migrates the project
in the current working directory.
To migrate multiple projects at once,
pass their directory paths as arguments:

```console
$ dart migrate --apply my_app packages/my_pkg
```

`dart migrate` doesn't automatically expand [Pub workspaces][].
To migrate packages in a workspace,
pass each package's directory path to the command.

## Options for `dart migrate`

The following options are available for the `dart migrate` command.

### `-h`, `--help`

Print usage information for `dart migrate`.

```console
$ dart migrate --help
```

### `-n`, `--dry-run`

Preview the proposed migration changes without modifying any files.

```console
$ dart migrate -n
```

### `--apply`

Apply the proposed changes directly to `pubspec.yaml` and your source files.

```console
$ dart migrate --apply
```

### `--target-sdk`

Specify the target Dart SDK version to migrate to.
Without this option, `dart migrate` bumps the lower SDK constraint
in `pubspec.yaml` by one minor version
(for example, from `^3.12.0` to `^3.13.0`).
The target version can't be newer than the Dart SDK version
currently installed on your machine.

When you specify a `--target-sdk` version
that is multiple minor versions ahead,
`dart migrate` runs the migration incrementally,
one minor version at a time, until it reaches the target version:

```console
$ dart migrate --apply --target-sdk=3.13.0
```

### `--step`

Specify which migration steps to run:
`prepare`, `bump`, `cleanup`, or `all`
(for details on each step, refer to [How migration works][]).
You can pass a single step or a comma-separated list of steps.
If omitted, `dart migrate` runs `prepare,bump` by default.

```console
$ dart migrate --apply --step=all
$ dart migrate --apply --step=prepare
```

:::note
You can't run the `prepare` and `cleanup` steps together
(`--step=prepare,cleanup`) without also including `bump`.
:::

## How migration works

When you run `dart migrate`,
the tool automatically runs the relevant migration lints and quick fixes
for the target version—even if those lints aren't enabled
in your [`analysis_options.yaml`][] file.
It performs the following stages in order:

1. **Dependency check:**
   Verifies that your project's dependencies in `pubspec.yaml`
   support the target Dart SDK version.
   If any dependencies are incompatible,
   the tool stops and reports which packages need to be updated first.
1. **`prepare` (pre-bump fixes):**
   Applies automated fixes for code that breaks or changes behavior
   in the target [language version][] before changing `pubspec.yaml`.
1. **`bump` (SDK constraint update):**
   Raises the lower `environment.sdk` constraint in `pubspec.yaml`
   and re-analyzes your project under the new language version.
1. **`cleanup` (optional post-bump fixes):**
   Applies optional fixes that help your code adopt new language features
   introduced in the target version.
   By default, `dart migrate` doesn't apply `cleanup` fixes automatically;
   instead, it lists available cleanups in its summary output
   so you can choose whether to apply them
   with `--step=cleanup` or `--step=all`.

If any step fails, `dart migrate` leaves your source files
and `pubspec.yaml` unchanged.
Instead, it outputs a summary of the incompatible dependencies
or files with errors so you can resolve them manually
and run `dart migrate` again.

### Example

Suppose your project's `pubspec.yaml` has a minimum SDK constraint of `3.12.0`:

```yaml title="pubspec.yaml"
environment:
  sdk: ^3.12.0
```

And your code uses `final` on a regular function parameter,
which became a compile-time error in Dart 3.13
when [primary constructors][] were introduced:

```dart title="lib/greeter.dart"
void greet(final String name) {
  print('Hello, $name!');
}
```

When you run `dart migrate --apply`:

```console
$ dart migrate --apply
```

`dart migrate` performs the following changes:

1. Runs the `prepare` step,
   which removes the `final` modifier from the parameter in `lib/greeter.dart`:

   ```dart title="lib/greeter.dart"
   void greet(String name) {
     print('Hello, $name!');
   }
   ```

1. Runs the `bump` step,
   which updates `pubspec.yaml` to require Dart 3.13:

   ```yaml title="pubspec.yaml"
   environment:
     sdk: ^3.13.0
   ```

## When to use `dart migrate` vs. `dart fix`

While both tools apply automated fixes to your code,
they serve different purposes:

* **`dart migrate`** upgrades your project's minimum Dart SDK constraint
  in `pubspec.yaml` and migrates your code to a newer [language version][].
* **[`dart fix`][]** fixes analyzer diagnostics, lint warnings,
  and outdated package API usages ([data-driven fixes][])
  in your existing code without changing your project's SDK version constraint.

[language version]: /language/versioning
[Get the Dart SDK]: /get-dart
[`flutter upgrade`]: {{site.flutter-docs}}/release/upgrade
[Pub workspaces]: /tools/pub/workspaces
[How migration works]: #how-migration-works
[`analysis_options.yaml`]: /tools/analysis
[primary constructors]: /language/primary-constructors
[`dart fix`]: /tools/dart-fix
[data-driven fixes]: /tools/pub/data-driven-fixes
