---
title: dart create
description: Command-line tool for creating Dart projects.
toc: false
---

This guide describes how to use the `dart create` command to
create a Dart project.

## Overview

The `dart create` command creates a Dart project,
using one of several supported templates.
The same functionality is available in IDEs.

{% render 'tools/dart-tool-note.md' %}

When you run `dart create`, it first creates a directory with the
project files. Then it gets package dependencies
(unless you specify the `--no-pub` flag).

## Create a basic Dart project

To create a basic Dart project, follow the `dart create` command
with the name of your project. In the following example,
a directory named `my_cli` that contains a
simple console app (the default template) is created:

```console
$ dart create my_cli
```

## Specify a template

To use a different template, use the `-t` (or `--template`)
flag followed by the template name:

```console
$ dart create -t web my_web_app
```

The `-t` flag allows you to specify which type of Dart project
you want to create. If you don't specify a template, `dart create`
uses the `console` template by default.

## Available templates

The following table shows the templates you can use with the
`-t` flag:

| Template       | Description                                                                                           |
|----------------|-------------------------------------------------------------------------------------------------------|
| `cli`          | A command-line application with basic argument parsing using [`package:args`]({{site.pub-pkg}}/args). |
| `console`      | A command-line application (default template).                                                       |
| `package`      | A package containing shared Dart libraries.                                                           |
| `server-shelf` | A server built using [shelf][].                                                                       |
| `web`          | A web app built using core Dart libraries.                                                            |

{:.table .table-striped .nowrap}

[shelf]: {{site.pub-pkg}}/shelf

These templates result in a file structure that follows
[package layout conventions](/tools/pub/package-layout).

## Additional options

Additionally, you can perform the following actions with
the `dart create` command.

### Force project creation

If the specified directory already exists, `dart create` fails. 
You can force project generation with the `--force` flag:

```console
$ dart create --force <DIRECTORY>
```

### Get help

For further information on command-line options, use the `--help` flag:

```console
$ dart create --help
```

{% comment %}
```
Create a new Dart project.

Usage: dart create [arguments] <directory>
-h, --help                       Print this usage information.
-t, --template                   The project template to use.

          [console] (default)    A command-line application.
          [package]              A package containing shared Dart libraries.
          [server-shelf]         A server app using `package:shelf`
          [web]                  A web app that uses only core Dart libraries.

    --[no-]pub                   Whether to run 'pub get' after the project has been created.
                                 (defaults to on)
    --force                      Force project generation, even if the target directory already exists.
```

{% endcomment %}
