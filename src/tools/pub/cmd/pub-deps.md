---
title: dart pub deps
description: Use dart pub deps to print a dependency graph for a package.
---

_Deps_ is one of the commands of the [pub tool](/tools/pub/cmd).

```nocode
$ dart pub deps [--style=<style>] [--[no-]dev] [--executables]
```

This command prints the dependency graph for a package.
The graph includes both the
[immediate dependencies](/tools/pub/glossary#immediate-dependency)
that the package uses (as specified in the pubspec), as well as the
[transitive dependencies](/tools/pub/glossary#transitive-dependency)
pulled in by the immediate dependencies.

The dependency information is printed as a tree by default.

For example, the pubspec for the markdown_converter example specifies
the following dependencies:

```yaml
dependencies:
  barback: ^0.15.2
  markdown: ^0.7.2
```

Here's an example of the `dart pub deps` output for markdown_converter:

```terminal
$ dart pub deps
markdown_converter 0.0.0
|-- barback 0.15.2+6
|   |-- collection 1.1.2
|   |-- path 1.3.6
|   |-- pool 1.1.0
|   |   '-- stack_trace...
|   |-- source_span 1.2.0
|   |   '-- path...
|   '-- stack_trace 1.4.2
|       '-- path...
'-- markdown 0.7.2
```

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

### `--style=<style>` or `-s <style>`

The specified style determines the output format:

* `tree`
: Prints dependency information as a tree. This is the 
default format.

* `list`
: Prints dependency information as a list.

* `compact`
: Prints dependency information as a compact list.

### `--[no-]dev`

By default, prints all dependencies, 
including dev dependencies (`--dev`).
To remove dev dependencies, use `--no-dev`.

### `--executables`

Prints all available executables.

### `--json`

Generates output in JSON format.

{{site.alert.info}}
  *Problems?*
  See [Troubleshooting Pub](/tools/pub/troubleshoot).
{{site.alert.end}}
