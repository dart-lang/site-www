---
title: dart test
description: Command-line tool for testing Dart projects.
toc: false
---

The `dart test` command runs tests that
rely on the [`test` package][] and
are under the `test` directory of the current Dart project.
For information on writing tests, see the 
[testing documentation][].
If you're working on Flutter code, then use the `flutter test` command instead,
as described in [Testing Flutter apps][].

[testing documentation]: /guides/testing
[`test` package]: {{site.pub-pkg}}/test
[Testing Flutter apps]: {{site.flutter-docs}}/testing

{% include tools/dart-tool-note.md %}

Here's an example of using `dart test` to run all tests
that are under the current project's `test` directory:

```terminal
$ cd my_app
$ dart test
```

To control which tests run, you can add the paths to
directories or files under the `test` directory:

{% comment %}
  I ran these commands in site-www/misc
{% endcomment %}

```terminal
$ dart test test/library_tour/io_test.dart
00:00 +0: readAsString, readAsLines
00:00 +1: readAsBytes
...
```

Another way to run a subset of tests is to use the `--name` (`-n`),
`--tags` (`-t`), or `--exclude-tags` (`-x`) flag,
adding part or all of the string to match:

```terminal
$ dart test --name String
00:00 +0: test/library_tour/io_test.dart: readAsString, readAsLines
00:00 +1: test/library_tour/core_test.dart: print: print(nonString)
00:00 +2: test/library_tour/core_test.dart: print: print(String)
00:00 +3: test/library_tour/core_test.dart: numbers: toString()
...
```

When you use these flags more than once in the same command line,
only the tests that match _all_ the conditions run:

```terminal
$ dart test --name String --name print
00:00 +0: test/library_tour/core_test.dart: print: print(nonString)
00:00 +1: test/library_tour/core_test.dart: print: print(String)
00:00 +2: All tests passed!
```

The `dart test` command has many more flags to control
which tests run,
how they run (for example, concurrency and timeout), and
where and how the output appears.
For further information on command-line options,
see the [`test` package][] or
use the `--help` flag:

```terminal
$ dart test --help
```
