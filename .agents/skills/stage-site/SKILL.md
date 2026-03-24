---
name: stage-site
description: >-
  Stages the Dart site locally. This includes upgrading Flutter/Dart, checking
  for broken links, syncing excerpts, formatting Dart code, adding Firebase
  shortcuts, and serving the development site.
---

# Stage the Dart site

Before reviewing changes, pushing a PR,
or testing the site locally,
follow these steps to properly stage the repository.

## 1. Upgrade Flutter or Dart

Check if there's a new stable version of Flutter or Dart.
If so, upgrade your environment before proceeding.

For Flutter, you can run:

```bash
flutter upgrade
```

For Dart only, you might use brew or your package manager:

```bash
brew upgrade dart
```

## 2. Check for broken links

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

## 3. Sync code excerpts

Ensure that any changes made to code examples in the workspace
are synced correctly into the corresponding Markdown files:

```bash
dart run dash_site refresh-excerpts
```

## 4. Update formatting

Update the formatting of the site's Dart code and examples
to stay compliant with standard formatting rules:

```bash
dart run dash_site format-dart
```

## 5. Add Firebase shortcuts

If the user has specified any new URL shortcuts or redirects,
add them to the `firebase.json` file.

Locate the `hosting.redirects` array
and insert the new shortcut object.
For example:

```json
{
  "source": "/new-shortcut",
  "destination": "/destination-path",
  "type": 301
}
```

## 6. Stage the site locally

Finally, serve a local development environment
to preview the changes in your browser:

```bash
dart run dash_site serve
```
