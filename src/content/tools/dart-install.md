---
title: dart install
description: Install Dart CLI tools for global use.
---

The `dart install` command installs Dart CLI tools for global use.
It is a newer alternative to `dart pub global activate`.

## Install a package

There are a few ways to install a package. To learn more,
see the following sections.

### Install a general package

The following command installs all executables specified in
a package's `pubspec.yaml` [executables][] section on the
PATH. If the executables section doesn't exist, it installs all
`bin/*.dart` entry points as executables.

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
$ dart pub install <pub.dev package>
```

For example:

```console
$ dart pub install markdown
```

### Install a Git package

The following commands can both be used to install a package
in a Git repository.

```console
$ dart install --source git <Git URL>
```

```console
$ dart install -sgit <Git URL>
```

The following examples, which install the `async_await` package on
[GitHub][], are equivalent:

```console
$ dart install --source git https://github.com/dart-lang/async_await.git
$ dart install -sgit https://github.com/dart-lang/async_await.git
```

Pub expects to find the package in the root of the Git repository.
To specify a different location, use the `--git-path` option with
a path relative to the repository root:

```console
$ dart install \
  -sgit https://github.com/dart-lang/http.git \
  --git-path pkgs/http/
```

Pub uses the default branch of the Git repository. To specify a
different branch or commit, use the `--git-ref` option:

```console
$ dart install \
  -sgit https://github.com/dart-lang/http.git \
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

| Arguments | Description |
| :--- | :--- |
| **`-s, --source`** | The source used to find the package. Options are `git`, `hosted` (default), and `path`. |
| **`--git-path`** | Path of the git package within the repository. |
| **`--git-ref`** | The specific git branch or commit to retrieve. |
| **`-x, --executable`** | The executable(s) to place on your system's PATH. |
| **`--overwrite`** | Allows overwriting executables from other packages that have the same name. |
| **`-u, --hosted-url`** | A custom pub server URL for the package. This only applies when using the `hosted` source. |

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

Check if a package is installed for Dart.

```console
$ dart installed <package>
```

For example:

```console
$ dart installed markdown
```

## Options

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

### --source

Use the `--source` option to specify the source of the
package. Valid values are `git`, `hosted` (default), and `path`.

```console
$ dart install --source <source>
```

For example:

```console
$ dart install --source ~/dart/stopwatch
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

### -x, --executable

Use the `-x` or `--executable` option to add the specified executable
to your PATH. You can pass more than one of these flags.

```console
$ dart install <executable> -x <another executable> ...
```

For example, the following commands add `bar` and `baz`,
(but not any other executables that `foo` might define) to your PATH.

```console
$ dart install foo -x bar -x baz
```

```console
$ dart install foo --executable bar --executable baz
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
URL for the package. Only applies when using the `hosted` source.

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
