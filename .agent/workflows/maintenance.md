---
description: Maintenance Tasks (Changelog, Syncs, etc.)
---

# Maintenance Workflow

This workflow guides the agent in performing maintenance tasks using the project's defined **Skills**.

## Discovery Mechanism

When the user asks for a maintenance task (e.g., "Update changelog", "Sync SDK"), you **MUST** first consult the **Skills Registry**.

1.  **Read Registry:** `tool/skills/README.md`
2.  **Match Command:** Find the skill that matches the user's request in the "Commands" column.
3.  **Load Skill:** Read the `SKILL.md` for the matched skill.
4.  **Execute:** Follow the instructions in `SKILL.md`.

## Available Skills Location
All skills are located in `tool/skills/`. Do not attempt to write custom scripts if a skill already exists.
