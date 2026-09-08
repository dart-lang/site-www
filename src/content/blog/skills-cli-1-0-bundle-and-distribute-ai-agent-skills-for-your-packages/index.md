---
title: "Skills CLI 1.0: Bundle and distribute AI agent skills for your packages"
description: >-
  Ship official AI agent skills directly with your packages
  to improve discoverability.
publishDate: 2026-09-08
author: jakemac53
category: announcements
layout: blog
---

Since late 2025, [Agent Skills](https://agentskills.io/) have been changing
how users give better context to their AI agents.
They are easy to create,
and use tokens efficiently through progressive disclosure.
Together, these benefits bridge the knowledge cutoff gap,
enabling agents to work more effectively on unfamiliar or updated codebases,
dependencies, and tools.

Today, skills are typically shared through Git repositories,
requiring developers to either manually clone and copy files
or rely on tools such as `npx skills`.
While `npx skills` works well, for a Dart fanatic like me,
requiring Node.js just to run a single command-line tool feels out of place.
Dart has always taken a "batteries-included" approach,
with everything you need built right into the SDK.
Managing AI skills should feel just as native.

Even for developers who already have `Node.js` and `npx` installed,
there is still a lack of both discoverability and package version support.
How do you ensure the skills you're using
match the exact version of the package in your project?

## Enter the skills CLI

To solve both of these problems,
the team at [Serverpod](https://serverpod.dev/)
created the [`skills`](https://pub.dev/packages/skills) CLI.
We're excited to announce version 1.0,
now maintained and published directly by the Dart team.

This tool is much more than just a replacement for `npx skills`.
The real magic is that it enables package authors to easily ship skills
**directly with their package**.
All they have to do is put them under a top level `skills/` directory:

```text
my-project/
├── src/
├── skills/      <--- skills
├── pubspec.yaml
└── README.md
```

We recommend running this tool using the new `dart run skills@` syntax,
which always runs the latest version of the CLI as a global tool.
Alternatively, you can install the tool with `dart install`
(just remember to update it periodically!).

## For package consumers: Installing skills

To fetch skills directly from dependencies in your `pubspec.yaml`,
run the `get` command:

```bash
# Scans immediate dependencies and discovers available skills.
dart run skills@ get
```

The `skills` CLI scans your project dependencies
for bundled `skills/` directories.
It then lists the available skills
and lets you choose which ones you want to install.

Subsequent runs are incremental—displaying only new, updated, removed,
or previously skipped skills.
You can also pass the `--all` flag to install all skill dependencies at once.

## For package authors: Shipping a skill

Package authors can start shipping skills alongside their code today.
To create a skill, add a directory inside `skills/`
prefixed with your package name (to prevent collision),
and include a `SKILL.md` instruction file.
This follows the standard [Agent Skills](https://agentskills.io/) layout.

For example, a package named `networking` can enforce proper API usage
with the following structure:

````markdown
---
name: networking-error-handling
description: >-
  Use when the user is making network requests using the networking APIs
  to ensure safe patterns.
---

# Networking Error Handling

## Guidelines

- Operations must always be wrapped in a try/catch block.
- You must catch `NetworkException` specifically
  to handle retries and log diagnostics.
- Provide fallback UI state in the event of a timeout.

## Examples

```dart
try {
  final response = await NetworkingClient.fetchData();
} on NetworkException catch (e) {
  Logger.log(e.context);
  return FallbackData();
}
```
````

## Install from git with the `add` command

While pulling skills directly from your dependencies is convenient,
an entire ecosystem already exists
around sharing skills through GitHub repositories.
These might not even be associated directly with Dart or Flutter packages.
The `skills` CLI also supports explicitly installing skills from any Git repo
using the `add` command:

```bash
# Install universally applicable skills from a Git repository
dart run skills@ add https://github.com/my-org/custom-ai-skills.git
```

You can install any skill found on [skills.sh](https://skills.sh),
a popular skill aggregate site,
by simply replacing the `npx skills` command with `dart run skills@`.

This enables teams to compose their instructions from multiple sources,
including Dart dependencies and external repositories alike,
all managed by a single tool.

## Try skills today

We’re excited to see how the `skills` CLI
simplifies AI-powered Dart and Flutter development!

Here is a quick recap:

- **Package authors:**
  Add `skills/<package_name>-<skill-name>/SKILL.md` files
  to your package repository.
- **Package consumers:**
  Run `dart run skills@ get` in your project root
  to discover and install available skills from your dependencies.

A huge thank you to Serverpod for the initial implementation,
and to all the early adopters shaping these agentic workflows with us!
If you have feedback or run into any issues,
let us know by filing an issue in the
[dart-lang/ai](https://github.com/dart-lang/ai/issues?q=is%3Aissue+is%3Aopen+label%3Apackage%3Askills)
repository.

To learn more and explore skills in action:

* **Documentation**:
  Read the [Package skills guide](/ai/package-skills)
  or the
  [Flutter package skills doc](https://docs.flutter.dev/ai/package-skills).
* **Package authors**:
  Follow our guide on how to
  [ship skills with packages](/tools/pub/package-skills).
* **CLI tool**:
  View [package:skills on pub.dev](https://pub.dev/packages/skills).
* **Examples**: See skills already shipping in packages like
  [Jaspr](https://github.com/schultek/jaspr/tree/main/packages/jaspr),
  [Serverpod](https://github.com/serverpod/serverpod/tree/main/packages/serverpod),
  [Flutter Scene](https://github.com/bdero/flutter_scene/tree/master/packages/flutter_scene/skills),
  and [GenUI](https://github.com/flutter/genui/tree/main/packages/genui).
