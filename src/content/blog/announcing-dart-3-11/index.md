---
title: "Announcing Dart 3.11"
description: "Hello, Dart developers! The latest stable version, Dart 3.11, is officially here!"
publishDate: 2026-02-11
author: conooi
image: images/129dKLBxAMepAi2od91c3TA.png
category: releases
layout: blog
---


This release focuses heavily on responsiveness and tooling improvements that you’ll feel in your daily workflow. From a smarter analysis server to new pub client capabilities and enhanced AI support, Dart 3.11 is built to keep you in the flow. Read on to learn more.

<DashImage src="images/129dKLBxAMepAi2od91c3TA.png" alt="Announcing Dart 3.11" caption="Announcing Dart 3.11" />


## Language updates

No new language updates in this release of Dart.

## Tools updates

### Dart MCP & AI Support: Package URI

We are continuing to improve the [Dart and Flutter MCP Server](https://docs.flutter.dev/ai/mcp-server) to better support AI coding assistants.

We’ve added a new tool called `read_package_uris` to the MCP server. This tool allows AI agents (like Cursor, Gemini, or Copilot) to read package URIs from your projects and add them to their context. This ensures that your AI assistant can correctly read, resolve, and utilize dependencies when generating code.

### Analysis server

This release includes numerous performance improvements in the Dart analysis server. The server now uses “fine-grained dependencies” making it more intelligent in deciding what code needs to be re-analyzed during IDE sessions.

We’ve also improved analysis performance in specific situations, such as analyzing code with cycles in the directory structure caused by symlinks, or deep trees of many constant objects.

The server now caches compiled analyzer plugin entry points, resulting in faster startup time in IDE sessions and the `dart analyze` and `flutter analyze` commands.

Finally, we’ve enhanced “dot shorthands” support across many analysis server features, especially code completion, quick fixes, and quick assists.

## Pub updates

### Glob support in pub workspaces

[Pub workspaces](https://dart.dev/tools/pub/workspaces) now support declaring packages using globs. This enables you to easily include all packages in a directory in the pub workspace without enumerating them all:

```yaml
# Before
name: workspace
environment:
 sdk: ^3.10.0
workspace:
 - pkg/a
 - pkg/b
 - pkg/c
# After
name: workspace
environment:
 sdk: ^3.11.0
workspace:
 - pkg/* # Adds all packages inside pkg.
```


Note: To use this feature, your `pubspec.yaml` must have a Dart version of 3.11 or higher.

### Pub cache gc

Pub has always stored packages in a single global `PUB_CACHE`, ensuring you never download the same package twice. However, since Pub didn’t track which projects used the cache, there was no way to know which packages were outdated, causing package-versions to accumulate over time. Until now, the only solution was to wipe the entire cache and start over.

As of Dart 3.9, `pub get` has been storing the path to the resolved project inside the cache. Now in Dart 3.11, we introduce the command `pub cache gc` that iterates over all “living” projects, marks all package versions they depend on, and deletes the rest. This can help you reclaim valuable disk space.

```bash
> dart pub cache gc
Found 3 active projects:
* /home/yourusername/projects/pub
* /home/yourusername/projects/pub-dev
* /home/yourusername/projects/pana
All other projects will need to run `dart pub get` again to work correctly.
Will recover 2 GB.
Are you sure you want to continue? (y/N)? y
Deleting unused cache entries... (4.5s)
>
```


## Wrap up

That’s it for Dart 3.11! This release is all about the details that make a difference in your day-to-day development.

For a full list of changes, check out the [Dart SDK changelog](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md). As always, we’d love to hear your feedback!