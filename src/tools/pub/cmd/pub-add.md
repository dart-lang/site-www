---
title: dart pub add
description: Use dart pub add to add a dependency.
---

_Add_ is one of the commands of the [pub tool](/tools/pub/cmd).

```nocode
$ dart pub add [{dev|override}:]<package>[:descriptor] [[{dev|override}:]<package>[:descriptor] ...] [options]
```

This command adds the specified packages to the `pubspec.yaml` as dependencies,
and then retrieves the dependencies to resolve `pubspec.yaml`.

The following example command is equivalent to
editing `pubspec.yaml` to add the `http` package,
and then calling `dart pub get`:

```terminal
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

```terminal
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

```terminal
$ dart pub add dev:foo           # adds newest compatible stable version of foo
$ dart pub add dev:foo:^2.0.0    # adds specified constraint of foo
$ dart pub add foo dev:bar       # adds regular dependency foo and dev dependency bar simultaneously
```

_Previously the `-d, --dev` option_:

```terminal
$ dart pub add --dev foo
```

## Dependency override

To specify a [dependency override][], add the `override:` prefix and
include a [version constraint](#version-constraint) or
[source descriptor](#source-descriptor).

[dependency override]: /tools/pub/dependencies#dependency-overrides

**For example:** To override all references to `package:foo`
to use version `1.0.0` of the package,
run the following command:

```terminal
$ dart pub add override:foo:1.0.0
```

This adds the override to your `pubspec.yaml` file:

```yaml
dependency_overrides:
  foo: 1.0.0
```

## Source descriptor

{{site.alert.version-note}}
  The YAML-formatted descriptor syntax was added in Dart 2.19.
  The descriptor replaces arguments like
  `--path`, `--sdk`, `--git-<option>`, etc.
  Pub still supports these arguments, but
  the recommended method is now the YAML-descriptor.
  The descriptor and the replaced arguments can't be used together.
{{site.alert.end}}

The YAML descriptor syntax allows you to add 
multiple packages from different sources, and 
apply different options and constraints to each.

```nocode
$ dart pub add [options] [{dev|override}:]<package>[:descriptor] [[{dev|override}:]<package>[:descriptor] ...]
```

The syntax reflects how dependencies are written in `pubspec.yaml`.

```nocode
'<package>:{"<source>":"<descriptor>"[,"<source>":"<descriptor>"],"version":"<constraint>"}'
```

### `git`

Adds a [git dependency](/tools/pub/dependencies#git-packages).

```terminal
$ dart pub add 'foo:{"git":"https://github.com/foo/foo"}'
```

You can specify the repository, and the branch or commit, or exact location,
within that repository:

```terminal
$ dart pub add 'foo:{"git":{"url":"../foo.git","ref":"branch","path":"subdir"}}'
```

#### `url`

Depends on the package in the specified Git repository.

_Previously the `--git-url=<git_repo_url>` option_:

```terminal
$ dart pub add http --git-url=https://github.com/my/http.git
```

#### `ref`

With `url`, depends on the specified branch or commit of a Git repo.

_Previously the `--git-ref=<branch_or_commit>` option_:

```terminal
$ dart pub add http --git-url=https://github.com/my/http.git --git-ref=tmpfixes
```

#### `path`

With `url`, specifies the location of a package within a Git repo.

_Previously the `--git-path=<directory_path>` option_.

### `hosted`

Adds a [hosted dependency][] that depends on
the package server at the specified URL.

```terminal
$ dart pub add 'foo:{"hosted":"my-pub.dev"}'
```

_Previously the `--hosted-url=<package_server_url>` option_.

[hosted dependency]: /tools/pub/dependencies#hosted-packages

### `path`

Adds a [path dependency][] on a locally stored package.

```terminal
$ dart pub add 'foo:{"path":"../foo"}'
```

_Previously the `--path=<directory_path>` option_.

[path dependency]: /tools/pub/dependencies#path-packages

### `sdk`

Adds a package from the specified SDK source.

```terminal
$ dart pub add 'foo:{"sdk":"flutter"}'
```

_Previously the `--sdk=<sdk_name>` option_:

```terminal
$ dart pub add foo --sdk=flutter
```

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

{{site.alert.note}}
  The previous `pub add` syntax for options
  (without YAML descriptors) applies the
  specified options to all the packages
  included in an invocation of the command.
  For example, `dart pub add test http --dev`
  will add both the `test` and `http` packages
  as dev dependencies.
{{site.alert.end}}

### `--[no-]offline`

{% include tools/pub-option-no-offline.md %}

### `-n, --dry-run`

Reports which dependencies would change,
but doesn't change any.

### `--[no-]precompile`

By default, pub precompiles executables
in immediate dependencies (`--precompile`).
To prevent precompilation, use `--no-precompile`.

{{site.alert.info}}
  *Problems?*
  See [Troubleshooting Pub](/tools/pub/troubleshoot).
{{site.alert.end}}
