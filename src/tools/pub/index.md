---
layout: default
title: "Pub Package and Asset Manager"
description: "Use the pub tool to manage Dart's packages and assets."
short-title: "Pub"
permalink: /tools/pub/
---

You can use the `pub` tool to manage Dart packages and assets.
Pub also includes commands for creating, developing, and deploying Dart
applications. When you [install](/install/) the Dart SDK,
one of the tools that you get is `pub`.

<aside class="alert alert-info" markdown="1">
**Hey!**
Want to make your Dart script available from the command line?
You can do this using `pub global activate`. For more information, see
[Running a script from your PATH](/tools/pub/cmd/pub-global#running-a-script-from-your-path).
</aside>

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

### How to

* [Getting Started with Pub](/tools/pub/get-started)
* [Create Library Packages](/guides/libraries/create-library-packages)
* [Installing and Configuring Pub](/tools/pub/installing)
* [Publishing a Package](/tools/pub/publishing)

### Concepts

* [Pub Dependencies](/tools/pub/dependencies)
* [Pub Package Layout Conventions](/tools/pub/package-layout)
* [Pub Assets and Transformers](/tools/pub/assets-and-transformers)
* [Pub Versioning Philosophy](/tools/pub/versioning)

### Reference

* [Pubspec Format](/tools/pub/pubspec)
* [FAQ](/tools/faq#pub)
* [Glossary](/tools/pub/glossary)

## Pub commands

The `pub` tool provides commands for a variety of purposes.
One command installs packages, another starts up an HTTP server for testing,
another prepares your app for deployment, and another
publishes your package to [pub.dartlang.org](https://pub.dartlang.org).

For an overview of these commands, see [Pub Commands](/tools/pub/cmd/).

The following reference pages cover each command in detail:

* [`pub cache`](/tools/pub/cmd/pub-cache)
* [`pub deps`](/tools/pub/cmd/pub-deps)
* [`pub downgrade`](/tools/pub/cmd/pub-downgrade)
* [`pub get`](/tools/pub/cmd/pub-get)
* [`pub global`](/tools/pub/cmd/pub-global)
* [`pub publish`](/tools/pub/cmd/pub-lish)
* [`pub run`](/tools/pub/cmd/pub-run)
* [`pub upgrade`](/tools/pub/cmd/pub-upgrade)
* [`pub uploader`](/tools/pub/cmd/pub-uploader)

In addition to these commands, there are two pub commands specific
to web development. See [Dart webdev]({{site.webdev}}/tools) for more
information.

## Writing transformers

When `pub` serves or builds an app, it can run one or more
transformers&mdash;for example, one transformer converts Dart
files into a single JavaScript file.

Transformers operate on assets, where an asset is
a resource, such as a Dart file, a CSS file, or an
image, that is intended to be part of a deployed package.

The following pages cover how to write a custom transformer:

* [Writing a Pub Transformer](/tools/pub/transformers/)
* [Writing an Aggregate Transformer](/tools/pub/transformers/aggregate)
* [Writing a Lazy Transformer](/tools/pub/transformers/lazy-transformer)
* [Examples of Transformer Code](/tools/pub/transformers/examples)
* [Barback - Can We Build It? Yes, We Can!](https://docs.google.com/a/google.com/document/d/1juHkCRg-1YH6LvwhGPHgF2ihX-UQtR1fv-8aknO7t_4/edit?pli=1#)

## Troubleshooting

[Troubleshooting Pub](/tools/pub/troubleshoot) gives solutions to problems that
you might encounter when using pub.
