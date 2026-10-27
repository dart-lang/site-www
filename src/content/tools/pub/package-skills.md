---
title: Ship skills with packages
description: >-
  Learn how to author, structure, test, and publish AI agent skills with your
  Dart and Flutter packages.
---

When developers use your Dart or Flutter package,
their AI coding agents,
such as Cursor, Gemini, Claude Code, Cline, and Copilot,
rely on context to write accurate, idiomatic code.

By shipping **agent skills** directly with your package,
you provide AI agents with authoritative instructions,
code examples,
and best practices tailored specifically to your library's APIs.
To learn how developers install and use skills in their projects,
see [Package skills](/ai/package-skills).

## Why ship skills with your package?

Without skills,
AI coding agents often guess APIs,
suggest deprecated methods,
or miss architectural patterns specific to your library.
When you publish skills alongside your package:

* **Fewer developer errors**: Agents generate working,
  idiomatic code on the first try.
* **Reduced support burden**: Common setup pitfalls and anti-patterns
  are proactively prevented.
* **Seamless installation**: Consumers of your package can install your skills
  with a single command: `dart run skills@ get`.

## Plan your package skills

A package skill is a set of guidelines and examples
that teaches an AI agent how to use a specific part of your library.
When planning skills for your package:

* **Focus on common workflows**: Create skills for key tasks,
  such as initial setup, routing, authentication, error handling,
  or performance optimization.
* **Keep skills modular**: Create separate, focused skills
  for distinct feature areas
  (for example, `my_package-routing` and `my_package-auth`)
  rather than bundling everything into one large skill.
* **Write prescriptive instructions**: Use direct, unambiguous rules
  (such as "Always initialize X before calling Y")
  rather than open-ended explanations.

## Set up the directory structure

To provide skills in your package,
create a top-level `skills/` directory at the root of your package,
alongside `lib/` and `pubspec.yaml`:

```plaintext
my_package/
├── lib/
├── skills/
│   ├── my_package-routing/
│   │   ├── SKILL.md
│   │   ├── scripts/       # Optional helper scripts
│   │   ├── references/    # Optional reference docs
│   │   └── assets/        # Optional static resources
│   └── my_package-testing/
│       └── SKILL.md
└── pubspec.yaml
```

Each subdirectory in `skills/` represents a single skill
and must contain a `SKILL.md` file following the open
[Agent Skills specification][agentskills].

[agentskills]: https://agentskills.io

### Skill naming conventions

To prevent naming collisions
when consumers install skills from multiple dependencies,
every skill directory name must begin with your package name
(or your package name with underscores replaced by hyphens)
followed by a hyphen:

| Package name | Directory name | Valid? |
| :--- | :--- | :--- |
| `shelf` | `shelf-routing` | Yes |
| `my_package` | `my_package-routing` | Yes |
| `my_package` | `my-package-routing` | Yes |
| `my_package` | `routing` | No (missing package prefix) |
| `my_package` | `other_pkg-routing` | No (wrong package prefix) |

:::note
The `package:skills` installation tool validates this prefix
and skips any skills that do not match the package name.
:::

## Author a skill

Each skill is defined in a `SKILL.md` file with YAML frontmatter
and Markdown instructions.

The following template illustrates the structure of a `SKILL.md` file
that you can customize for your package:

````markdown
---
name: <package_name>-<skill_name>
description: >-
  Use when the user is working with <package_name> APIs to ensure correct
  patterns and error handling.
---

# <Skill Title>

## Guidelines

* Always call `initialize()` before invoking other methods.
* Prefer using `<SpecificException>` over generic `Exception` types.
* Dispose of controllers and streams when they are no longer needed.

## Examples

### Basic setup example

```dart
import 'package:<package_name>/<package_name>.dart';

void main() {
  // Provide clear, idiomatic Dart code snippets for the agent to follow.
}
```
````

### Key parts of a skill file

A `SKILL.md` file typically consists of three parts:

* **YAML frontmatter (`name`, `description`)**:
  Identifies the skill and tells the AI coding agent
  when to activate the skill based on the user's prompt.
* **Guidelines**:
  A list of direct, prescriptive rules describing library conventions,
  recommended patterns, and common anti-patterns to avoid.
* **Examples**:
  Copy-pasteable Dart code snippets showing how to implement common tasks
  using your library's APIs.

## Scaffold skills using the CLI

You can use the `package:skills` CLI to quickly scaffold a new skill
in your current package:

```console
$ dart run skills@ create -n <skill_name> -d "<skill_description>"
```

This command automatically generates the prefixed directory
and a starter `SKILL.md` template.

## Development and published skills

When developing your package,
distinguish between skills used internally for package development
and skills published for your package consumers:

| Directory | Audience | Description |
| :--- | :--- | :--- |
| `skills/` | Package consumers | Public skills bundled with your package and installed with `dart run skills@ get`. |
| `.agents/skills/` | Package maintainers | Internal skills used while developing the repository. Not distributed to consumers. |

