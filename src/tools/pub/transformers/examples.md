---
layout: default
title: "Examples of Transformer Code"
description: "A list of examples that illustrate how to write transformers for the pub tool."
permalink: /tools/pub/transformers/examples
toc: false
---

When _pub_ serves, builds, or runs an app, it can run one or more
transformers. ([Learn more about pub](/tools/pub/).)

Transformers operate on _assets_, where an asset is a resource,
such as a Dart file, a CSS file, or an image, that is intended to
be part of a deployed package.
([Learn more about assets and transformers](/tools/pub/assets-and-transformers).)

The following are examples of custom transformers written using
the [barback](https://pub.dartlang.org/packages/barback) package.
The description for each example states where you can get more information
about that particular example.

[aggregate_transformer](https://github.com/dart-lang/barback/tree/master/example/aggregate_transformer)
: Combines partial HTML files contained in a "recipes" directory into a
  single HTML file. See
  [Writing an Aggregate Transformer](/tools/pub/transformers/aggregate)
  for more information.

[lazy_transformer](https://github.com/dart-lang/barback/tree/master/example/lazy_transformer)
: Lazily converts a text file using a ROT13 converter. See
  [Writing a Lazy Transformer](/tools/pub/transformers/lazy-transformer)
  for more information.

[markdown_converter](https://github.com/dart-lang/barback/tree/master/example/markdown_converter)
: Converts a markdown file (with either a ".mdown", ".md", or
  a ".markdown" extension) to HTML. The output asset has
  an ".html" extension.  See
  [Writing a Pub Transformer](/tools/pub/transformers/) for more information.

[simple_transformer](https://github.com/dart-lang/barback/tree/master/example/simple_transformer)
: Inserts a copyright string at the beginning of a ".txt" file. See
  [Writing a Pub Transformer](/tools/pub/transformers/) for more information.

All of these examples are part of the
[barback](https://github.com/dart-lang/barback) repo on GitHub.

To run an example, first clone or download the barback repo.
Then under the <code>example/<em>example_name</em></code> directory,
create an empty `web` directory, and run `pub build` to generate the assets.
Pub transforms the sample assets (located in `lib`)
and places them under `build`.
