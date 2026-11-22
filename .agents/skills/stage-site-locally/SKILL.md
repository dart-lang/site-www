---
name: stage-site-locally
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
Format Dart code before syncing excerpts
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

## 3. Lint Markdown and site variables

Scan changed Markdown files for known formatting issues
and hardcoded URLs that can use site variables:

```bash
dart run dash_site check-markdown
dart run dash_site check-site-variable
```

## 4. Build the site

Build the site before running the link checks:

```bash
dart run dash_site build
```

## 5. Check for broken links

Verify that all internal pages, URLs, and Markdown link references are intact.

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

## 6. Stage the site locally

Finally, serve a local development environment
to preview the changes in your browser:

```bash
dart run dash_site serve
```
