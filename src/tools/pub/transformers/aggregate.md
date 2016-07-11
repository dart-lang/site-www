---
layout: default
title: "Writing an Aggregate Transformer"
description: How to write a Pub transformer to processes multiple input assets.
permalink: /tools/pub/transformers/aggregate
---

An aggregate transformer processes multiple assets in a single
pass&ndash;for example, collaging multiple images into a single image.

Most of the steps for writing an aggregate transformer are the same
as for writing a normal transformer. This document
only describes the differences specific to aggregate transformers.
If you aren't familiar with how to write a normal Pub tranformer, see
[Writing a Pub Transformer](/tools/pub/transformers).

This page uses the aggregate_transformer example which you can find
through [Examples of Transformer Code](/tools/pub/transformers/examples).

## Implementing an aggregate transformer

An aggregate transformer extends the Dart class, [AggregateTransform][],
from the [barback][] package.

[AggregateTransform]: https://www.dartdocs.org/documentation/barback/0.15.2%2B8/barback/AggregateTransform-class.html
[barback]: https://pub.dartlang.org/packages/barback

### Extend `AggregateTransformer`

In the Dart file with your transformer subclass,
extend the `AggregateTransformer` class from the barback package:

{% prettify dart %}
class MyTransformer extends AggregateTransformer { ... }
{% endprettify %}

### Claim input assets

An aggregate transformer claims its input assets by implementing
the `classifyPrimary` method. For an asset that you want to process,
return a value, or key. For assets that you do not care about,
return null. Pub calls the `classifyPrimary` method on every
potential input asset. Assign the same key to all assets that
you want to be processed together; these assets will be
available in the `apply` method through the `AggregateTransform`
parameter.

The following example, from aggregate_transformer,
only accepts assets whose filename ends with the string `.recipe.html`
For assets that it wants to process,
it returns the path of the source directory, which is where
it wants the output asset to be placed.

{% prettify dart %}
import 'package:path/path.dart' as path;

...

classifyPrimary(AssetId id) {
    // Only process assets where the filename ends with ".recipe.html".
    if (!id.path.endsWith('.recipe.html')) return null;

    // Return the path string, minus the recipe itself.
    // This is where the output asset will be written.
    return path.url.dirname(id.path);
}
{% endprettify %}

### Process input assets

To process assets, implement the `apply()` method.
In this method, you access all of the relevant assets
through the passed-in AggregateTransform, manipulate them,
and write out the new asset.

To request a handle to all input assets, you can use
the `primaryInputs` property in AggregateTransformer.
This provides a stream of type `Asset`. Note that the assets
returned from primaryInputs have no guaranteed order and might
change each time the transformer is run, so
you might need to re-order the assets before processing.

Because the inputs are provided asynchronously,
you must write your code carefully. Functions that
return a Future must be chained together and, before creating
the output asset, use `Future.wait` to ensure that
all assets have been processed.

The following `apply` method, from AggregateTransformer,
reads the recipes, sorts them alphabetically according to
the assets' ID, and creates an output asset with
the recipes compiled into a complete HTML file.

{% prettify dart %}
Future apply(AggregateTransform transform) async {
  var buffer = new StringBuffer()..write('<html><body>');

  var assets = await transform.primaryInputs.toList();
  assets.sort((x, y) => x.id.compareTo(y.id));
  for (var asset in assets) {
    var content = await asset.readAsString();
    buffer.write(content);
    buffer.write('<hr>');
  }
  buffer.write('</body></html>');
  // Write the output back to the same directory,
  // in a file named recipes.html.
  var id = new AssetId(
      transform.package, p.url.join(transform.key, "recipes.html"));
  transform.addOutput(new Asset.fromString(id, buffer.toString()));
}
{% endprettify %}

If you wish to request a specific secondary input, you can use the
`getInput` or `readInput` methods.

## More information

* [Writing a Pub Transformer](/tools/pub/transformers/)
: How to write a Pub transformer that accepts a single primary input.
* [Examples of Transformer Code](/tools/pub/transformers/examples)
: Examples to get you started.
* [barback library](https://pub.dartlang.org/packages/barback)
: API docs for the barback package.
* [Barback - Can We Build It? Yes, We Can!](https://docs.google.com/a/google.com/document/d/1juHkCRg-1YH6LvwhGPHgF2ihX-UQtR1fv-8aknO7t_4/edit?pli=1#)
: A description of the barback asset system, written by a
member of the Dart engineering team.

