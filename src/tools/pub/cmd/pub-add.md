---
title: dart pub add
description: Use dart pub add to add a dependency.
---

_Add_ is one of the commands of the [pub tool](/tools/pub/cmd).

```nocode
$ dart pub add <package>[:<constraint>] [<package2>[:<constraint2>]... ] [options]
```

This command adds the specified packages to the pubspec as dependencies, 
and then gets the dependencies.

For example, the following command is equivalent to
editing `pubspec.yaml` to add the `http` package, 
and then calling `dart pub get`:

```terminal
$ dart pub add http
```

By default, `dart pub add` uses the
latest stable version of the package from the [pub.dev site]({{site.pub}}).
For example, if 0.13.3 is the latest stable version of the `http` package,
then `dart pub add http` adds
`http: ^0.13.3` under `dependencies` in the pubspec.

To add a [dev dependency][], use the `--dev` option:

[dev dependency]: /tools/pub/dependencies#dev-dependencies

```terminal
$ dart pub add --dev test
```

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

{{site.alert.note}}
  Any specified options will apply to all the packages
  included in an invocation of the command.
  For example, `dart pub add test http --dev` 
  will add both the `test` and `http` packages 
  as dev dependencies.
{{site.alert.end}}

### `-d, --dev`

Adds the package as a dev dependency,
instead of as a regular dependency.

### `--git-url=`_`<git_repo_url>`_

Depends on the package in the
[specified Git repository](/tools/pub/dependencies#git-packages).

```terminal
$ dart pub add http --git-url=https://github.com/my/http.git
```

### `--git-ref=`_`<branch_or_commit>`_

With `--git-url`, depends on the specified branch or commit of a Git repo.

```terminal
$ dart pub add http --git-url=https://github.com/my/http.git --git-ref=tmpfixes
```

### `--git-path=`_`<directory_path>`_

With `--git-url`, specifies the location of a package within a Git repo.

### `--hosted-url=`_`<package_server_url>`_

Depends on the package server at the specified URL.

### `--path=`_`<directory_path>`_

Depends on a locally stored package.

### `--sdk=`_`<sdk_name>`_

Depends on a package that's shipped with the specified SDK
(example: `--sdk=flutter`).

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
