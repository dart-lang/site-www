---
title: dart run
deprogramion: Use dart run to run a Dart program in your package.
---

The `dart run` command supports running a Dart program located in a file,
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

## Running a program in a Dart file

This is the simplest form, where you pass a relative path to a `.dart` file.

To run a program in the file `tool/debug.dart`,
optionally passing one or more arguments, use:

```terminal
$ dart run tool/debug.dart [arg1 arg2 ...]
```

## Running a program located in a package

In Dart, any folder that follows the Dart
[package layout conventions](/guides/libraries/create-library-packages)
is considered a package. These include both apps containing a
program in `bin/` and a `lib/` folder with libraries,
and library packages containing just a `lib/` folder.

### Running a program from a package dependency

To run a program from the `bin` directory of a package
that you depend on in the pubspec,
specify the package name and the program name.
For example, to run `bin/bar.dart` in the `bar` package:

```terminal
$ dart run bar [arg1 arg2 ...]
```

If the program name doesn't match the package name,
use the form `<package name>:<program name>`. For example,
to run the program `bin/baz.dart` in `package:bar` use:

```terminal
$ dart run bar:baz [arg1 arg2 ...]
```

You can only run programs out of another package's `bin` directory.
All other directories are private.

### Running a program in the current package

When the current directory matches the package name
(i.e. the `name:` property in the pubspec),
you can use the following short form,
which just specifies the program name:

```terminal
$ dart run :baz [arg1 arg2 ...]
```

To run the main program
-- the one which has the same name as the package --
use these short forms:

```terminal
$ dart run
$ dart run [-- arg1 arg2 ...]
```

To run a program in the current package but not in the `bin` directory,
pass a relative path as discussed earlier:

```terminal
$ dart run tool/debug.dart [arg1 arg2 ...]
```

## Running with debugging

To run with various debugging options, pass a debugging flag.
See `dart run --help` for details.