## Validate and lint skills

Before you publish your package,
use [`package:skills_lint`]({{site.pub-pkg}}/skills_lint) to validate your
skills against the [Agent Skills specification][agentskills].
The linter checks `SKILL.md` YAML frontmatter, directory structure,
package naming conventions, and relative file paths to keep your skill
definitions valid and ready for AI assistants to use.

Add `skills_lint` to your package's `dev_dependencies`:

```console
$ dart pub add dev:skills_lint
```

### Set up with an agent

After you add `skills_lint` as a dev dependency, install its bundled skills
with `dart run skills@ get`. Then provide your AI coding agent the following
prompt:

```text
Use the skills-lint-setup skill to set up skills_lint in this package.
Create a skills_lint.yaml at the package root that validates skills/
with published-skill-name and check-relative-paths set to error.
Then add a test under test/ that runs `dart run skills_lint` with that
configuration and fails if it exits with a nonzero code, so `dart test`
catches invalid skills. Finally, use the skills-lint-validation skill
to run the linter and fix any failures.
```

To configure and run `skills_lint` manually instead, you can pass command-line
flags or create a `skills_lint.yaml` file.

### Run with command-line flags

To validate the skills in a directory, run the following command:

```console
$ dart run skills_lint --skills-directory <skills_directory>
```

Replace `<skills_directory>` with the path to your skills directory,
such as `skills/`.

You can pass additional flags to customize validation. For all available flags
and automatic fix options, run `dart run skills_lint --help` or consult the
[`package:skills_lint` documentation]({{site.pub-pkg}}/skills_lint).

For example, to validate your package's `skills/` directory with package
naming and relative path checks enabled, run the following command:

```console
$ dart run skills_lint --skills-directory skills/ --published-skill-name --check-relative-paths
```

### Configure with a YAML file

To enforce consistent rules across local runs and continuous integration (CI)
without passing flags every time, create a `skills_lint.yaml` file at the root
of your package.
Start from the following recommended configuration and adjust the paths
for your package:

```yaml
# skills_lint.yaml
skills_lint:
  rules:
    check-relative-paths: error
    check-absolute-paths: error
  directories:
    - path: "skills/"
      rules:
        published-skill-name: error
    - path: ".agents/skills/"
  individual_skills:
    - path: "my_custom_standalone_skill"
      rules:
        check-trailing-whitespace: warning
```

After you add the `skills_lint.yaml` file, run the linter with no arguments:

```console
$ dart run skills_lint
```

Consult the [`package:skills_lint` documentation]({{site.pub-pkg}}/skills_lint)
for details on [rule precedence]({{site.pub-pkg}}/skills_lint#rule-precedence),
[built-in rules]({{site.pub-pkg}}/skills_lint#built-in-rules),
and [custom rule authoring]({{site.pub-pkg}}/skills_lint#3-custom-rules).

### Automate linting with `dart test`

To catch invalid skills automatically during local test runs and in your
existing `dart test` CI workflow, add a test under `test/` that runs
`skills_lint` against your `skills_lint.yaml` configuration and fails
when the linter reports errors.

For standalone CI workflows or Git pre-commit hooks, consult
[Recipes]({{site.pub-pkg}}/skills_lint#recipes)
in the `package:skills_lint` documentation.

## Test skills locally before publishing

Before publishing your package to pub.dev,
verify that your skills can be discovered and installed properly:

1. Create a sample Dart or Flutter project to act as a consumer.
2. In the sample project's `pubspec.yaml`, add a [path dependency][]
   pointing to your local package:

   ```yaml
   dependencies:
     my_package:
       path: ../path/to/my_package
   ```

3. Run `dart run skills@ get` in the sample project.
4. Verify that your skills appear in the interactive selection prompt
   and install cleanly into the sample project's `.agents/skills/` directory.

[path dependency]: /tools/pub/dependencies#path-packages

## Publish on pub.dev

When you publish your package with `dart pub publish`,
the `skills/` directory is automatically bundled into the package archive.
Once published, consumers who depend on your package can install your skills
by running `dart run skills@ get`.

## Best practices

* **Keep skills focused**: Create one skill per major feature area
  rather than a single oversized skill.
* **Write for the AI agent**: Use clear, prescriptive instructions.
  Direct rules (such as "Always use X before calling Y") are more effective
  than open-ended narrative text.
* **Include concrete code examples**: Show complete, working code snippets
  illustrating idiomatic Dart API usage.
* **Keep `SKILL.md` concise**: Keep `SKILL.md` under 500 lines.
  Place extensive reference materials, schemas, or large documentation tables
  in subdirectories like `references/` or `assets/`.
* **Version skills with your package**: When updating your package APIs
  in new versions, update your skills to reflect the latest recommendations.

## Related links

* [`package:skills` on pub.dev]({{site.pub-pkg}}/skills)
* [`package:skills_lint` on pub.dev]({{site.pub-pkg}}/skills_lint)
* [Agent Skills specification][agentskills]
