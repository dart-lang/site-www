---
title: dart install
description: Install Dart CLI tools for global use.
---

:::version-note
Support for `dart install` was introduced in Dart 3.10.
:::

The `dart install` command installs Dart CLI tools for global use.
It is a newer alternative to `dart pub global activate`.

## Install a package

There are a few ways to install a package. To learn more,
see the following sections.

### Install a general package

The following command installs all executables specified in
a package's `pubspec.yaml` [executables][] section on the
PATH.

```console
$ dart install [arguments] <package> [version-constraint]
```

For example:

```console
$ dart install markdown
```

### Install a pub.dev package

The following command specifies a package on the pub.dev
site to install.

```console
$ dart install <pub.dev package>
```

For example:

```console
$ dart install markdown
```

### Install a Git package

The following commands can both be used to install a package
in a Git repository.

```console
$ dart install <Git URL>
```

The following example installs the `async_await` package from
[GitHub][]:

```console
$ dart install https://github.com/dart-lang/async_await.git
```

Pub expects to find the package in the root of the Git repository.
To specify a different location, use the `--git-path` option with
a path relative to the repository root:

```console
$ dart install \
  https://github.com/dart-lang/http.git \
  --git-path pkgs/http/
```

Pub uses the default branch of the Git repository. To specify a
different branch or commit, use the `--git-ref` option:

```console
$ dart install \
  https://github.com/dart-lang/http.git \
  --git-ref 36f98e900347335af2338a0e087538009b7de2f9
```

## Command reference

The following commands are useful for installing,
uninstalling, and checking the install state of a
Dart CLI tool.

### dart install

Installs a package for Dart.

```console
$ dart install [arguments] <package> [version-constraint]
```

| Arguments              | Description                                                                                            |
| :--------------------- | :----------------------------------------------------------------------------------------------------- |
| **`--git-path`**       | Path of the git package within the repository. This only applies when using a git URL for `<package>`. |
| **`--git-ref`**        | The specific git branch or commit to retrieve. This only applies when using a git URL for `<package>`. |
| **`--overwrite`**      | Allows overwriting executables from other packages that have the same name.                            |
| **`-u, --hosted-url`** | A custom pub server URL for the package. This only applies when using a package name for `<package>`.  |

In the following example, the markdown package is installed
with no arguments or version constraints:

```console
$ dart install markdown
```

### dart uninstall

Uninstall a package for Dart.

```console
$ dart uninstall <package>
```

For example:

```console
$ dart uninstall markdown
```

### dart installed

Check which packages are installed

```console
$ dart installed
```

## Options for the dart install command

These options can be use for the `dart install` command.
For options that apply to all pub commands, see
[Global options][].

### -h, --help

Use the `-h` or `--help` option to get help for a specific command.
For example, the following commands produce an overview and list
of arguments available to `dart install`:

```console
$ dart install --help
```

```console
$ dart install -h
```

### --git-path

Use the `--git-path` option to specify the path of the
package in the Git repository.

```console
$ dart install --git-path <path>
```

For example:

```console
$ dart install --git-path https://github.com/dart-lang/async_await.git
```

### --git-ref

Use the `--git-ref` option to specify the Git branch or commit
to be retrieved.

```console
$ dart install --git-ref <ref>
```

For example:

```console
$ dart install --git-ref tmpfixes
```

### --overwrite

Use the `--overwrite` option to overwrite any previously
installed global executables with the same name. If you don't specify
this flag, the preexisting executable will not be replaced.

```console
$ dart install <package> --overwrite
```

For example:

```console
$ dart install markdown --overwrite
```

### --hosted-url

Use the `--hosted-url` option to specify a custom pub server
URL for the package. This only applies when using a package name
for `<package>`.

```console
$ dart install --hosted-url <url>
```

For example:

```console
$ dart install --hosted-url https://dart-packages.example.com/
```

### [version-constraint]

Use the `version-constraint` option to specify a specific version
of the package.

```console
$ dart install <package> [version-constraint]
```

For example, the following command
pulls the 0.6.0 version of the `markdown` package:

```console
$ dart install markdown 0.6.0
```

If you specify a range, pub picks the best version that meets that
constraint. For example:

```console
$ dart install foo <3.0.0
```

[pub tool]: /tools/pub/cmd
[executables]: https://dart.dev/tools/pub/pubspec#executables
[GitHub]: https://github.com/
[Global options]: /tools/pub/cmd#global-options
