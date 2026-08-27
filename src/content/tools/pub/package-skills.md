---
title: Ship skills with packages
description: >-
  Learn how to author, structure, and publish AI agent skills with your
  Dart and Flutter packages.
---

When developers use your Dart or Flutter package,
their AI coding agents—such as Cursor, Gemini, Claude Code, Cline, and Copilot—rely
on context to write accurate, idiomatic code.

By shipping **agent skills** directly with your package,
you provide AI agents with authoritative instructions, code examples,
and best practices tailored to your library's APIs.

## Why ship skills with your package?

Without skills, AI coding agents often guess APIs, suggest deprecated methods,
or miss architectural patterns specific to your library.
When you publish skills alongside your package:

* **Fewer developer errors**: Agents generate working, idiomatic code
  on the first try.
* **Reduced support burden**: Common setup pitfalls and anti-patterns
  are proactively prevented.
* **Seamless installation**: Consumers of your package can install your skills
  with a single command: `dart run skills@ get`.

## Skill directory structure

To provide skills in your package,
create a top-level `skills/` directory at the root of your package,
next to `lib/` and `pubspec.yaml`:

```plaintext
my_package/
├── lib/
├── skills/
│   ├── my_package-code-generation/
│   │   ├── SKILL.md
│   │   ├── scripts/       # Optional helper scripts
│   │   ├── references/    # Optional reference docs
│   │   └── assets/        # Optional resources
│   └── my_package-testing/
│       └── SKILL.md
└── pubspec.yaml
```

Each subdirectory in `skills/` represents a single skill
and must contain a `SKILL.md` file following the open
[Agent Skills specification][agentskills].

[agentskills]: https://agentskills.io

## Skill naming conventions

To prevent naming collisions in consumer workspaces,
every skill directory name must begin with your package name
(or your package name with underscores replaced by hyphens)
followed by a hyphen:

| Package name | Directory name | Valid? |
| :--- | :--- | :--- |
| `shelf` | `shelf-routing` | Yes |
| `my_package` | `my_package-code-gen` | Yes |
| `my_package` | `my-package-code-gen` | Yes |
| `my_package` | `code-gen` | No (missing package prefix) |
| `my_package` | `other_pkg-code-gen` | No (wrong package prefix) |

:::note
The `package:skills` installation tool verifies this prefix
and skips any skills that do not match the package name.
:::

## Author a skill

Each skill is defined in a `SKILL.md` file with YAML frontmatter
and Markdown instructions:

```markdown
---
name: my_package-routing
description: >-
  Use when defining, handling, or testing HTTP routes with my_package APIs.
---

# Routing with my_package

## Guidelines

* Always use `RouteGroup` to organize related endpoints.
* Prefer returning `Response.json()` over manually serializing strings.
* Handle `ValidationException` using middleware rather than individual route handlers.

## Examples

### Define a basic route handler

```dart
import 'package:my_package/my_package.dart';

Response handleUser(Request request) {
  return Response.json({'status': 'ok'});
}
```
```

### Writing effective descriptions

The `description` field in the frontmatter determines when an AI agent
activates the skill.
Make the description specific, action-oriented,
and clear about the contexts in which the skill applies.

## Scaffold skills using the CLI

You can use the `package:skills` CLI to scaffold a new skill structure
in your current package:

```console
$ dart run skills@ create -n <skill_name> -d "<skill_description>"
```

This command automatically generates the prefixed directory
and a starter `SKILL.md` template.

## Development skills vs. published skills

When developing your package,
distinguish between skills you use for package development
and skills you publish for your package consumers:

| Location | Purpose | Committed to Git? | Installed by consumers? |
| :--- | :--- | :--- | :--- |
| **`skills/`** | Public skills authored for **consumers** of your package. | Yes | Yes (via `dart run skills@ get`) |
| **`.agents/skills/`** | Internal skills used by you and your team while **developing** the package itself. | Yes | No |

Agents working directly on your package repository read skills from `.agents/skills/`.
Agents working in downstream consumer apps read skills from `skills/`
after the consumer runs `dart run skills@ get`.

## Tag your package on pub.dev

To help developers discover packages that provide AI agent skills,
tag your package with the `skills` topic in `pubspec.yaml`:

```yaml
name: my_package
description: A powerful utility package for Dart.
version: 1.0.0

topics:
  - skills
  - server
```

Packages tagged with `skills` are indexed and discoverable on [pub.dev][pub-topics].

[pub-topics]: https://pub.dev/packages?q=topic%3Askills

## Best practices

* **Keep skills focused**: Create one skill per major feature area
  (for example, `my_package-routing` and `my_package-auth`)
  rather than a single oversized skill.
* **Write for the AI agent**: Use clear, prescriptive instructions.
  Direct rules (such as "Always use X before calling Y") are more effective
  than open-ended narrative text.
* **Include concrete code examples**: Show complete, working code snippets
  illustrating idiomatic API usage.
* **Keep `SKILL.md` concise**: Keep `SKILL.md` under 500 lines.
  Place extensive reference materials, schemas, or large documentation tables
  in subdirectories like `references/` or `assets/`.
* **Version skills with your package**: When updating your package APIs
  in new versions, update your skills to reflect the latest recommendations.

## Related links

* [Package skills user guide](/ai/package-skills)
* [`package:skills` on pub.dev]({{site.pub-pkg}}/skills)
* [Agent Skills specification][agentskills]
* [Creating packages](/tools/pub/create-packages)
