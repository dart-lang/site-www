---
name: prepare-to-stage
description: >-
  Stages the Dart site locally for PR validation. Includes formatting Dart code,
  syncing excerpts, building the site, checking for broken links, and serving
  the development site.
---

# Prepare the Dart site for staging

Before reviewing changes, pushing a PR,
or testing the site locally,
follow these steps to properly stage the repository.

## 1. Update formatting

Update the formatting of the site's Dart code and examples
to stay compliant with standard formatting rules.
This must be done before syncing excerpts
so the generated code matches the source format:

```bash
dart run dash_site format-dart
```

## 2. Sync code excerpts

Ensure that any changes made to code examples in the workspace
are synced correctly into the corresponding Markdown files:

```bash
dart run dash_site refresh-excerpts
```

## 3. Build the site

For the link checker to validate local URLs,
the site must be built first.
Run the build command:

```bash
dart run dash_site build
```

## 4. Check for broken links

Verify that all internal pages, URLs, and markdown link references are intact.

First, check for broken Markdown link references:

```bash
dart run dash_site check-link-references
```

Second, check for broken cross-page links:

```bash
dart run dash_site check-links
```

If you detect any broken links,
attempt to patch them or alert the user about the issues.

## 5. Stage the site locally

Finally, serve a local development environment
to preview the changes in your browser:

```bash
dart run dash_site serve
```
