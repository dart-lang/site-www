---
title: dart create
description: Command-line tool for creating Dart projects.
toc: false
---

The `dart create` command allows creating Dart projects
from varying available templates through a command line
or many IDE project creation workflows.

{% include tools/dart-tool-note.md %}

The command creates a directory with the specified name, 
creates necessary files, configures static analysis, 
and retrieves any necessary dependencies.

```terminal
$ dart create [ARGUMENTS] <DIRECTORY>
```

{{site.alert.note}}
  Keep in mind, the command will attempt to run
  [`dart pub get`](/tools/pub/cmd/pub-get) after the project is created.
  To avoid this you can specify the `--no-pub` flag:

  ```terminal
  $ dart create --no-pub <DIRECTORY>
  ```
{{site.alert.end}}

The structure and files created and the dependencies specified
are configured through a choice of templates. By default, the `console-simple`
template is used, creating a simple command-line application.

For example, to create a simple command-line application with the
package and directory name `my_cli`:

```terminal
$ dart create my_cli
```

This results in a package structure similar to the following:

```nocode
my_cli/                  # The projects parent directory
  bin/                   # The bin directory for the CLI tools
  .gitignore             # Prevents various Dart files from being added to Git staging
  analysis_options.yaml  # Configures static analysis for the project
  CHANGELOG.md           # Allows you to specify changes between releases
  pubspec.lock           # Pins down the dependency information for your package
  pubspec.yaml           # Configures package information and dependencies
  README.md              # Provides a description for your application
```

{{site.alert.info}}
  To learn more about this and the other templates' generated structures,
  see [Package layout conventions](/tools/pub/package-layout).
{{site.alert.end}}

To instead utilize one of the other templates, 
you specify it with the `-t` flag:

```terminal
$ dart create -t <TEMPLATE> <DIRECTORY>
```

Beyond the `console-simple` template, these are the currently available
templates:

|------------------+---------------------------------------------+------------------------------------------------------|
| Template         | Example of use                              | More information                                     |
|------------------|---------------------------------------------|------------------------------------------------------|
| `console-simple` | `dart create -t console-simple <DIRECTORY>` | A simple command-line application.                   |
| `console-full`   | `dart create -t console-full <DIRECTORY>`   | A complete command-line application.                 |
| `package-simple` | `dart create -t package-simple <DIRECTORY>` | A starting point for Dart libraries or applications. |
| `server-shelf`   | `dart create -t server-shelf <DIRECTORY>`   | A server application built using [shelf][].          |
| `web-simple`     | `dart create -t web-simple <DIRECTORY>`     | A web application built using core Dart libraries.   |
{:.table .table-striped .nowrap}

[shelf]: {{site.pub-pkg}}/shelf

As an example, to create a simple web application
with the directory and name `my_web_app`,
you can run the following command:

```terminal
$ dart create -t web-simple my_web_app
```

If the specified directory already exists, the command will fail. 
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
-h, --help        Print this usage information.
-t, --template    The project template to use.
                  [console-simple (default), console-full, package-simple, server-shelf, web-simple]
    --[no-]pub    Whether to run 'pub get' after the project has been created.
                  (defaults to on)
    --force       Force project generation, even if the target directory already exists.

Run "dart help" to see global options.

Available templates:
  console-simple: A simple command-line application. (default)
    console-full: A command-line application sample.
  package-simple: A starting point for Dart libraries or applications.
    server-shelf: A server app using `package:shelf`
      web-simple: A web app that uses only core Dart libraries.

```
{% endcomment %}
