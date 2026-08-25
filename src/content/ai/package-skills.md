---
title: Install and use package skills
shortTitle: Package skills
description: >-
  Learn how to install, manage, and use AI agent skills provided by
  Dart and Flutter packages.
---

AI coding assistants—such as Cursor, Gemini Code Assist, VS Code,
JetBrains AI, and Claude Code—help you write, test, and refactor Dart code.
To generate accurate, idiomatic code,
these assistants rely on context about the libraries and packages
your project uses.

**Package skills** allow package authors to distribute standardized,
context-rich AI agent instructions directly with their pub packages.
Using `dart skills` (or `dart run skills@`),
you can discover, install, and update skills for your project dependencies,
enabling your AI assistants to write better code with fewer hallucinations.

## What are agent skills?

An agent skill is a structured set of instructions, code examples,
and best practices packaged alongside a library.
Skills follow the open [Agent Skills specification][agentskills],
which standardizes how AI coding tools discover and read instructions.

A skill typically includes:

* **Contextual rules**: Guidance on library patterns, architecture,
  and anti-patterns to avoid.
* **Code patterns**: Concrete, copy-pasteable examples of common tasks.
* **Tooling & workflow scripts**: Optional helper scripts and commands
  that an agent can execute to perform tasks or validate code.

Skills are stored in your project's `.agents/skills/` directory,
where AI coding tools and agents automatically discover and use them.

[agentskills]: https://agentskills.io

## Why use package skills?

General-purpose AI models are trained on public code across many languages,
which means they might:

* Suggest deprecated APIs or outdated syntax.
* Miss package-specific architectural conventions.
* Hallucinate APIs that don't exist in the specific version you're using.

When you install package skills,
your AI assistant gains immediate, authoritative knowledge
written and maintained by the package authors themselves.

## Discover and install skills

You can automatically discover skills available in your dependencies,
or install skills from specific packages, Git repositories, and local paths.

### Auto-discover skills from dependencies

When you run `dart skills` (or `dart run skills@`) in a project directory,
the tool scans your immediate dependencies in `pubspec.yaml`
for packages that vend a `skills/` directory:

```console
$ dart skills
Scanning dependencies for available skills...
? Select skills to install:
  [x] shelf: routing - Define and handle HTTP routes
  [ ] shelf: middleware - Add logging and CORS middleware
  [x] dio: error-handling - Configure retry interceptors
```

Use the arrow keys and spacebar to select the skills you want to install,
then press <kbd>Enter</kbd>.

:::tip
If your Dart SDK does not yet include `dart skills` as a built-in command,
invoke it directly with `dart run`:

```console
$ dart run skills@
```
:::

### Install skills from a specific package

To install skills provided by a specific package dependency,
use `dart skills add`:

```console
$ dart skills add shelf
```

#### Install all skills non-interactively

To install all skills provided by a package without an interactive prompt,
pass the `--all` flag:

```console
$ dart skills add shelf --all
```

#### Install a specific skill directly

To install a single skill by name,
append the skill name after a colon (`:`):

```console
$ dart skills add shelf:routing
```

### Install from a Git repository

You can install skills directly from any Git repository,
even if the repository is not published to pub.dev:

```console
$ dart skills add --git https://github.com/my-org/my_package
```

You can also specify a git ref (branch, tag, or commit) or subdirectory:

```console
$ dart skills add --git https://github.com/my-org/my_package --git-ref main --git-path packages/sub_package
```

### Install from a local path

To install skills from a local directory during package development,
use the `--path` flag:

```console
$ dart skills add --path ../local_package
```

## Where skills and metadata are stored

### Installed skills (`.agents/skills/`)

When you install skills,
they are copied into your project's `.agents/skills/` directory:

```plaintext
my_project/
├── .agents/
│   └── skills/
│       ├── shelf-routing/
│       │   └── SKILL.md
│       └── dio-error-handling/
│           ├── SKILL.md
│           └── examples/
├── .dart_tool/
│   └── skills/
│       └── manifest.json
├── lib/
├── test/
└── pubspec.yaml
```

Popular AI coding assistants automatically scan `.agents/skills/`
in your workspace.
Once installed, the skills are immediately available
to your assistant during code generation, refactoring, and chat.

### Skill manifest and tracking (`.dart_tool/skills/`)

To support updating and detecting local modifications,
`dart skills` records metadata and content hashes of installed skills
in the project-specific `.dart_tool/skills/` directory.

:::note
The `.dart_tool/` directory contains generated cache files and is
ignored by Git by default.
For more information, see [What not to commit](/tools/pub/private-files).
:::

### Version control recommendations

We recommend committing the `.agents/skills/` directory to source control.
Checking in skills ensures that:

* All team members share the same AI assistant guidelines.
* CI/CD workflows and automated agents have access to the same skill context.
* Skill versions stay aligned with your project's dependency versions.

## Update installed skills

As packages evolve, authors update their skills
with new best practices and API changes.
To update your installed skills to match the latest versions
of your dependencies, run:

```console
$ dart skills update
```

To update skills for a single package, specify the package name:

```console
$ dart skills update shelf
```

## Handle local modifications

One key advantage of agent skills is that you can edit them locally
to customize instructions for your team's architecture or style.

When you run `dart skills update`,
the tool checks the content hash in `.dart_tool/skills/`
to verify whether you have locally modified the installed `SKILL.md` files.

If a local modification is detected:
* `dart skills` alerts you that the skill has been modified locally.
* You are prompted to choose whether to **overwrite** your local changes
  with the upstream version or **keep** your local customizations.

To non-interactively overwrite local modifications during updates,
use the `--force` flag:

```console
$ dart skills update shelf --force
```

## Remove installed skills

To remove installed skills from your `.agents/skills/` directory,
run `dart skills remove`:

```console
$ dart skills remove shelf:routing
```

## Next steps

* Learn how to create and distribute skills for your own packages
  in [Ship skills with pub packages](/tools/pub/package-skills).
* Review all subcommands and flags in the
  [`dart skills` reference](/tools/dart-skills).
* Learn more about Dart AI tooling in [Build with AI](/ai).
