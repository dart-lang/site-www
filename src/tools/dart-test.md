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
[Testing Flutter apps]: {{site.flutter}}/docs/testing

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
see the [`test` package] or
use the `--help` flag:

```terminal
$ dart test --help
```

{{site.alert.version-note}}
  The `dart test` command was introduced in Dart 2.10.
  Its functionality was previously provided by
  the `pub run test` command.
{{site.alert.end}}

{% comment %}
```
Runs tests in this package.

Usage: pub run test [files or directories...]

-h, --help                            Show this usage information.
    --version                         Show the package:test version.

Selecting Tests:
-n, --name                            A substring of the name of the test to run.
                                      Regular expression syntax is supported.
                                      If passed multiple times, tests must match all substrings.
-N, --plain-name                      A plain-text substring of the name of the test to run.
                                      If passed multiple times, tests must match all substrings.
-t, --tags                            Run only tests with all of the specified tags.
                                      Supports boolean selector syntax.
-x, --exclude-tags                    Don't run tests with any of the specified tags.
                                      Supports boolean selector syntax.
    --[no-]run-skipped                Run skipped tests instead of skipping them.

Running Tests:
-p, --platform                        The platform(s) on which to run the tests.
                                      [vm (default), chrome, firefox, safari, node]
-P, --preset                          The configuration preset(s) to use.
-j, --concurrency=<threads>           The number of concurrent test suites run.
                                      (defaults to "6")
    --total-shards                    The total number of invocations of the test runner being run.
    --shard-index                     The index of this test runner invocation (of --total-shards).
    --pub-serve=<port>                The port of a pub serve instance serving "test/".
    --timeout                         The default test timeout. For example: 15s, 2x, none
                                      (defaults to "30s")
    --pause-after-load                Pause for debugging before any tests execute.
                                      Implies --concurrency=1, --debug, and --timeout=none.
                                      Currently only supported for browser tests.
    --debug                           Run the VM and Chrome tests in debug mode.
    --coverage=<directory>            Gather coverage and output it to the specified directory.
                                      Implies --debug.
    --[no-]chain-stack-traces         Use chained stack traces to provide greater exception details
                                      especially for asynchronous code. It may be useful to disable
                                      to provide improved test performance but at the cost of
                                      debuggability.
    --no-retry                        Don't rerun tests that have retry set.
    --use-data-isolate-strategy       Use `data:` uri isolates when spawning VM tests instead of the
                                      default strategy. This may be faster when you only ever run a
                                      single test suite at a time.
    --test-randomize-ordering-seed    Use the specified seed to randomize the execution order of test cases.
                                      Must be a 32bit unsigned integer or "random".
                                      If "random", pick a random seed to use.
                                      If not passed, do not randomize test case execution order.

Output:
-r, --reporter                        Set how to print test results.

          [compact] (default)         A single line, updated continuously.
          [expanded]                  A separate line for each update.
          [json]                      A machine-readable format (see https://dart.dev/go/test-docs/json_reporter.md).

    --file-reporter                   Enable an additional reporter writing test results to a file.
                                      Should be in the form <reporter>:<filepath>, Example: "json:reports/tests.json"
    --verbose-trace                   Emit stack traces with core library frames.
    --js-trace                        Emit raw JavaScript stack traces for browser tests.
    --[no-]color                      Use terminal colors.
                                      (auto-detected by default)
```
{% endcomment %}
