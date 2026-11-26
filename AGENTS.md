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

To run local visual regression diffing between your current changes
and `main`:

```bash
dart run dash_site visual-diff
```

By default, the command uses Chrome to capture full-page snapshots
and opens an interactive visual diff review server in your browser.

#### Renderers

- **Chrome** (default):
  Uses your installed Google Chrome or Chromium.
  Requires no extra setup if Chrome is installed.
- **Obscura**:
  A lightweight headless browser backend that renders via CPU software
  rasterization.
  To use Obscura, pass `--renderer=obscura`:

  ```bash
  dart run dash_site visual-diff --renderer=obscura
  ```

  To install Obscura on macOS:

  ```bash
  brew install obscura
  ```

  On Linux, download pre-built release binaries from
  <https://github.com/h4ckf0r0day/obscura/releases>
  and place both `obscura` and `obscura-worker` on your `PATH`.
  If Obscura is installed in a custom location,
  pass `--renderer-path=<path>`.

#### Useful options

- `--current`: Snapshot the current working tree as baseline
  instead of checking out git `main`.
- `--update-baseline`: Update baseline snapshots from current results.
- `--route=<path>`: Snapshot specific route(s),
  for example `--route=/get-started`.
- `--all-routes`: Bypass pruning in `visual_diff.yaml`
  and snapshot every route.

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
