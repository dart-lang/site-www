---
name: sync-changelog
description: Sync the changelog from the Dart SDK repo to update the changelog.yml entries in the site repository.
---

# Sync SDK changelog

When you need to update the changelog entries in `src/data/changelog.yml`
with the latest changes from the Dart SDK repository,
carefully follow the steps outlined in this skill.

## Validate the SDK version

Before running the sync tool,
verify the Dart SDK version you wish to sync.
It should be a stable release, not a pre-release,
and in `major.minor.patch` format.

If the user provides a version with just `major.minor`,
you can assume a patch version of `0`.
For example, `3.11` implies `3.11.0`.

If necessary, you can validate what versions are available to sync
by checking the [SDK changelog](https://raw.githubusercontent.com/dart-lang/sdk/main/CHANGELOG.md)
and checking what h2 headers (`##`) are present.

## Sync and verify SDK changelog entries

1.  **Run the sync tool**

    Execute the `sync-changelog` CLI command
    from within the website repository and
    specify the SDK version you want to sync.

    -   **Command:**

        ```bash
        dart run dash_site sync-changelog --version <VERSION>
        ```

    -   **Example:**

        ```bash
        dart run dash_site sync-changelog --version 3.11.0
        ```

    > [!TIP]
    > You can preview the changes first by specifying the `--dry-run` flag:
    >
    > ```bash
    > dart run dash_site sync-changelog --version 3.11.0 --dry-run
    > ```

2.  **Verify changes**

    Check `src/data/changelog.yml` to ensure new entries are correct.

    -   Review the diff: `git diff src/data/changelog.yml`
    -   Ensure formatting is consistent and the new entries are prepended correctly.

3.  **Filter and prune entries**

    Remove entries that don't represent concrete, user-facing changes to
    the Dart SDK, Dart language, or its surrounding tooling.

    **Remove entries that are:**

    -   **Vague or nebulous:**
        Such as "Various performance improvements" or "Minor internal updates".
        Users need to know _what improved.
    -   **Non-functional:**
        Such as "Thanks to @user for...", "Fixed typo in comment".
    -   **Redundant:**
        Entries that duplicate others for the same feature.

4.  **Refine tags**

    Review the `description` of each new entry.
    The tool uses keywords to infer tags,
    (such as "fixes" -> `fixed`, "adds" -> `new`), but
    **you must verify them**.

    **Rule:** If an entry has the wrong tag, or
    is just `changed` when it should be specific,
    **you must correct it** in `src/data/changelog.yml` before finishing.
    Entries **can and should** have multiple tags if applicable,
    such as having both `removed` and `breaking`.

    **Available tags and guidelines:**

    -   `new`: For new features, additions, or introductions,
        such as indicated by "Added ..." or "Introduced...".
    -   `fixed`: For bug fixes,
        such as indicated by "Fixed ..." or "Bug fix...".
    -   `deprecated`: For deprecations,
        such as indicated by "Deprecated..." or "marked as legacy...".
    -   `experimental`: For changes related to experimental features,
        such as indicated by "Experimental..." or "Preview...".
    -   `removed`: For feature, capability, or API removals,
        such as indicated by "Removed..." or "Deleted...".
    -   `breaking`: For breaking or backwards incompatible changes,
        such as indicated by "Breaking change...".
        Often used with `removed` or other significant modifications.
    -   `versioned`: For changes that are language versioned,
        such as a new language syntax which often are.
    -   `changed`: For general updates or modifications,
        a default tag that can be used as a fallback.

    **Example:**

    ```yaml
    - version: 3.11.0
      ...
      description: |
        Added support for Unix domain sockets...
      tags:
        - new  # Changed from 'changed' because it adds a new feature.
    ```

5.  **Ensure presence of links**

    Ensure every entry has a valid URL set as its `link` field.
    If no specific issue or PR link is available in the description,
    link to the specific section in the SDK changelog.

    -   **Format:**
        `https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#<VERSION_ANCHOR>`
    -   **Example:**
        `https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#3110` (for
        3.11.0)

    ```yaml
    - version: 3.11.0
      ...
      link: https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#3110
    ```

6.  **Fix any formatting or typo issues**

    Review the changelog entries for any Markdown or YAML syntax issues
    as well as typos or grammatical errors.
    If found, fix them before continuing on.

7.  **Request user review**

    Notify the user that the changelog has been updated and tags refined.
    Ask them to verify the changes before committing.

## Troubleshooting

-   If no entries are found, verify the version exists in the
    [SDK changelog](https://raw.githubusercontent.com/dart-lang/sdk/main/CHANGELOG.md).
-   If entries are missing or malformed, check the tool logic in
    `tool/dash_site/lib/src/commands/sync_changelog.dart`.
