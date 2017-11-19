# Examples

This package contains all of the sources that appear in the Language Tour and the Library Tour, including the smallest of code excerpts.

## Original sources

Sources originally taken from the Up-and-Running repo (but reworked to contain doc regions)
are in these folders:

- `language_tour` (now obsolete, see below)
- `library_tour`

These original sources don't have tests, and practically each code excerpt is an independent
package (with its own pubspec).

## New sources

Consolidated and reworked versions of the original sources are being developed.
So far, the Language Tour sources have been completely rewritten, and are found
in these folders:

- `lib/language_tour`
- `test/language_tour`

As can be expected, Travis jobs run the

- Analyzer over both `lib` and `test`
- Tests under `test`

### Source organisation

The new Language Tour sources are under `lib/language_tour` and `test/language_tour`.
Below each of these folders, you'll find either a file or a folder with a name
that matches a top-level section of the Language Tour. This file/folder contains
all of the code excerpt sources for that section.

Under `lib` you might find a function defined as:

```dart
void miscDeclAnalyzedButNotTested(bool c) {
  {
    // #docregion foo-1
    var foo = 1
    // #enddocregion foo-1
  }

  {
    // #docregion foo-2
    var foo = 2
    // #enddocregion foo-2
  }

  // ...
}
```

That is, code regions are placed with a (headless) code block. This ensures
that code region declarations (which sometimes re-declare the same entity)
don't clash.

### Where to find a code excerpt

Generally speaking, a small code excerpt that is subject to testing is embedded
directly in its test. Code regions that are subject to analysis only
are in `lib`. Larger examples are in `lib`, and their tests (if any) under `test`.

### Why not test all?

Not all code excerpts are tested because some are just fragments of anything
useful, and others illustrate features that would required significant test
scaffolding to be written and the effort isn't worth the small gain.

### _$print_

Example code, whose print output needs to be tested, should call `$print()`
instead of `print()`. For example, [lib/language_tour/classes/employee.dart][],
which uses `$print()`, is tested in [test/language_tour/classes_test.dart#L95][].

The global `$print` variable (defined in [lib/util/print.dart][]) is overwritten
when running tests so that we can capture print output.
By default `$print == print`.

When displaying code excerpts in the Language Tour page,
we show `print()` instead. It is `scripts/refresh-code-excerpts.sh` that does
a global replace of `$print()` by `print()`.

### Code highlights

Code segments enclosed in the special syntax [!...!] will be highlighted.
For example, the code

    ```
      int [!foo!] = bar;
    ```

will display as

  <code>int <mark>foo</mark> = bar;</code>

[lib/language_tour/classes/employee.dart]: https://github.com/dart-lang/site-www/blob/master/examples/lib/language_tour/classes/employee.dart
[lib/util/print.dart]: https://github.com/dart-lang/site-www/blob/master/examples/lib/util/print.dart
[test/language_tour/classes_test.dart#L95]: https://github.com/dart-lang/site-www/blob/master/examples/test/language_tour/classes_test.dart#L95
