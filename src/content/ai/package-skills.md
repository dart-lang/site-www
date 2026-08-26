---
title: Package skills
description: >-
  Learn how to discover, install, and manage AI agent skills provided by
  Dart and Flutter packages.
---

AI coding agents, such as Cursor, Gemini, Claude Code, Cline, and Copilot,
help you write, test, and refactor Dart code.
To generate accurate, idiomatic code,
these agents rely on context about the libraries and packages
your project uses.

**Package skills** allow package authors to distribute standardized,
context-rich AI agent instructions directly with their pub packages.
Using the [`package:skills`]({{site.pub-pkg}}/skills) tool (`dart run skills@`),
you can discover, install, and update skills for your project dependencies,
enabling your AI agents to write better code with fewer hallucinations.

## What are agent skills?

An agent skill is a structured set of instructions, code examples,
and best practices packaged alongside a library.
Skills follow the open [Agent Skills specification][agentskills],
which standardizes how AI coding agents discover and read instructions.

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
your AI agent gains immediate, authoritative knowledge
written and maintained by the package authors themselves.

## Install skills for dependencies

To install and update skills provided by your project's dependencies,
use `dart run skills@ get` (or run `dart run skills@` directly):

```console
$ dart run skills@ get
```

When run in a project directory,
the tool scans your immediate dependencies in `pubspec.yaml`
for packages that vend a `skills/` directory and prompts you
to select which skills to install:

```console
Scanning dependencies for available skills...
? Select skills to install:
  [x] shelf: routing - Define and handle HTTP routes
  [ ] shelf: middleware - Add logging and CORS middleware
  [x] dio: error-handling - Configure retry interceptors
```

Use the arrow keys and spacebar to select the skills you want to install,
then press <kbd>Enter</kbd>.

### Install skills from a specific package

To install or update skills from a single package dependency,
use the `-p` (or `--package`) option:

```console
$ dart run skills@ get -p <package_name>
```

### Install a specific skill

To install a specific skill by name,
use the `-s` (or `--skill`) option:

```console
$ dart run skills@ get -p <package_name> -s <skill_name>
```

### Install all skills non-interactively

To install all available skills from all dependency sources
without interactive prompts, pass the `-a` (or `--all`) flag:

```console
$ dart run skills@ get --all
```

## Install skills from a Git repository

You can also install skills directly from any Git repository,
even if the repository is not published on pub.dev,
using `dart run skills@ add`:

```console
$ dart run skills@ add <git_repository_url>
```

To install all skills from the Git repository without prompting,
add the `--all` flag:

```console
$ dart run skills@ add <git_repository_url> --all
```

Once added as a source,
you can update skills from your configured Git repositories at any time
by running `dart run skills@ get`.

## Skill directory structure

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
├── lib/
├── test/
└── pubspec.yaml
```

Popular AI coding agents automatically scan `.agents/skills/`
in your workspace.
Once installed, the skills are immediately available
to your agent during code generation, refactoring, and chat.

### Version control recommendations

We recommend committing the `.agents/skills/` directory to source control.
Checking in skills ensures that:

* All team members and agents share the same AI agent guidelines.
* CI/CD workflows and automated agents have access to the same skill context.
* Skill versions stay aligned with your project's dependency versions.

## Update installed skills

As packages evolve, authors update their skills
with new best practices and API changes.
To update all installed skills to match the latest versions
of your dependencies, run:

```console
$ dart run skills@ get
```

## Handle local modifications

One key advantage of agent skills is that you can edit them locally
to customize instructions for your team's architecture or style.

When you run `dart run skills@ get`,
`package:skills` tracks previously installed skills and detects changes
to your local files before updating.

If a local modification is detected:
* `package:skills` alerts you that the skill has been modified locally.
* You are prompted to choose whether to **overwrite** your local changes
  with the upstream version or **keep** your local customizations.

## Manage and remove skills

### List installed skills

To view all managed skills currently installed in your workspace,
run `dart run skills@ list`:

```console
$ dart run skills@ list
```

### Prune skills from removed dependencies

If you remove a dependency from your `pubspec.yaml`,
its skills might still remain in your `.agents/skills/` directory.
To automatically remove skills for packages that are no longer dependencies,
run `dart run skills@ prune`:

```console
$ dart run skills@ prune
```

### Remove specific skills

To explicitly remove managed skills from your workspace,
use `dart run skills@ remove`:

```console
$ dart run skills@ remove -p <package_name>
```

## Related links

* [`package:skills` on pub.dev]({{site.pub-pkg}}/skills)
* [Agent Skills specification][agentskills]
* [Dart and Flutter MCP server]({{site.flutter-docs}}/ai/mcp-server)
