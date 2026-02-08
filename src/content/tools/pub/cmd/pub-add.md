---
title: dart pub add
description: Use dart pub add to add a dependency.
---

_Add_ is one of the commands of the [pub tool](/tools/pub/cmd).

```plaintext
$ dart pub add [{dev|override}:]<package>[:<descriptor>] [[{dev|override}:]<package>[:<descriptor>] ...] [options]
```

This command adds the specified packages to the `pubspec.yaml` as dependencies,
and then retrieves the dependencies to resolve `pubspec.yaml`.

The following example command is equivalent to
editing `pubspec.yaml` to add the `http` package,
and then calling `dart pub get`:

```console
$ dart pub add http
```

## Version constraint

By default, `dart pub add` uses the
latest stable version of the package from the [pub.dev site]({{site.pub}})
that is compatible with your SDK constraints and dependencies.
For example, if `0.13.3` is the latest stable version of the `http` package,
then `dart pub add http` adds `http: ^0.13.3`
under `dependencies` in your `pubspec.yaml`.

You can also specify a constraint or constraint range:

```console
$ dart pub add foo:2.0.0
$ dart pub add foo:'^2.0.0'
$ dart pub add foo:'>=2.0.0 <3.0.1'
```

If the specified package is an existing dependency in your `pubspec.yaml`,
`dart pub add` updates the dependency's constraint
to the one specified in the command.

## Dev dependency

The `dev:` prefix adds the package as a [dev dependency][],
instead of as a regular dependency.

[dev dependency]: /tools/pub/dependencies#dev-dependencies

```console
$ dart pub add dev:foo           # adds newest compatible stable version of foo
$ dart pub add dev:foo:^2.0.0    # adds specified constraint of foo
$ dart pub add foo dev:bar       # adds regular dependency foo and dev dependency bar simultaneously
```

_Previously the `-d, --dev` option_:

```console
$ dart pub add --dev foo
```

## Dependency override

To specify a [dependency override][], add the `override:` prefix and
include a [version constraint](#version-constraint) or other
[package descriptor](/tools/pub/dependencies#package-descriptors).

[dependency override]: /tools/pub/dependencies#dependency-overrides

**For example:** To override all references to `package:foo`
to use version `1.0.0` of the package,
run the following command:

```console
$ dart pub add override:foo:1.0.0
```

This adds the override to your `pubspec.yaml` file:

```yaml
dependency_overrides:
  foo: 1.0.0
```

<a id="source-descriptor" aria-hidden="true"></a>

## Package descriptor

To specify the version or [dependency source][] when adding a dependency,
use the [package descriptor][] syntax after the package name and a colon.
For example, the following command adds `package:foo` as a dev dependency
using a git repository as the dependency source:

```console
$ dart pub add dev:foo:"{git: https://github.com/foo/foo}"
```

The descriptor syntax allows you to
add multiple packages from different sources as dependencies and
apply different options and constraints to each.

[dependency source]: /tools/pub/dependencies#dependency-sources
[package descriptor]: /tools/pub/dependencies#package-descriptors

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

### `--[no-]offline`

{% render 'tools/pub-option-no-offline.md' %}

### `-n, --dry-run`

Reports which dependencies would change,
but doesn't change any.

### `--[no-]precompile`

By default, pub precompiles executables
in immediate dependencies (`--precompile`).
To prevent precompilation, use `--no-precompile`.

## In a workspace

In a [Pub workspace](/tools/pub/workspaces) `dart pub add` will add
dependencies only to the package in the current directory.

{% render 'pub-problems.md' %}
