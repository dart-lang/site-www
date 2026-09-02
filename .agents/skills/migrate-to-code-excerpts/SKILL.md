---
name: migrate-to-code-excerpts
description: Migrates hardcoded code blocks in a documentation page into a compilable, testable project using code excerpts.
---

# Refactor docs to code excerpts

This skill guides the agent in converting hardcoded Markdown code snippets into tested, verifiable code excerpts. This ensures all code in the docs compiles correctly and remains easy to update.

## Prerequisites

- A target documentation Markdown file containing code snippets.
- A target location in `/examples/` for the backing code.

## Step 1: Initialization and extraction

1. Read the target Markdown file to identify all code blocks (such as ````dart`).
2. Create a new subdirectory in the `examples` folder (for example, `/examples/dart/my-lesson/`).
3. Scaffold a standard `pubspec.yaml` configured for the examples workspace (`resolution: workspace`, `environment:` matching the workspace SDK constraint, and `publish_to: none`), add the directory to `examples/pubspec.yaml`, and generate the Dart source files containing the extracted snippets. Group snippets logically (for example, all snippets for a single step go into their respective file).

## Step 2: The agentic code-fix loop

The code extracted from the Markdown will likely fail initial analysis due to missing imports, undefined variables, or context assumed from previous chapters.

1. Do not modify the Markdown file yet.
2. Run `dart pub get` from the repository root (or `dart pub get --directory=<example_dir>`).
3. Run the analyzer on the new example project:
   `dart analyze <example_dir>`
4. Read the CLI errors.
5. Fix the errors in the `.dart` files (for example, add needed imports, mock variables, or fix scopes). If ignore comments are necessary, prefer `// ignore_for_file:` at the top of the file outside docregions so they don't leak into excerpts.
6. Repeat the analyze-and-fix loop until `dart analyze` reports no errors. Make sure the code still represents the instructional intent of the original snippet.

## Step 3: Excerpt integration

1. Add `// #docregion <region-name>` and `// #enddocregion <region-name>` markers around the relevant code in your passing source files.
2. Edit the original documentation Markdown file:
   - Remove the hardcoded code string.
   - Replace it with the excerpt directive: `<?code-excerpt "path/to/file.dart (<region-name>)"?>`.
   - Keep any necessary code block options (such as `title` and `highlightLines`).

## Step 4: Sync and verify

1. Sync the excerpts into the Markdown using the site tool:
   `dart run dash_site refresh-excerpts`
2. Review the modified Markdown file to ensure the `dash_site` command successfully injected the verified code into the docs and didn't break the page formatting.
