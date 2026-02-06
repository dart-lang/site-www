# Maintenance Skills

This directory contains specialized "Skills" — self-contained suites of actions, scripts, and instructions designed to be used by both AI agents and human developers to perform maintenance tasks on `dart.dev`.

## Usage

Each skill is located in its own subdirectory and contains a `SKILL.md` manifest file. This manifest provides step-by-step instructions for performing the task.

### For Humans

1.  Open `site-www` in Antigravity (or similar AI-enabled IDE).
2.  Ask: **"skill: update sdk changelog 3.11"** (or similar).
3.  Submit.
4.  The agent will auto-discover the skill in this directory and execute the steps.

### For AI Agents
Agents (like Antigravity) act on these skills by reading the `SKILL.md` file and executing the steps autonomously.

### Registry

| Skill | Description | Commands | Directory |
| :--- | :--- | :--- | :--- |
| **Update SDK Changelog** | Syncs new SDK changelog entries to `changelog.yml`. | `skill: update sdk changelog <VERSION>`<br>`Update changelog <VERSION>` | [`update_sdk_changelog`](update_sdk_changelog/SKILL.md) |

## Adding New Skills

To add a new skill suite:
1.  Create a new directory: `tool/skills/<skill_name>/`.
2.  Add a `SKILL.md` file with standard YAML frontmatter (`name`, `description`).
3.  (Optional) Add a `scripts/` directory for any CLI tools or executables.
4.  (Optional) Add `resources/` for templates or `examples/` for usage guides.
