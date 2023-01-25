---
title: dart create
description: Command-line tool for creating Dart projects.
toc: false
---

The `dart create` command creates a Dart project,
using one of several supported templates.
The same functionality is available in IDEs.

{% include tools/dart-tool-note.md %}

When you run `dart create`, it first creates a directory with the project files. 
Then it gets package dependencies (unless you specify the `--no-pub` flag).

Here's an example of using `dart create` to create a directory named `my_cli` 
that contains a simple console app (the default template):

```terminal
$ dart create my_cli
```

To use a different template, such as `web`, add a template argument:

```terminal
$ dart create -t web my_web_app
```

The following table shows the templates you can use:

|------------------+------------------------------------------------------|
| Template         | Description                                          |
|------------------|------------------------------------------------------|
| `console`        | A command-line application.                          |
| `package`        | A package containing shared Dart libraries.         |
| `server-shelf`   | A server built using [shelf][].                      |
| `web`            | A web app built using core Dart libraries.           |
{:.table .table-striped .nowrap}

[shelf]: {{site.pub-pkg}}/shelf

These templates result in a file structure that follows
[package layout conventions](/tools/pub/package-layout).

If the specified directory already exists, `dart create` fails. 
You can force project generation with the `--force` flag:

```terminal
$ dart create --force <DIRECTORY>
```

For further information on command-line options, use the `--help` flag:

```terminal
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
