# Changelog page architecture

This document describes the architecture of the Changelog page implementation in the `site/` directory.

## Overview

The Changelog page is a **hybrid static/dynamic** page. It renders all content
statically on the server (SSG) for SEO and fast initial load, but includes a
client-side JavaScript layer to handle interactive filtering and searching
without requiring page reloads or server round-trips.

## Key components

### 1. Data model (`ChangelogEntry`)

+   **Location**: `site/lib/src/models/changelog_model.dart`

+   **Purpose**: Represents a single changelog item (version, date, area,
    description, tags, etc.).

+   **Dual Parsing**:

    +   **Server-side**: Parsed from the page's data map
        (`context.page.data['changelog']`).

    +   **Client-side**: Parsed *back* from the rendered HTML DOM elements using
        `data-` attributes.

### 2. Main page (`ChangelogIndex`)

+   **Location**: `site/lib/src/components/pages/changelog/changelog_index.dart`

+   **Type**: Stateless Server Component.

+   **Responsibility**:

    +   Receives the raw changelog data.

    +   Renders the initial HTML structure, including the sidebar and the list
        of entries.

    +   **Crucial Step**: Renders each entry as a `_ChangelogEntryCard` which
        embeds the entry's data into HTML `data-` attributes (e.g.,
        `data-version`, `data-area`, `data-tags`). This allows the client-side
        script to "read" the data without needing a separate JSON payload.

### 3. Filtering logic (`ChangelogFilters` & `ChangelogFiltersSidebar`)

+   **Location**:

    +   `site/lib/src/components/pages/changelog/changelog_filters.dart`

    +   `site/lib/src/components/pages/changelog/changelog_filters_sidebar.dart`

    +   `site/lib/src/components/common/client/filtering.dart` (Shared UI
        components: `CheckboxFilterGroup`, `CollapsibleFilterGroup`,
        `FilterToolbar`)

+   **Type**: Client Components (`@client`).

+   **Responsibility**:

    +   **Hydration**: On load, `ChangelogFilters` scans the DOM for
        `.changelog-card` elements and reconstructs the list of `ChangelogEntry`
        objects.

    +   **State Management**: `ChangelogFiltersNotifier` (a singleton-like
        notifier) manages the state of selected filters (tags, areas, versions)
        and the search query.

        +   **SSR Safety**: To prevent state leaks between requests during
            development or static generation, `ChangelogIndex` calls
            `disposeState()` on the notifier at the start of the build.

        +   **Initialization**: `ChangelogFiltersSidebar` initializes the
            available filters (by scanning the DOM) inside `initState` using
            `addPostFrameCallback`. This ensures that DOM access only happens on
            the client, preventing "Scheduling a frame" errors during
            server-side rendering.

    +   **Interaction**:

        +   The **Sidebar** updates the notifier when checkboxes are toggled.

        +   The **Search Bar** updates the notifier when text is typed.

    +   **Rendering Updates**: When the notifier changes, `ChangelogFilters`
        calculates which entries match the criteria and toggles the `hidden` CSS
        class on the corresponding DOM elements.

## Data flow

1.  **Build Time**:

    +   Changelog data is read from source (e.g., YAML/Markdown).

    +   `ChangelogIndex` iterates over this data.

    +   HTML is generated with all entries visible by default.

    +   Data is serialized into `data-` attributes on each card.

2.  **Client Load**:

    +   The browser loads the static HTML.

    +   `ChangelogFilters` component initializes.

    +   It queries `document.getElementById('all-changelog-list')`.
    +   It reads all children, parsing the `data-` attributes to build an
        in-memory list of `ChangelogEntry` objects.

    +   `ChangelogFiltersSidebar` also scans the DOM to populate the "Available
        Filters" lists (e.g., finding all unique "Areas" present on the page).

3.  **User Interaction (Filtering)**:

    +   User clicks a checkbox (e.g., "Area: Language").

    +   `ChangelogFiltersNotifier` updates its state.

    +   `ChangelogFilters` listener fires.

    +   It iterates through its in-memory entries, checking if they match the
        new filters.

    +   It updates the DOM: `element.classList.remove('hidden')` for matches,
        `add('hidden')` for non-matches.

