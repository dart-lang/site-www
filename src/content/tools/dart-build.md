---
title: dart build
description: Command-line tool for building Dart applications.
---

:::version-note
Support for `dart build` was introduced in Dart 3.10.
:::

Use the `dart build` command to build a Dart application.
This command automatically runs [build hooks](/tools/hooks) 
from your project and its dependencies to compile or download 
code assets and bundle them with your application.


## Build a CLI application 

The `dart build cli` command
builds a Dart application with a command-line interface (CLI)
including any code assets.

The resulting app bundle is structured as follows:

```plaintext
bundle/
  bin/
    <executable>
  lib/
    <dynamic libraries>
```

## Options for `dart build cli`

The following options can be used for the `dart build cli` command. 
For options that apply to all pub commands, see [Global options][].

### `-h`, `--help`

Use the `-h` or `--help` option to get help for the `cli` subcommand.

```console
$ dart build cli --help
```

```console
$ dart build cli -h
```


### `-o`, `--output`

Use `-o` or `--output` to specify where `dart build` saves 
the generated files. The output is placed in a `bundle/` directory 
within the given path, which can be absolute or relative. 
If omitted, the default path is `build/cli/_/`.

```console
$ dart build cli --output=<path>
```

```console
$ dart build cli -o=<path>
```

For example:
```console
$ dart build cli --output=./my_custom_output
```


### `-t`, `--target`

Use the `-t` or `--target` option to specify the main entry-point 
file of the command-line application.

This must be a Dart file in the `bin/` directory. 
If the option is omitted and there is a single 
Dart file in `bin/`, then that is used instead.

```console
$ dart build cli --target=<path>
```
```console
$ dart build cli -t=<path>
```

For example:
```console
$ dart build cli --target=bin/my_command.dart
```

### `--verbosity`

Use the `--verbosity` option to set the verbosity level of the 
compilation. The level can be `error`, `warning`, `info`, or `all`.

```console
$ dart build cli --verbosity=<level>
```

For example:
```console
$ dart build cli --verbosity=error
```


[Global options]: /tools/pub/cmd#global-options