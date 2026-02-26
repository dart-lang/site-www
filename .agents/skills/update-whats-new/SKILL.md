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
    -   Pages that have been deprecated.
    -   New tutorials or guide enhancements.

    > [!IMPORTANT]
    > When analyzing changes for the "Site improvements" section, ONLY include entries that are meaningful and user-facing to someone reading our documentation.
    >
    > **Do NOT include:**
    > - Non-user-facing infrastructure changes (e.g., "Inlined card content on the docs index page").
    > - Internal refactoring or maintenance simplifications.
    > - Minor tweaks not relevant to the broader documentation experience (e.g., "Surfaced lint release versions", "Made heading anchors copy the full URL to the clipboard").
    >
    > **DO include specific, high-impact changes, for example:**
    > - Migrated core site infrastructure to the [Jaspr framework][Jaspr migration] for an improved contributor experience.
    > - Enhanced the Glossary with new [filtering by label][Glossary filtering] and [tooltips][Glossary tooltips].
    > - Redesigned the [Community page][Community page redesign] with a modern card-based layout.
    > - Started compiling client-side Dart code to [Wasm][Wasm compilation].
    >
    > _Look at the 3.10 and older release sections for more examples._

4.  **Create a new release section**
    In `src/content/resources/whats-new.md`, create a new section at the top of the file (just below the header/introduction) for the new release.
    Follow the formatting and structure of past releases on the page:
    -   Heading specifying the release version (e.g., `## 3.12 release`).
    -   Release date line (e.g., `_Released on: <Date>_`). Ask the developer for the release date, or leave a placeholder if unknown.
    -   A short summary paragraph describing what the section covers, including the date range.

    **Update the global metadata:**
    Locate the `lastVerified` field in the YAML frontmatter at the very top of `src/content/resources/whats-new.md` and update it to the new release date.

5.  **Add entries for meaningful changes**
    For each meaningful change identified in Step 3:
    -   Add an entry under the appropriate subsection (e.g., `### Documentation updates {:.no_toc}`).
    -   Write a concise explanation of the change.
    -   Add a crosslink to the relevant section or new page.
    -   If a third-party contributor was involved in the commit (indicated by the PR or author info), thank them by including their GitHub handle in parentheses (e.g., `(Thank you, [username](https://github.com/username).)`).

6.  **Format glossary terms for hover tooltips**
    If any new glossary terms were added, format their markdown references to include the fragment anchor to the term. This enables a hover tooltip for the reader.
    For example, structure the links at the bottom of the release section like this:
    ```markdown
    [top type]: /resources/glossary#top-type
    [null safety]: /resources/glossary#null-safety
    [sound]: /resources/glossary#sound 
    ```

7.  **Add release announcement placeholder**
    You will need links for the release announcement and the SDK changelog. Ask the developer for the link to the release announcement, or use a placeholder if the link is not available yet. Include a link to the changelog as used in past releases.

8.  **Format links/anchors**
    Add the markdown reference links at the bottom of the new release section, matching the style used throughout the document (e.g., `[3.11 announcement]: https://blog.dart.dev/...`).

9.  **Request review**
    Notify the developer that the `whats-new.md` page has been updated and ask them to verify the changes.