## Benefits of this approach

+   **SEO Friendly**: All content is visible in the initial HTML.

+   **Performance**: No API calls are needed for filtering. The "database" is
    the DOM itself.

+   **Simplicity**: No complex state synchronization between server and client;
    the server just renders HTML, and the client treats that HTML as its source
    of truth.

## Managing changelog entries

All changelog data is stored in a single YAML file. To add, edit, or remove
entries, you will modify this file directly.

### File location

`src/data/changelog.yml`

### Entry structure

Each entry is a YAML list item with the following fields:

```yaml
- version: 3.10.0          # (Required) The SDK version number
  releaseDate: 2025-11-12  # (Optional) YYYY-MM-DD or "TBD"
  area: Language           # (Required) Broad category: SDK, Language, Libraries, Tools
  subArea: Null safety     # (Optional) Specific feature or library name
  description: |           # (Required) Multiline description of the change.
    Null safety is now assumed...
    Supports Markdown.
  tags:                    # (Required) List of tags
    - versioned
    - changed
  link: /path/to/docs      # (Optional) URL to further documentation or issue
```

### Common tasks

#### Add an entry

1.  Open `src/data/changelog.yml`.

2.  Find the section corresponding to the relevant version (entries are 
    typically ordered by version, descending).

3.  Copy an existing entry block (including the separator comment
    `# --------------------------------------------------`).

4.  Paste it at the appropriate location.

5.  Update the fields with the new information.

#### Edit an entry

1.  Open `src/data/changelog.yml`.

2.  Search for the entry using keywords from its description or its
    version number.

3.  Modify the desired fields.

4.  Save the file. The site will rebuild with the updated content.

#### Delete an entry

1.  Open `src/data/changelog.yml`.

2.  Locate the entry block you wish to remove.

3.  Delete the entire block, including the key-value pairs and the separator
    comment above it.

### Available tags

+   `new`: New feature added.

+   `breaking`: Breaking change.

+   `fixed`: Bug fix.

+   `changed`: Behavior change.

+   `experimental`: Experimental feature.

+   `versioned`: Language versioned change.

+   `deprecated`: Feature deprecated.

+   `removed`: Feature removed.

## Builder guide: locating content

This section provides instructions for builders on how to find and
verify content on the Changelog page.

### Source of truth

The **absolute source of truth** for all changelog content is the YAML file:
`src/data/changelog.yml`

**Do not** try to parse the generated HTML or Dart code to find the *content*
of a changelog entry. Always read the YAML file.

### Find specific entries

To find an entry for a specific version or feature:

1.  **Read** `src/data/changelog.yml`.

2.  **Search** the file content.

    +   **By Version**: Search for `version: <number>`
        (e.g., `version: 3.10.0`).

    +   **By Keyword**: Search for keywords in the `description` field.

    +   **By Area**: Filter mental results by the `area` field
        (e.g., `area: Language`).

### Verify rendering (if asked to check the UI)

If you need to verify that an entry is *displayed* correctly on the site:

1.  **Understand the Mapping**:

    +   `version` -> Displayed prominently as a header or badge.

    +   `area` -> Used for filtering and often displayed as a tag or
        section header.

    +   `description` -> Rendered as Markdown.

    +   `tags` -> Rendered as colored badges (e.g., "Breaking", "New").

2.  **Check the Component**:

    +   The rendering logic is in `site/lib/src/components/pages/changelog/changelog_index.dart`.

    +   Look for `_ChangelogEntryCard` to see how the YAML data is mapped to
        HTML.

3.  **Browser Verification**:

    +   If you have browser access, navigate to `/changelog`.

    +   Use `document.querySelectorAll('.changelog-card')` to find entries.

    +   Check `dataset` attributes (e.g., `el.dataset.version`) to find the
        specific entry you are looking for.

