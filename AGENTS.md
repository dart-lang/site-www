# AGENTS.md

This file provides important project context and guidelines to
agentic tools when working with them on content and code
for the Dart programming language website.

## Project overview

This repository contains the source code and content for the official
Dart programming language website, hosted at `dart.dev`.

The website is statically built and implemented with
Dart and the [Jaspr](https://jaspr.site) web framework.
For loading content, data, and some assets,
it uses [Jaspr Content](https://docs.jaspr.site/content).

### Directory structure

- `src/content/`:
  Markdown based documentation pages.
- `src/data/`:
  YAML and JSON data files used by the site,
  such as for the sidenav, glossary, and changelog.
- `src/_includes/`:
  Liquid partial files written in Markdown.
- `examples/`:
  Dart code examples workspace,
  referenced by code excerpts in the Markdown files.
- `site/`:
  The Jaspr and Jaspr Content based site implementation.
- `tool/dash_site/`:
  CLI tool for site development and maintenance.

## Common commands

While working on the site,
you might need to run these commands:

```bash
dart pub get                            # Install or update Dart dependencies.
dart run dash_site serve                # Serve a dev server of the site locally.
dart run dash_site build                # Build a production version of the site.
dart run dash_site refresh-excerpts     # Sync code excerpts to Markdown files.
dart run dash_site check-tutorial-code  # Validate Dartpedia tutorial code snippets.
dart run dash_site visual-diff          # Run local visual regression testing against main.
dart run dash_site --help               # Learn what other commands are available.
```

### Visual regression testing

To compare your working changes against `main`:

```bash
dart run dash_site visual-diff
```

By default, this uses Chrome.
To use the lightweight [Obscura](https://obscura.sh) renderer,
install it (`brew install obscura` on macOS or from
[GitHub releases](https://github.com/h4ckf0r0day/obscura/releases) on Linux)
and pass `--renderer=obscura`.

Common flags:
- `--current`: Use the current working tree as baseline instead of `main`.
- `--update-baseline`: Update baseline images from current snapshots.
- `--route=<path>`: Snapshot a specific route (e.g. `--route=/get-started`).
- `--all-routes`: Snapshot all routes, bypassing `visual_diff.yaml` limits.

## Content guidelines

### Writing style

Writing should be consistent across the site and
follow the [Google developer documentation style guide][].

[Google developer documentation style guide]: https://developers.google.com/style/

#### Line breaks

In Markdown files, use [semantic line breaks](https://sembr.org/) and
try to keep each line under 80 characters long.

## Coding guidelines

All Dart code should follow [Effective Dart](https://dart.dev/effective-dart),
unless purposefully not for explanatory or pedagogical purposes.
