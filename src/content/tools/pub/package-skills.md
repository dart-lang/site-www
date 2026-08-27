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

## Publish and tag on pub.dev

When you publish your package with `dart pub publish`,
the `skills/` directory is automatically bundled into the package archive.

To help developers find packages that offer AI agent skills,
add the `skills` topic to `pubspec.yaml`:

```yaml
name: my_package
description: A powerful package for Dart developers.
version: 1.0.0

topics:
  - skills
  - server
```

Packages tagged with `skills` are indexed and discoverable in the
[skills topic on pub.dev][pub-topics].

[pub-topics]: https://pub.dev/packages?q=topic%3Askills

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
* [Agent Skills specification][agentskills]
