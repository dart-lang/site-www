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
    >
    > Re-running `sync-changelog` for a version that's already in
    > `src/data/changelog.yml` skips SDK entries that match an existing entry
    > by GitHub issue/PR URL or identical description. Entries that were
    > reworded or intentionally left out can't be matched, so the tool only
    > prints the remaining entries and doesn't write them. Review that list,
    > then re-run with `--add-unmatched` to insert the entries and delete any
    > that duplicate existing ones.

2.  **Verify changes**

    Check `src/data/changelog.yml` to ensure new entries are correct.

    -   Review the diff: `git diff src/data/changelog.yml`
    -   Ensure formatting is consistent and
        the new entries are grouped with their version,
        with versions in descending order.

3.  **Confirm the release date**

    The tool reads the release date from the `**Released on:**` line
    of the version's section in the SDK changelog.
    If that line still says `Unreleased`
    (common on release day, before the SDK changelog is updated),
    the tool prints a warning and writes `releaseDate: TBD` instead.

    The changelog page shows the `x.y.0` entry's date in the version
    header as "Released YYYY-MM-DD", so a `TBD` placeholder is
    visible to users and causes `check-changelog` and
    `changelog_data_test` to fail.

    If you see the warning or any `releaseDate: TBD` in the diff,
    replace every `releaseDate: TBD` in `src/data/changelog.yml`
    for that version with the date in `YYYY-MM-DD` format.
    Re-running the tool doesn't update the date of
    entries that are already in the file.

    If you know the release date before you sync,
    pass it on the first run instead:

    ```bash
    dart run dash_site sync-changelog --version 3.11.0 --release-date 2026-02-11
    ```

4.  **Filter and prune entries**

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

5.  **Refine tags**

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
      # ...
      description: |
        Added support for Unix domain sockets...
      tags:
        - new  # Changed from 'changed' because it adds a new feature.
    ```

6.  **Ensure the presence of links**

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
      # ...
      link: https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#3110
    ```

7.  **Fix any formatting or typo issues**

    Review the changelog entries for issues such as:

    -   Markdown or YAML syntax issues.
    -   Typos or grammatical errors.
    -   `subArea` fields that aren't in sentence case.
        For example, use "Type promotion" instead of "Type Promotion".
        If a word isn't a proper noun, and it isn't the first word,
        don't capitalize it.

    If found, fix them before continuing on.

8.  **Validate the data**

    Run the `check-changelog` CLI check and the changelog data test to catch
    schema problems, unknown tags, non-monotonic versions, conflicting or
    placeholder release dates, duplicates, and unresolved reference links:

    ```bash
    dart run dash_site check-changelog
    cd site && dart test test/changelog_data_test.dart
    ```

    Fix any failures they report in `src/data/changelog.yml`.

9.  **Review SDK coverage**

    List the SDK issue and PR links and the sub-areas for the version
    that have no counterpart in `src/data/changelog.yml`:

    ```bash
    dart run dash_site sync-changelog --check --version <VERSION>
    ```

    Treat the output as a list to review, not as failures to fix.
    The command exits with a non-zero code whenever it lists anything,
    and it lists the entries you removed in step 4 and
    any sub-areas you renamed.
    Only add an entry back if it was left out by mistake.

10. **Request user review**

    Notify the user that the changelog has been updated and tags refined.
    Ask them to verify the changes before committing.

## Troubleshooting

-   If no entries are found, verify the version exists in the
    [SDK changelog](https://raw.githubusercontent.com/dart-lang/sdk/main/CHANGELOG.md).
-   If entries are missing or malformed, check the tool logic in
    `tool/dash_site/lib/src/commands/sync_changelog.dart`.
