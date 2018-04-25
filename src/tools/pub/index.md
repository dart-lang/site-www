---
title: Pub Package Manager
short-title: Pub
description: Use the pub tool to manage Dart packages.
---

You can use the `pub` tool to manage Dart packages.
Pub is one of the tools that you get when you
[install](/tools/sdk#install) the Dart SDK.

{% include flutter-packages.md %}

You can access the `pub` commands either through an IDE,
such as WebStorm, or at the command line.
Use whatever approach is most convenient.

<aside class="alert alert-info" markdown="1">
  **Problems?**
  See [Troubleshooting Pub](/tools/pub/troubleshoot).
</aside>

## Managing packages

Dart applications rely on packages. If your Dart app uses one or
more library packages, then your app itself must be an
application package.

{% include tools/pub-was-a-builder.md %}

### How to

* [Getting Started with Pub](/tools/pub/get-started)
* [Create Library Packages](/guides/libraries/create-library-packages)
* [Configuring Pub Environment Variables](/tools/pub/environment-variables)
* [Publishing a Package](/tools/pub/publishing)

### Concepts

* [Pub Dependencies](/tools/pub/dependencies)
* [Pub Package Layout Conventions](/tools/pub/package-layout)
* [Pub Versioning Philosophy](/tools/pub/versioning)

### Reference

* [Pubspec Format](/tools/pub/pubspec)
* [Glossary](/tools/pub/glossary)

## Pub commands

The `pub` tool provides the following commands:

* [`pub cache`](/tools/pub/cmd/pub-cache)
* [`pub deps`](/tools/pub/cmd/pub-deps)
* [`pub downgrade`](/tools/pub/cmd/pub-downgrade)
* [`pub get`](/tools/pub/cmd/pub-get)
* [`pub global`](/tools/pub/cmd/pub-global)
* [`pub publish`](/tools/pub/cmd/pub-lish)
* [`pub run`](/tools/pub/cmd/pub-run)
* [`pub upgrade`](/tools/pub/cmd/pub-upgrade)
* [`pub uploader`](/tools/pub/cmd/pub-uploader)

For an overview of all the `pub` commands,
see [Pub Commands](/tools/pub/cmd).


## Troubleshooting

[Troubleshooting Pub](/tools/pub/troubleshoot) gives solutions to problems that
you might encounter when using pub.
