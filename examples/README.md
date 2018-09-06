# Examples

This folder (`examples`), contains the following packages:

- `misc` contains code for effective dart, the language tour, the library tour, samples and possibly more.
- `httpserver` is one of the larger samples.
- `util` is a package of shared utilities used by `misc`, etc.

## Original sources

The original tour sources, taken from the Up-and-Running repo (but reworked to contain doc regions), are in these folders:

- `/examples_archive/language_tour` (now obsolete, see below)
- `/examples_archive/library_tour`

These original sources don't have tests, and practically each code excerpt is an independent
package (with its own pubspec).

The original sources for the (large) samples were copied from the
[dart-tutorials-samples](https://github.com/dart-lang/dart-tutorials-samples) repo.

## New sources

Consolidated and reworked versions of the original sources
are under these folders:

- `examples/*/lib`
- `examples/*/test`

Travis jobs run the following:

- Analyzer over both `lib` and `test`
- Tests under `test`

You can run some or all of these at the command line, as well.

To run only the analyzer:

```
cd examples
dartanalyzer .
```

To run both the analyzer and tests:

```
./tool/analyze-and-test-examples.sh
```

If you get a warning about test failures or analysis errors,
you might need to update one or more analyzer results files
(for example, `examples/misc/analyzer-2-results.txt`).

To update an analyzer results file:

1. Run `./tool/analyze-and-test-examples.sh  --save-logs`.
2. Look at the diffs for the results files.
3. If the diffs look good but some comments are missing,
   add back the comments that are still relevant.
4. Run `./tool/analyze-and-test-examples.sh` to confirm that
   your changes are good.


### File organisation for the Tours

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

### Code highlights

Code segments enclosed in the special syntax [!...!] will be highlighted.
For example, the code

```
int [!foo!] = bar;
```

will display as

  <code>int <mark>foo</mark> = bar;</code>

## Code excerpt transformation

The code excerpt extractor can apply regular-expression-based replace transformations.
There are global transformations applied to all code excerpts. See
`./tool/refresh-code-excerpts.sh` for an annotated list of replace expressions passed
along with the `--replace` command line argument of the `code_excerpt_updater` command.

File-scope global replace expressions are included at the top of some of site page markdown files.
For example, `src/_guides/language/effective-dart/design.md` currently uses the file-global replace argument:

```html
<?code-excerpt replace="/([A-Z]\w*)\d\b/$1/g"?>
```

This particular transformation strips the trailing version number off of class names. For
example `String0` becomes `String`, and `Point1`, `Point2`, etc. all become `Point`. This
allows the originating source file to contain multiple versions of the same class.
