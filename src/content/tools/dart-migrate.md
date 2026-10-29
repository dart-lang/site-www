---
title: dart migrate
description: >-
  Command-line tool for migrating Dart packages to newer SDK versions.
---

:::version-note
Support for `dart migrate` was introduced in Dart 3.14.
:::

The `dart migrate` command updates the minimum Dart SDK version constraint
in a project's `pubspec.yaml` file and
applies automated code fixes required by that version change.

{% render 'tools/dart-tool-note.md' %}

:::note
`dart migrate` updates the `environment.sdk` constraint
in your project's `pubspec.yaml` file and migrates your source code.
It doesn't upgrade the Dart or Flutter SDK installed on your machine.
To upgrade your installed SDK,
refer to [Get the Dart SDK][] or [`flutter upgrade`][].
:::

## Migrate a package

To preview proposed migration changes without modifying any files,
use the `--dry-run` flag:

```console
$ dart migrate --dry-run
```

To apply the proposed changes to `pubspec.yaml` and your source files,
use the `--apply` flag:

```console
$ dart migrate --apply
```

:::tip
`dart migrate` doesn't check for uncommitted changes in version control.
Before running `dart migrate --apply`,
save all open files and commit or stash any uncommitted changes
so you can easily review or revert the migration diff.
:::

By default, `dart migrate` migrates the package
in the current working directory.
To migrate one or more specific packages,
pass their directory paths as arguments:

```console
$ dart migrate --apply pkg_a pkg_b
```

:::note
`dart migrate` doesn't automatically migrate all packages
in a [Pub workspace][].
To migrate packages in a workspace,
pass each package directory path to the command.
:::

## How migration works

When you run `dart migrate`,
the tool automatically runs the migration lints and quick fixes
for the target version—without requiring you to enable them
in your [`analysis_options.yaml`][] file first.
It performs the following tasks in order:

1. **Checks package dependencies:**
   Verifies that your project's dependencies in `pubspec.yaml`
   are compatible with the target Dart SDK version.
   If any dependencies are incompatible,
   the tool stops and reports which packages need to be updated first.
1. **Prepares code (`prepare`):**
   Applies automated fixes for code that breaks or changes behavior
   in the target [language version][].
1. **Bumps the SDK constraint (`bump`):**
   Raises the lower Dart SDK version constraint in `pubspec.yaml`
   and re-analyzes your project under the new language version.
   By default, `dart migrate` bumps the constraint by one minor version
   (for example, from `^3.11.0` to `^3.12.0`).
1. **Applies optional cleanups (`cleanup`):**
   When requested with `--step=cleanup` or `--step=all`,
   applies optional fixes that adopt new language features
   introduced in the target version.
   If you don't run the `cleanup` step,
   `dart migrate` lists any available cleanups in its summary output.

`dart migrate` computes all edits in memory
and only writes changes to disk after the migration succeeds.
If a step fails, the tool doesn't modify your source files
or bump `pubspec.yaml`.
Instead, it outputs a summary of the incompatible dependencies
or files with errors so you can resolve them manually and re-run the command.

## Options for `dart migrate`

The following options are available for the `dart migrate` command.

### `-h`, `--help`

Print usage information for `dart migrate`.

```console
$ dart migrate --help
```

### `-n`, `--dry-run`

Preview the proposed changes without modifying any files.

```console
$ dart migrate --dry-run
```

### `--apply`

Apply the proposed changes directly to `pubspec.yaml` and the source files.

```console
$ dart migrate --apply
```

### `--target-sdk`

Specify the target Dart SDK version to migrate to.
Without this option, `dart migrate` bumps the lower SDK constraint
in `pubspec.yaml` by one minor version.
The target version can't be newer than the Dart SDK version
currently installed on your machine.

When you specify a `--target-sdk` version
that is multiple minor versions ahead,
`dart migrate` runs the migration incrementally,
one minor version at a time, until it reaches the target version.

Preview a multi-version migration first with `--dry-run`:

```console
$ dart migrate --dry-run --target-sdk=3.13.0
```

Then apply the migration:

```console
$ dart migrate --apply --target-sdk=3.13.0
```

### `--step`

Specify which migration steps to run.
You can pass a single step or a comma-separated list of steps.
If omitted, `dart migrate` runs `prepare,bump` by default.

The following step values are supported:

| Step | Description |
| :--- | :--- |
| `prepare` | Apply fixes that make code ready for the new SDK version. |
| `bump` | Raise the lower Dart SDK constraint in `pubspec.yaml`. |
| `cleanup` | Apply optional fixes that adopt features of the new SDK version. |
| `all` | Run every step (`prepare`, `bump`, and `cleanup`). |

{:.table .table-striped}

For example, to run only the pre-bump preparation fixes on a large codebase
before bumping the SDK version:

```console
$ dart migrate --apply --step=prepare
```

To run the full migration including optional post-bump cleanups:

```console
$ dart migrate --apply --step=all
```

To run only the post-bump cleanup step after you have already bumped
your SDK version constraint:

```console
$ dart migrate --apply --step=cleanup
```

:::note
You can't run the `prepare` and `cleanup` steps together
(`--step=prepare,cleanup`) without also including `bump`.
:::

## Example

Suppose your package's `pubspec.yaml` has a minimum SDK constraint of `3.12.0`:

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

* **`dart migrate`** helps you move forward to a newer Dart SDK version.
  It orchestrates the full version upgrade:
  applying pre-bump fixes, raising the `sdk` constraint in `pubspec.yaml`,
  re-analyzing your code under the new [language version][],
  and allowing you to run each migration step individually.
* **[`dart fix`][]** fixes analyzer diagnostics, lint warnings,
  and outdated package API usages ([data-driven fixes][])
  in your existing code without changing your project's SDK version constraint.

[Get the Dart SDK]: /get-dart
[`flutter upgrade`]: {{site.flutter-docs}}/release/upgrade
[Pub workspace]: /tools/pub/workspaces
[`analysis_options.yaml`]: /tools/analysis
[language version]: /language/versioning
[primary constructors]: /language/primary-constructors
[`dart fix`]: /tools/dart-fix
[data-driven fixes]: /tools/pub/data-driven-fixes
