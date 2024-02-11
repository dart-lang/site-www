## Examples

The example code in this folder is organized following the conventions
documented in the [Examples][] page of the [site-shared docs][]. Consult that
page for general information about project file organization, testing, [CI][],
and more. Site-www specific information is given below.

## How do I run the analyzer on an example?

Change directory into the example's folder and run Dart commands there. For
example:

```terminal
$ cd examples/misc
$ dart pub get
$ dart analyze .
```

## How do I run example tests?

Change directory into the example's folder and run Dart commands there. For
example:

```terminal
$ cd examples/misc
$ dart pub get
$ dart test  # Run VM tests
$ dart test -p chrome  # Run browser tests
```

## How do I run the analyzer and tests for all examples?

To run both the analyzer and tests for all examples use:

```
./tool/analyze-and-test-examples.sh
```

If you get a warning about test failures or analysis errors, you might need to
update one or more analyzer results files. For example, update
`examples/misc/analyzer-results.txt`, if the change applies to both stable and
dev Dart releases. Otherwise, update only the release specific file: either
`examples/misc/analyzer-results-stable.txt` or
`examples/misc/analyzer-results-dev.txt`.

## How do I update the analyzer results files?

To update the analyzer results files:

1. Run `dart pub upgrade` to get the latest version of the lints package.
1. Run `./tool/analyze-and-test-examples.sh --save-logs`.
1. Look at the diffs for the results files.
1. If the diffs look good but some comments are missing,
   add back the comments that are still relevant.
1. Run `./tool/analyze-and-test-examples.sh` to confirm that
   your changes are good.

**Pro tip:** You can embed in a doc page specific line(s) from an analyzer
results file. (Link to example: To be completed)

## File organization for the Tours

The new Language Tour sources are under `lib/language_tour` and `test/language_tour`.
Below each of these folders, you'll find either a file or a folder with a name
that matches a top-level section of the Language Tour. This file/folder contains
all of the code excerpt sources for that section.

Under `lib` you might find a function defined as:

```dart
void miscDeclAnalyzedButNotTested(bool c) {
  {
    // #docregion foo-1
    var foo = 1;
    // #enddocregion foo-1
  }

  (int bar) {
    // #docregion foo-2
    var foo = 2 + bar;
    // #enddocregion foo-2
  }

  // ...
}
```

That is, code regions are placed with a (headless) code block or an anonymous
function. This ensures that code region declarations (which sometimes re-declare
the same entity) don't clash.

## Where to find a code excerpt

Generally speaking, a small code excerpt that is subject to testing is embedded
directly in its test. Code regions that are subject to analysis only
are in `lib`. Larger examples are in `lib`, and their tests (if any) under `test`.

## Why not test all the things?!?

Not all code excerpts are tested because some are just small fragments with
little or no useful behavior, and others illustrate features that would require
significant test scaffolding to be written and the effort isn't worth the small
gain.

[CI]: https://www.thoughtworks.com/continuous-integration
[site-shared docs]: https://github.com/dart-lang/site-shared/tree/main/doc
[Examples]: https://github.com/dart-lang/site-shared/blob/main/doc/examples.md
