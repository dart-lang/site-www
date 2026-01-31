# Update SDK Changelog Workflow

This workflow describes the steps to update the Dart SDK changelog entries in `src/data/changelog.yml` using the `sync_sdk_changelog` MCP tool.

## Prerequisites
- Verify the Dart SDK version you wish to sync (e.g., check `https://github.com/dart-lang/sdk/releases` or `CHANGELOG.md`).

## Workflow Steps

1.  **Run the Sync Tool**
    Execute the `sync_sdk_changelog` tool with the target version.
    - **Command:** `sync_sdk_changelog(version='<VERSION>')`
    - **Example:** `sync_sdk_changelog(version='3.11.0')`
    
    > [!TIP]
    > You can preview the changes first by setting `dryRun=true`:
    > `sync_sdk_changelog(version='3.11.0', dryRun=true)`

2.  **Verify Changes**
    Check `src/data/changelog.yml` to ensure new entries are correct.
    - Review the diff: `git diff src/data/changelog.yml`
    - Ensure formatting is consistent (entries are prepended correctly).

3.  **Filter & Prune Entries**
    Remove entries that do not represent concrete, user-facing changes to the SDK.
    
    **Remove entries that are:**
    -   **Vague/Nebulous:** e.g., "Various performance improvements", "Minor internal updates". (Users need to know *what* improved).
    -   **Non-functional:** e.g., "Thanks to @user for...", "Fixed typo in comment".
    -   **Redundant:** Entries that duplicate others for the same feature.

4.  **Refine Tags**
    Review the `description` of each new entry and update the `tags` list to be more specific. The tool defaults to `['changed']`.
    
    **Available Tags & Guidelines:**
    -   `new`: For new features, additions, or introductions (e.g., "Added...", "Introduced...").
    -   `fixed`: For bug fixes (e.g., "Fixed...", "Bug fix...").
    -   `deprecated`: For deprecations (e.g., "Deprecated...", " marked as legacy...").
    -   `experimental`: For experimental features (e.g., "Experimental...", "Preview...").
    -   `removed`: For removals (e.g., "Removed...", "Deleted...").
    -   `breaking`: For breaking changes (often used with `removed` or significant modifications).
    -   `changed`: For general updates or modifications (default).
    -   `versioned`: For version-specific notes (less common).

    *Example:*
    ```yaml
    - version: 3.11.0
      ...
      description: |
        Added support for Unix domain sockets...
      tags:
        - new  # Changed from 'changed' because it adds a new feature
    ```

5.  **Ensure Links**
    Ensure every entry has a `link`. If no specific issue or PR link is available in the description, link to the specific section in the SDK CHANGELOG.
    
    *   **Format:** `https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#<VERSION_ANCHOR>`
    *   **Example:** `https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#3110` (for 3.11.0)
    
    ```yaml
    - version: 3.11.0
      ...
      link: https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#3110
    ```

6.  **Request User Review**
    Notify the user that the changelog has been updated and tags refined. Ask them to verify the changes before committing.

## Troubleshooting
- If no entries are found, verify the version exists in the [SDK CHANGELOG](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md).
- If entries are missing or malformed, check the `SyncSdkChangelogTool` parsing logic in `tool/mcp_server/lib/tools/changelog.dart`.
