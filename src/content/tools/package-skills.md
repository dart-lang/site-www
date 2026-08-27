---
title: "package:skills"
description: Reference for the package:skills command-line tool.
---

The [`package:skills`]({{site.pub-pkg}}/skills) tool
discovers, installs, and manages AI agent skills
for Dart and Flutter packages.

You can execute `package:skills` directly using `dart run`:

```console
$ dart run skills@ get
```

## Global options

The following options apply to all `package:skills` commands:

`-h`, `--help`
: Print usage information.

`-C`, `--directory=<dir>`
: Run the command as if started in the specified directory.

`--version`
: Print the tool version and exit.

## Commands

### `skills get`

Installs or updates skills provided by dependencies in your `pubspec.yaml`.
Running `dart run skills@` without a command
is shorthand for `dart run skills@ get`.

```console
$ dart run skills@ get [options]
```

#### Options

`-p`, `--package=<name>`
: Install or update skills from the specified packages only.

`-s`, `--skill=<name>`
: Only install the specified skills.

`-a`, `--all`
: Install or update all available skills without prompting.

`--git=<url>`
: Update skills from the specified Git repositories only.

`--agent=<agent>`
: Target a specific AI coding agent.
  Supported values: `antigravity`, `claude`, `cline`, `codex`,
  `copilot`, `cursor`, `opencode`, `generic`.

### `skills add`

Adds a Git repository as a skill source and installs skills from it.

```console
$ dart run skills@ add <git_repository_url> [options]
```

#### Options

`-s`, `--skill=<name>`
: Install the specified skills only.

`-a`, `--all`
: Install all skills from the Git repository without prompting.

`--[no-]global`
: Install the skills globally instead of in the current workspace.

`--agent=<agent>`
: Target a specific AI coding agent.

### `skills create`

Scaffolds a new skill directory and starter `SKILL.md` template
for package authors.

```console
$ dart run skills@ create -n <name> -d "<description>"
```

#### Options

`-n`, `--name=<name>`
: The name of the skill to create (without the package prefix).

`-d`, `--description=<text>`
: A short description of what the skill does and when to activate it.

### `skills list`

Lists all managed skills currently installed in your workspace.

```console
$ dart run skills@ list
```

### `skills prune`

Removes installed skills for packages that are no longer dependencies
in your `pubspec.yaml`.

```console
$ dart run skills@ prune [options]
```

#### Options

`-a`, `--all`
: Prune all unused packages and empty sources without prompting.

`--agent=<agent>`
: Target a specific AI coding agent.

### `skills remove`

Removes selected managed skills from your workspace.

```console
$ dart run skills@ remove [options]
```

#### Options

`-p`, `--package=<name>`
: Remove skills for the specified packages.

`-s`, `--skill=<name>`
: Only remove the specified skills.

`-a`, `--all`
: Remove all managed skills from the workspace.

`--git=<url>`
: Remove skills from the specified Git repositories only.

`--agent=<agent>`
: Target a specific AI coding agent.

## Related links

* [Package skills](/ai/package-skills)
* [Ship skills with packages](/tools/pub/package-skills)
* [`package:skills` on pub.dev]({{site.pub-pkg}}/skills)
* [Agent Skills specification][agentskills]

[agentskills]: https://agentskills.io
