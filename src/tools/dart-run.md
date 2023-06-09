---
title: dart run
description: Command-line tool for running a Dart program.
---

The `dart run` command supports running 
a Dart program—located in a file, in the current package, 
or in one of the dependencies of the current package—from the command line.
This command provides functionality that was previously in `pub run`
and the Dart VM tool.
To run a program from an arbitrary location,
use the [pub global](/tools/pub/cmd/pub-global) command.

```
dart run [options] [<DART_FILE> | <PACKAGE_TARGET>] [args]
```

Here's an example of creating a new app and running it:

```terminal
$ dart create myapp
$ cd myapp
$ dart run
```

{% include tools/dart-tool-note.md %}

## Running a Dart file

You can run a Dart file by passing its relative path:

```terminal
$ dart run tool/debug.dart
```

## Running a program that's in a package

The instructions in this section assume that
you're executing the `dart run` command
from the directory that's at the top of a Dart package
(the _current package_).
For information on the directory structure of Dart packages, see
[package layout conventions](/guides/libraries/create-packages).

### In a depended-on package

You can run programs that are
distributed in the `bin` directory of any package
that the current package depends on.
To run such a program,
specify the depended-on package name and the program name.
You can omit the program name if it's the same as the package name.

For example, say you're in the top directory of a package
that depends on the `bar` package.
To run the main program that's in the `bar` package (`bin/bar.dart`),
you can use this command:

```terminal
$ dart run bar
```

If the program name doesn't match the package name,
use the form `<package name>:<program name>`. For example,
to run the program `bin/baz.dart` that's in the `bar` package,
use this command:

```terminal
$ dart run bar:baz
```

The `bin` directory is the only place with visible programs.
All other directories in the depended-on package are private.

### In the current package

When the current directory matches the package name
(that is, you're in the directory that matches
the `name` property in the pubspec),
then you can omit the package name.
If the program name matches the package name
(that is, it's the main program),
then you can also omit the program name.

Here's the shortest form of `dart run`,
which runs the main program for the current package.
For example, if you're in the top directory of the `foo` package,
this command runs `bin/foo.dart`:

```terminal
$ dart run
```

If the program name doesn't match the package name,
then add a colon and the program name.
For example, this command runs `bin/baz.dart` in the current package:

```terminal
$ dart run :baz
```

To run a program that's in the current package but not in the `bin` directory,
pass a relative path (as shown before):

```terminal
$ dart run tool/debug.dart
```

## Supplying arguments to main()

To supply [arguments to the `main()` function][args],
put them at the end of the command:

```terminal
$ dart run tool/debug.dart arg1 arg2
```

When you're running the main program for the current package,
add the package name.
Here's an example of running `bin/foo.dart` with arguments
while you're in the top directory of the `foo` package:

```terminal
$ dart run foo arg1 arg2
```

[args]: /language/functions#the-main-function

## Debugging

To enable debugging, 
add one or more of these common debugging options
to your `dart run` command:

- To enable [`assert` statements][assert],
  add the `--enable-asserts` flag:

  ```terminal
  $ dart run --enable-asserts tool/debug.dart
  ```

- To enable debugging and performance analysis
  through [Dart DevTools](/tools/dart-devtools),
  add the `--observe` flag:

  ```terminal
  $ dart run --observe tool/debug.dart
  ```
  
  To learn more about debugging with Dart DevTools,
  see [Using DevTools with a command-line app][].

To learn more about other debugging options, run `dart run --help`.

[assert]: /language/error-handling#assert
[Using DevTools with a command-line app]: /tools/dart-devtools#using-devtools-with-a-command-line-app

## Enabling experimental features

To enable new features and enhancements that are currently in development,
use [experiment flags](/tools/experiment-flags).
