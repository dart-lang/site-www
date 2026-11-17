---
name: update-llms-text
description: >-
  Update and maintain the llms.txt file. Use when the user wants to
  add sections, add links, correct information, or review the llms.txt file.
---

# Update llms.txt

Update `src/content/llms.txt`, a curated resource list that helps Large
Language Models understand the Dart language, core libraries, and ecosystem.

Always start by reading the existing `src/content/llms.txt` to understand the
current structure and content before making changes.

## Actions

Based on the user-provided action, perform one of the following tasks:

### Add a section

When asked to add a new section:

1.  If not provided, ask for the section title and links.
1.  Use sentence case for the heading and avoid slashes (`/`).
1.  Place the new section in a logical location relative to existing sections.

### Add links

When asked to add new links to an existing section:

1.  If not provided, ask for the target section and links to add.
1.  For each link provided:

    1.  For a `dart.dev` link, verify that the page exists under `src/content/`
        or as a generated route in `site/lib/src/pages/custom_pages.dart`.
    1.  Choose the [link destination](#choose-a-link-destination).
        Read the page to identify its title and write a concise description.
    1.  Append the link to the specified section,
        following the [formatting rules](#formatting-rules).

### Correct information

When asked to correct information:

1.  If not provided, ask for the incorrect information and the correction.
1.  Update `src/content/llms.txt` with the corrected information.

### Review the file

When asked to review the file:

1.  Read the entire `src/content/llms.txt` file.
1.  Check for duplicate entries, broken links, inconsistent formatting,
    spelling and grammar issues, and missing major guides.
    Check each [link destination](#choose-a-link-destination).
1.  Report findings and suggestions to the user, and wait for approval before
    making changes.

## Choose a link destination

Prefer a published Markdown URL when it
contains the material the entry describes.
On `dart.dev`, follow the page's `rel="alternate"` link with
`type="text/markdown"` to find its clean `.md` URL.
For external resources, use the Markdown URL the site provides.

Read the Markdown response and check that it includes the relevant content.
For changes awaiting deployment, check the same files in the local site build.
Use the canonical HTML URL if the site has no Markdown version
or if the export omits the content, such as the generated diagnostic index.

## Formatting rules

-   Format each entry like this example:

    ```markdown
    - [Variables](https://dart.dev/language/variables.md): Declare variables.
    ```

-   Separate sections with a single blank line.
-   Keep descriptions concise, specific, and free of trailing whitespace.
