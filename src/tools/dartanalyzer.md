---
title: dartanalyzer
description: Command-line tool for static analysis
toc: false
---

The `dartanalyzer` command performs the same [static analysis][]
that you get when you use an IDE or editor that has Dart support.

Here's an example of performing static analysis over all the Dart files
under the `lib`, `test`, and `web` directories:

```terminal
$ dartanalyzer lib test web
```

You can customize the analysis using an analysis options file
or special comments in Dart source code.
For details, see [Customizing static analysis][static analysis].

For information on command-line options, use the `--help` flag:

```terminal
$ dartanalyzer --help
```

[static analysis]: /guides/language/analysis-options

{% comment %}
[PENDING: Add info on commonly used options.]

[PENDING: Consider providing some sample output and
using it to explain to users how to interpret the output.]

Feature `--options`, `--no-implicit-casts`, `--no-implicit-dynamic`?

```
Usage: dartanalyzer [options...] <directory or list of files>

    --dart-sdk                  The path to the Dart SDK.
    --options                   Path to an analysis options file.
    --package-root              The path to a package root directory (deprecated). This option cannot be used with --packages.
    --[no-]declaration-casts    Disable declaration casts in strong mode (https://goo.gl/cTLz40)
                                This option is now ignored and will be removed in a future release.

    --[no-]implicit-casts       Disable implicit casts in strong mode (https://goo.gl/cTLz40).
    --no-implicit-dynamic       Disable implicit dynamic (https://goo.gl/m0UgXD).
    --packages                  The path to the package resolution configuration file, which supplies a mapping of package names
                                to paths. This option cannot be used with --package-root.

    --[no-]lints                Show lint results.
    --format                    Specifies the format in which errors are displayed; the only currently allowed value is 'machine'.
    --version                   Print the analyzer version.
    --enable-experiment         Enable one or more experimental features. If multiple features are being added, they should be comma separated.
    --no-hints                  Do not show hint results.
    --fatal-infos               Treat infos as fatal.
    --fatal-warnings            Treat non-type warnings as fatal.
-h, --help                      Display this help message. Add --verbose to show hidden options.
-v, --verbose                   Verbose output.
```
{% endcomment %}
