---
description: Migrates hardcoded code blocks in a documentation page into a compilable, testable project using code-excerpts.
---

# Refactor Docs to Code Excerpts

This workflow guides the agent in converting hardcoded markdown code snippets into tested, verifiable code excerpts. This ensures all code in the docs compiles correctly and remains easy to update.

**Prerequisites**:
- A target documentation markdown file containing code snippets.
- A target location in `/examples/` for the backing code.

## Step 1: Initialization & Extraction
1. Read the target markdown file to identify ALL code blocks (e.g., ````dart`).
2. Create a new subdirectory in the `examples` folder (e.g., `/examples/dart/my-lesson/`).
3. Scaffold a standard `pubspec.yaml` and generate the Dart/Flutter source files containing the extracted snippets. Group snippets logically (e.g., all snippets for a single step go into their respective file).

## Step 2: The Agentic Code-Fix Loop (CRITICAL)
The code extracted from the markdown will likely fail initial analysis due to missing imports, undefined variables, or context assumed from previous chapters.
1. Do NOT modify the markdown file yet.
2. Run the analyzer on the new example project:
// turbo
3. `cd <example_dir> && dart pub get && dart analyze` (or `flutter analyze`).
4. Read the CLI errors.
5. Fix the errors in the `.dart` files (e.g., add needed imports, mock variables, fix scopes).
6. Repeat the analyze-and-fix loop until `dart analyze` reports NO errors. Make sure the code still represents the instructional intent of the original snippet.

## Step 3: Excerpt Integration
1. Add `// #docregion [region-name]` and `// #enddocregion [region-name]` markers around the relevant code in your passing source files.
2. Edit the original documentation markdown file:
   - Remove the hardcoded code string.
   - Replace it with the excerpt directive: `<?code-excerpt "path/to/file.dart (region-name)"?>`.
   - Keep any necessary markdown styling commands (e.g., `replace`, `highlight`).

## Step 4: Sync and Verify
// turbo
1. Sync the excerpts into the markdown using the site tool: `dart run dash_site refresh-excerpts`
2. Review the modified markdown file to ensure the `dash_site` command successfully injected the verified code into the docs and didn't break the page formatting.
