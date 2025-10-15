---
title: dart build
description: Command-line tool for building Dart applications.
---

This guide describes how to use the `dart build` command
to build a Dart application.

## Overview

Use the `dart build` command to build a Dart application,
including code assets.

{% render 'tools/dart-tool-note.md' %}

The `dart build` command has the following subcommand:

<table class="table table-striped nowrap">
  <tr>
    <th> Subcommand </th> <th> Description </th>
  </tr>
  <tr>
    <td> <code>cli</code> </td>
    <td> Build a Dart application with a command line interface (CLI).
      <br><em><a href="#cli">Learn more.</a></em>
    </td>
  </tr>
</table>

For more options and usage information,
run `dart build [<subcommand>] --help`:

```console
$ dart build cli --help
```

## `cli` subcommand {:#cli}

The `cli` subcommand builds a Dart command-line application, including any code assets.

The resulting CLI app bundle is structured in the following manner:

```
bundle/
  bin/
    <executable>
  lib/
    <dynamic libraries>
```

### Options

The `dart build cli` command has the following options:

`-o, --output=<path>`
: Write the output to `<output>/bundle/`.
  This can be an absolute or relative path.
  (defaults to "build/cli/<os>_<arch>/")

`-t, --target=<path>`
: The main entry-point file of the command-line application.
  Must be a Dart file in the `bin/` directory.
  If the `"--target"` option is omitted, and there is a
  single Dart file in `bin/`, then that is used instead.

`--verbosity=<level>`
: Sets the verbosity level of the compilation.
  Can be `error`, `warning`, `info`, or `all`.
