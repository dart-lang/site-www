# AGENTS.md

This file provides important project context and guidelines to
agentic coding and writing tools when working with them on
content and code for the Dart programming language website.

## Project overview

This repository contains the source code and content for the official
Dart programming language website, hosted at `dart.dev`.

The API docs at `api.dart.dev` are embedded in the Dart SDK source
and are maintained in the [`dart-lang/sdk` repository][dart-sdk].

The website is statically built and implemented with
Dart and the [Jaspr][] web framework.
For loading content, data, and some assets,
it uses [Jaspr Content][].

[dart-sdk]: https://github.com/dart-lang/sdk
[Jaspr]: https://jaspr.site
[Jaspr Content]: https://docs.jaspr.site/content

### Directory structure

- `src/content/`:
  Markdown-based documentation pages.
- `src/data/`:
  YAML and JSON data files used by the site,
  such as for the sidenav, glossary, and changelog.
- `src/_includes/`:
  Liquid partial files written in Markdown.
- `examples/`:
  Dart code examples workspace,
  referenced by code excerpts in the Markdown files.
- `site/`:
  The Jaspr and Jaspr Content-based site implementation.
- `tool/dash_site/`:
  CLI tool for site development and maintenance.

## Common commands

While working on the site,
you might need to run these commands:

```bash
dart pub get                                # Install or update Dart dependencies.
dart run dash_site serve                    # Serve a dev server of the site locally.
dart run dash_site build                    # Build a production version of the site.
dart run dash_site refresh-excerpts         # Sync code excerpts to Markdown files.
dart run dash_site check-markdown           # Check Markdown files for known issues.
dart run dash_site check-site-variable      # Check for text that can use site variables.
dart run dash_site check-link-references    # Verify Markdown link references after build.
dart run dash_site check-links              # Verify cross-page links after build.
dart run dash_site check-tutorial-code      # Validate Dartpedia tutorial code snippets.
dart run dash_site --help                   # Learn what other commands are available.
```

## Agent skills

Repository-specific agent skills live under `.agents/skills/`:

- Use `.agents/skills/write-technical-docs/SKILL.md` when writing or reviewing
  developer-facing prose, headings, terminology, or link phrasing.
- Use `.agents/skills/format-markdown/SKILL.md` when authoring or editing
  Markdown structure, semantic line breaks, alerts, lists, or links.
- Use `.agents/skills/write-dart/SKILL.md` when writing or updating Dart code
  examples and infrastructure.
- Use `.agents/skills/stage-site-locally/SKILL.md` to format, sync excerpts,
  build, and validate links before opening a pull request.

For the full list of skills, consult [`.agents/README.md`][agents-readme].

[agents-readme]: .agents/README.md

## Content guidelines

### Writing style

Keep writing consistent across the site and
follow the [Google developer documentation style guide][],
along with the repository's `write-technical-docs` and `format-markdown` skills.

[Google developer documentation style guide]: https://developers.google.com/style/

#### Line breaks

In Markdown files, use [semantic line breaks][] and
try to keep each line under 80 characters long.

[semantic line breaks]: https://sembr.org/

#### Cross-references and links

Avoid using "see", "see the", or "for more information, see" to introduce
links or references. Prefer action-oriented or descriptive phrasings such as
"refer to", "consult", or "visit" (for example, "To learn about X, visit Y").

## Coding guidelines

Follow [Effective Dart][] and the repository's `write-dart` skill
for all Dart code,
unless an example deliberately deviates to teach a concept.

[Effective Dart]: https://dart.dev/effective-dart
