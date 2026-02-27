# AI agent guidelines

This directory contains configuration, guidelines, and skills
for AI tools and coding agents working in this repository.

## Skills

[Agent skills][] are structured instructions that AI coding agents can
follow to complete common repository tasks consistently and correctly.

Each skill is defined in its own directory under `skills/`
as a `SKILL.md` file with YAML frontmatter and Markdown instructions:

```text
.agents/skills/
└── <skill-name>/
    └── SKILL.md
```

[Agent skills]: https://agentskills.io/

### Available skills

- [`sync-changelog`](skills/sync-changelog/SKILL.md)

  Sync the changelog from the Dart SDK repo to update `src/data/changelog.yml`.

- [`update-whats-new`](skills/update-whats-new/SKILL.md)

  Update the "What's new" page at `src/content/resources/whats-new.md` with
  important changes to the website since the previous release.

### Using a skill

Some AI agent tools automatically discover skills from `.agents/skills/`.
If your tool supports this, the skills are available without extra steps.

If your agent tool does **not** discover skills from this directory
(for example, it looks for skills in a different location),
you can work around this in two ways:

-   **Symlink the skills directory** into the location your tool expects.
    For example, if your tool discovers skills from `.claude/skills/`:

    ```bash
    ln -s .agents/skills .claude/skills
    ```

    These symlinks are local to your machine and shouldn't be committed.
    Add the tool-specific directory to your global gitignore or
    to `.git/info/exclude` so it stays out of version control.

-   **Reference the skill file directly** when starting a task.
    Point the agent to the file path or attach it as context:

    ```text
    Follow the instructions in @.agents/skills/sync-changelog/SKILL.md
    ```

### Adding a new skill

1.  Create a new directory under `.agents/skills/` with the skill name,
    separated by hyphens and only containing lowercase alphanumeric characters.

    ```text
    .agents/skills/<skill-name>/
    ```

2.  Add a `SKILL.md` file with YAML frontmatter and Markdown body:

    ```markdown
    ---
    name: <skill-name>
    description: A short description of what the skill does.
    ---

    # Skill title

    Step-by-step instructions for the agent to follow.
    ```

    To learn more about writing and customizing skills,
    check out the documentation for the [Agent skills][] standard.

3.  Update the [Available skills](#available-skills) table in this README.

[Agent skills]: https://agentskills.io/
