---
name: update-whats-new
description: Update the what's-new page with changes since the previous release.
---

# Update What's New Page

Use this skill when a new release has occurred and you need to update `src/content/resources/whats-new.md` to describe the changes to the website since the previous release.

## Steps

1.  **Identify the previous release date**
    Read `src/content/resources/whats-new.md` and locate the topmost release section.
    Find the "Released on" date for that release. This is your starting point.

2.  **Retrieve recent Git commits**
    Look at the git commits that have been made to the repository since the previous release date identified in Step 1.
    For example: `git log --after="<previous_release_date>" --oneline`.

3.  **Analyze commits for meaningful changes**
    Analyze the content of each commit since that date. Identify changes that are significant to developers or users.
    Look for:
    -   New glossary terms added.
    -   Large or significant page updates.
    -   New pages that have been added.
    -   New tutorials or guide enhancements.

4.  **Create a new release section**
    In `src/content/resources/whats-new.md`, create a new section at the top of the file (just below the header/introduction) for the new release.
    Follow the formatting and structure of past releases on the page:
    -   Heading specifying the release version (e.g., `## 3.12 release`).
    -   Release date line (e.g., `_Released on: <Current Date>_`).
    -   A short summary paragraph describing what the section covers, including the date range.

5.  **Add entries for meaningful changes**
    For each meaningful change identified in Step 3:
    -   Add an entry under the appropriate subsection (e.g., `### Documentation updates {:.no_toc}`).
    -   Write a concise explanation of the change.
    -   Add a crosslink to the relevant section or new page.
    -   If a third-party contributor was involved in the commit (indicated by the PR or author info), thank them by including their GitHub handle in parentheses (e.g., `(Thank you, [username](https://github.com/username).)`).

6.  **Add release announcement placeholder**
    You will need links for the release announcement and the SDK changelog. Ask the developer for the link to the release announcement, or use a placeholder if the link is not available yet. Include a link to the changelog as used in past releases.

7.  **Format links/anchors**
    Add the markdown reference links at the bottom of the new release section, matching the style used throughout the document (e.g., `[3.11 announcement]: https://blog.dart.dev/...`).

8.  **Request review**
    Notify the developer that the `whats-new.md` page has been updated and ask them to verify the changes.
