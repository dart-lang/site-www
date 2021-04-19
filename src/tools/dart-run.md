---
title: dart run
description: Use dart run to run a Dart script in your package.
---

The `dart run` command supports running a Dart script located in a file,
or a package, or in one of its dependencies, from the command line.

To run an executable when you are not currently inside a package,
use the [pub global](/tools/pub/cmd/pub-global) command.

The `dart run` command combines what was previously exposed as `pub run`
and as the [Dart VM](/tools/dart-vm).

{% include tools/dart-tool-note.md %}

Here's an example of creating a new app and running it:

```terminal
$ dart create myapp
$ cd myapp
$ dart run
```

## Running a script in your package's bin directory

This is the simplest use case.

From the root of a package that contains `foo.dart`
in the `bin` directory, run the app using the following command:

```terminal
$ dart run foo arg1 arg2
```

This command looks in your package's `bin` directory for the
specified script and invokes it, passing in any arguments.

## Running a script in another directory in your package

To run a script inside a directory other than the top-level
bin directory (but within the package), prepend the path
to the name of the script.
For example, to run `foo.dart` in the `example/sub` directory:

```terminal
$ dart run example/sub/foo arg1 arg2
```

## Running a script in a dependency

To run a script from the `bin` directory of a package that you depend on
in the pubspec, specify the package name.
For example, to run `bar.dart` in the foo package:

```terminal
$ dart run foo:bar arg
```

You can only run scripts out of another package's `bin` directory.
All other directories are private.

## Running with debugging

To run with various debugging, pass a debugging flag.
See `dart run --help` for details.
