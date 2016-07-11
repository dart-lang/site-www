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
[Running a script from your PATH](cmd/pub-global#running-a-script-from-your-path).
</aside>

You can access the `pub` commands either through an IDE,
such as WebStorm, or at the command line.
Use whatever approach is most convenient.

<aside class="alert alert-info" markdown="1">
**Problems?**
See [Troubleshooting Pub](troubleshoot).
</aside>

## Managing packages

Dart applications rely on packages. If your Dart app uses one or
more library packages, then your app itself must be an
application package.

### How to

* [Getting Started with Pub](get-started)
* [Create Library Packages](/guides/libraries/create-library-packages)
* [Installing and Configuring Pub](installing)
* [Publishing a Package](publishing)

### Concepts

* [Pub Dependencies](dependencies)
* [Pub Package Layout Conventions](package-layout)
* [Pub Assets and Transformers](assets-and-transformers)
* [Pub Versioning Philosophy](versioning)

### Reference

* [Pubspec Format](pubspec)
* [FAQ](/tools/faq#pub)
* [Glossary](glossary)

## Pub commands

The `pub` tool provides commands for a variety of purposes.
One command installs packages, another starts up an HTTP server for testing,
another prepares your app for deployment, and another
publishes your package to [pub.dartlang.org](https://pub.dartlang.org).

For an overview of these commands, see [Pub Commands](cmd/).

The following reference pages cover each command in detail:

* [`pub cache`](cmd/pub-cache)
* [`pub deps`](cmd/pub-deps)
* [`pub downgrade`](cmd/pub-downgrade)
* [`pub get`](cmd/pub-get)
* [`pub global`](cmd/pub-global)
* [`pub publish`](cmd/pub-lish)
* [`pub run`](cmd/pub-run)
* [`pub upgrade`](cmd/pub-upgrade)
* [`pub uploader`](cmd/pub-uploader)

In addition to these commands, there are two pub commands specific
to web development. See [webdev]({{site.webdev}}/tools) for more
information.

## Writing transformers

When `pub` serves or builds an app, it can run one or more
transformers&mdash;for example, one transformer converts Dart
files into a single JavaScript file.

Transformers operate on assets, where an asset is
a resource, such as a Dart file, a CSS file, or an
image, that is intended to be part of a deployed package.

The following pages cover how to write a custom transformer:

* [Writing a Pub Transformer](transformers/)
* [Writing an Aggregate Transformer](transformers/aggregate)
* [Writing a Lazy Transformer](transformers/lazy-transformer)
* [Examples of Transformer Code](transformers/examples)
* [Barback - Can We Build It? Yes, We Can!](https://docs.google.com/a/google.com/document/d/1juHkCRg-1YH6LvwhGPHgF2ihX-UQtR1fv-8aknO7t_4/edit?pli=1#)

## Troubleshooting {#troubleshooting}

[Troubleshooting Pub](troubleshoot) gives solutions to problems that
you might encounter when using pub.
