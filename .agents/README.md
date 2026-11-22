# AI agent guidelines

This directory contains configuration, guidelines, and skills
for AI tools and coding agents working in this repository.

## Skills

[Agent skills][] are structured instructions that AI coding agents can
follow to complete common repository tasks consistently and correctly.

Each skill is defined in its own directory under `skills/`
as a `SKILL.md` file with YAML front matter and Markdown instructions:

```text
.agents/skills/
└── <skill-name>/
    └── SKILL.md
```

### Available skills

- [`contribute-blog`][contribute-blog]

  Create, import, edit, or review posts for the official Dart blog
  at `dart.dev/blog`.

- [`format-markdown`][format-markdown]

  Write or edit well-structured Markdown, including front matter,
  semantic line breaks, headings, lists, alerts, code fences, and links.

- [`stage-site-locally`][stage-site-locally]

  Format code, sync excerpts, lint Markdown, build the site,
  and check links for pull request validation.

- [`sync-changelog`][sync-changelog]

  Sync the changelog from the Dart SDK repo to update
  the `src/data/changelog.yml` file.

- [`update-llms-text`][update-llms-text]

  Update and maintain the curated LLM documentation index at
  the `src/content/llms.txt` file.

- [`update-whats-new`][update-whats-new]

  Update the "What's new" page at `src/content/resources/whats-new.md`
  with important changes to the website since the previous release.

- [`write-dart`][write-dart]

  Write, review, or refactor idiomatic Dart code and documentation examples.

- [`write-technical-docs`][write-technical-docs]

  Write or review clear, consistent, and accessible prose
  for Dart developer documentation.

[contribute-blog]: skills/contribute-blog/SKILL.md
[format-markdown]: skills/format-markdown/SKILL.md
[stage-site-locally]: skills/stage-site-locally/SKILL.md
[sync-changelog]: skills/sync-changelog/SKILL.md
[update-llms-text]: skills/update-llms-text/SKILL.md
[update-whats-new]: skills/update-whats-new/SKILL.md
[write-dart]: skills/write-dart/SKILL.md
[write-technical-docs]: skills/write-technical-docs/SKILL.md

### Using a skill

Some AI agent tools automatically discover skills from `.agents/skills/`.
If your tool supports this, the skills are available without extra steps.

If your agent tool does **not** discover skills from this directory
(for example, it looks for skills in a different location),
you can work around this in two ways:

- **Symlink the skills directory** into the location your tool expects.
  For example, if your tool discovers skills from `.claude/skills/`:

  ```bash
  ln -s .agents/skills .claude/skills
  ```

  These symlinks are local to your machine and shouldn't be committed.
  Add the tool-specific directory to your global gitignore or
  to `.git/info/exclude` so it stays out of version control.

- **Reference the skill file directly** when starting a task.
  Point the agent to the file path or attach it as context:

  ```text
  Follow the instructions in @.agents/skills/write-technical-docs/SKILL.md
  ```

### Adding a new skill

1.  Create a new directory under `.agents/skills/` with the skill name,
    separated by hyphens and only containing lowercase alphanumeric characters.

    ```text
    .agents/skills/<skill-name>/
    ```

1.  Add a `SKILL.md` file with YAML front matter and Markdown body:

    ```markdown
    ---
    name: <skill-name>
    description: A short description of what the skill does.
    ---

    # Skill title

    Step-by-step instructions for the agent to follow.
    ```

    To learn more about writing and customizing skills,
    visit the documentation for the [Agent skills][] standard.

1.  Update the [Available skills](#available-skills) list in this README.

[Agent skills]: https://agentskills.io/
