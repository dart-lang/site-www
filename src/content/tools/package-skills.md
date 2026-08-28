---
title: "package:skills"
description: Command-line tool for managing AI agent skills in Dart projects.
---

The [`package:skills`]({{site.pub-pkg}}/skills) package provides
command-line tools to discover, install, and manage AI agent skills
for Dart and Flutter projects.

An agent skill is a structured set of instructions, code examples,
and best practices following the [Agent Skills specification][agentskills].
When installed in your workspace,
AI coding agents, such as Cursor, Gemini, Claude Code, Cline, and Copilot,
use these skills to write accurate,
idiomatic code tailored to your dependencies.

## Running package:skills

You run `package:skills` using the `dart run skills@ <command>` syntax:

```console
$ # From the root of your Dart or Flutter project:
$ dart run skills@ get
```

To view all available commands and flags, run `dart run skills@ --help`.

## Built-in commands

The `package:skills` package includes the following commands:

get
: Discovers and installs skills provided by dependencies in `pubspec.yaml`.
  Supports interactive selection (<kbd>Ctrl</kbd>+<kbd>A</kbd> to toggle all),
  installing all skills without prompting (`--all`),
  or targeting specific packages and skills (`-p <package>`, `-s <skill>`).

add
: Adds an external Git repository as a skill source and installs its skills:

  ```console
  $ dart run skills@ add <git_repository_url>
  ```

create
: Scaffolds a new skill directory and template for package authors:

  ```console
  $ dart run skills@ create -n <skill_name> -d "<skill_description>"
  ```

list
: Displays all managed skills currently installed in your workspace:

  ```console
  $ dart run skills@ list
  ```

prune
: Automatically removes skills for packages
  that are no longer listed as dependencies in `pubspec.yaml`:

  ```console
  $ dart run skills@ prune
  ```

remove
: Removes specific installed skills from your workspace
  (`-p <package>`, `-s <skill>`):

  ```console
  $ dart run skills@ remove -p <package_name>
  ```

## More information

To learn more about package skills workflows, see:

* [Package skills user guide](/ai/package-skills)
  (Installing and using skills in your development workflows)
* [Ship skills with packages](/tools/pub/package-skills)
  (Authoring and publishing skills with your packages)
* [`package:skills` on pub.dev]({{site.pub-pkg}}/skills)
* [Agent Skills specification][agentskills]

[agentskills]: https://agentskills.io
