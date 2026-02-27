---
name: update-whats-new
description: Update the whats-new page with changes to the website since the previous release.
---

# Update what's new page

Use this skill when a new Dart release has occurred and
you need to update `src/content/resources/whats-new.md`
to describe the changes to the website
since the previous release.

## Steps

1.  **Identify the previous release date**

    Read `src/content/resources/whats-new.md`
    and locate the topmost release section.
    Find the "Released on" date for that release.
    This is your starting point.

2.  **Retrieve recent Git commits**

    Retrieve the git commits made to the repository
    since the previous release date identified in step 1.
    For example:
    `git log --after="<previous_release_date>" --oneline`.

3.  **Analyze commits for meaningful changes**

    Review the content of each commit since that date.
    Identify changes that are significant to developers or users.
    Look for:

    -   New glossary terms.
    -   Large or significant page updates.
    -   New pages.
    -   Deprecated or removed pages.
    -   New tutorials or guide enhancements.

    > [!IMPORTANT]
    > When analyzing changes for the
    > "Site improvements" section,
    > ONLY include entries that are meaningful and
    > user-facing to someone reading our documentation.
    >
    > **Do NOT include:**
    > - Non-user-facing infrastructure changes,
    >   such as "Inlined card content on the docs index page".
    > - Internal refactoring or maintenance simplifications.
    > - Minor tweaks that aren't relevant to
    >   the broader documentation experience, such as
    >   "Surfaced lint release versions" or
    >   "Made heading anchors copy the full URL to the clipboard".
    >
    > **DO include specific, high-impact changes, for example:**
    > - Migrated core site infrastructure to the
    >   [Jaspr framework](https://jaspr.site)
    >   for an improved contributor experience.
    > - Enhanced the Glossary by adding support for
    >   [filtering by label](https://github.com/dart-lang/site-www/pull/6945)
    >   and [tooltips](https://github.com/dart-lang/site-www/pull/6969).
    > - Redesigned the
    >   [Community page](https://github.com/dart-lang/site-www/pull/6900)
    >   with a modern card-based layout.
    > - Started compiling the website's client-side Dart code to
    >   [WebAssembly](https://github.com/dart-lang/site-www/pull/6953).
    >
    > _For more examples, reference the pre-existing release sections._

4.  **Create a new release section**

    In `src/content/resources/whats-new.md`,
    create a new section at the top of the file
    (just below the header/introduction) for the new release.
    Follow the same formatting and structure of
    past releases on the page:

    -   A heading with the release version,
        like `## 3.12 release` for Dart 3.12.
    -   A release date line,
        like `_Released on: <Date>_`.
        Ask the developer for the release date,
        or if it's not available yet, leave a placeholder.
    -   A short summary paragraph describing what the section covers,
        including the date range between the previous release and this one.
    -   Subsections for different types of changes,
        such as "documentation updates", "site improvements", etc.

    **Update the global metadata:**
    Update the `lastVerified` field in the page's YAML frontmatter
    to the new release date or if not available, today's date.

5.  **Add entries for meaningful changes**

    For each meaningful change identified in Step 3:

    -   Add an entry under the appropriate subsection,
        for example, under the "documentation updates" section.
    -   Write a concise explanation of the change.
    -   Add a link to the relevant section or new page.
        Include the link as a cross-link from the text,
        not as a standalone, full URL.
    -   If a third-party contributor was involved
        (indicated by the commit's or PR's author information),
        thank them by including their GitHub handle in parentheses,
        for example: `(Thank you, [username][].)`.

    **Note:** Only include third-party contributors;
    don't include Dart and Flutter team members, such as Daco or Parker.

6.  **Format glossary terms for hover tooltips**

    If any new glossary terms were added,
    link to their specific fragment anchor on the glossary page.
    This enables a hover tooltip for the reader.
    For example, structure the links at the bottom
    of the release section like this:

    ```markdown
    [top type]: /resources/glossary#top-type
    [null safety]: /resources/glossary#null-safety
    [sound]: /resources/glossary#sound
    ```

7.  **Add the release announcement link or a placeholder**

    Include links for the release announcement and
    the SDK changelog entries for that version.
    Ask the developer for the announcement blog link,
    or if it's not available yet, use a placeholder.
    Also include a link to the release's corresponding
    changelog entries as done in past releases.

8.  **Add and format link definitions**

    Add the link definitions of Markdown reference links
    to the bottom of the new release section,
    matching the style used throughout the document.
    For example: `[3.11 announcement]: https://...`.

9.  **Request review**

    Notify the developer that the `whats-new.md` page has been updated and
    ask them to verify the changes.
