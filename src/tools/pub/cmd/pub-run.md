---
title: pub run
description: Use pub run to run a Dart script in your package.
permalink: /tools/pub/cmd/pub-run
---

_Run_ is one of the commands of the _pub_ tool.
[Learn more about pub](/tools/pub).

{% prettify nocode %}
$ pub run [--mode=<mode>] [--checked] <executable> [args...]
{% endprettify %}

Use this command to run a Dart script in your package,
or in one of its dependencies, from the command line.

To run an executable when you are not currently inside a package,
use the [pub global](/tools/pub/cmd/pub-global) command.

## Running a script in your package's bin directory

This is the simplest use case.

From the root of a package that contains `foo.dart`
in the `bin` directory, run the app using the following command:

```terminal
$ pub run foo arg1 arg2
```

This command looks in your package's `bin` directory for the
specified script and invokes it, passing in any arguments.

## Running a script in another directory in your package

To run a script inside a directory other than the top-level
bin directory (but within the package), prepend the path
to the name of the script.
For example, to run `foo.dart` in the `example/sub` directory:

```terminal
$ pub run example/sub/foo arg1 arg2
```

## Running a script in a dependency

To run a script from the `bin` directory of a package that you depend on
in the pubspec, specify the package name.
For example, to run `bar.dart` in the foo package:

```terminal
$ pub run foo:bar arg
```

You can only run scripts out of another package's `bin` directory.
All other directories are private.

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

{% comment %}
update-for-dart-2
TODO: Add any run-specific options here.
{% endcomment %}

<aside class="alert alert-info" markdown="1">
  *Problems?* See [Troubleshooting Pub](/tools/pub/troubleshoot).
</aside>
