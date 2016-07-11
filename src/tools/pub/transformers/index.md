---
layout: default
title: "Writing a Pub Transformer"
description: "How to write a Pub transformer that processes a single input asset."
permalink: /tools/pub/transformers/
---

Every time you prepare a Dart app for testing or deployment,
you are using transformers behind the scenes. The [`pub`](/tools/pub/)
tool uses the [`dart2js`]({{site.webdev}}/tools/dart2js)
compiler to "transform" (compile) Dart files to JavaScript.

While you are _using_ at least one transformer every time you run a
Dart app, you may never need to _write_ a transformer, in which case
you can stop reading now.

Before reading further, read
[Pub Assets and Transformers](/tools/pub/assets-and-transformers)
to familiarize yourself with assets, transformers, and how they
relate to each other.

You can write different kinds of transformers depending on the
type of work you need to perform. A basic Pub transformer processes
a single input asset. If you need to process multiple inputs with no single
primary input&ndash;you want to combine several images into one image,
for example&ndash;you can write an _aggregate_ transformer.
For more information, see
[Writing an Aggregate Tranformer](aggregate).

This page uses two examples, SimpleTransformer and
MarkdownConverter, which you can find through
[Examples of Transformer Code](examples).

## Implementing a transformer {#implementing-transformer}

A transformer is a Dart class that extends the Transformer class
from the [barback](https://pub.dartlang.org/packages/barback) package.
Barback, developed by the Dart team and available at pub.dartlang.org,
provides a system for building assets.

### Choose a file name and location {#choose}

A transformer's code goes into one of the following locations:

* For a package that only implements a transformer, you can put
  the code into `<package>.dart` in the `lib` directory.
  This is what you want in most situations.

* For a larger project where you want the transformer's code to be in a
  library under `lib/src`, you can put the transformer code into
  `lib/src/` and add the export statement for the library to
  `lib/<package>.dart`.

* If the transformer can't coexist with the main package code,
  you can put the code into a file named `transformer.dart`. For
  example, let's say your client app depends on `dart:html` but the
  transformer depends on `dart:io` because it makes an HTTP request.
  In this case, put the code into `transformer.dart`, under
  `lib` or `lib/src`, depending on your package.

* You can also put your transformer code into another file,
  such as `lib/stuff/myfile.dart`.

The transformer's file name and location affect how you set
up the pubspec.  See [Add the transformer](#add-transformer)
for more details.

### Get barback {#get-barback}

In your transformer's main Dart file, import the barback package:

{% prettify dart %}
import 'package:barback/barback.dart';
{% endprettify %}

In your package's `pubspec.yaml` file, add a dependency
on the barback package:

{% prettify yaml %}
dependencies:
  barback: ^0.15.2
{% endprettify %}

### Extend `Transformer` {#extend-transformer}

In the file with your transformer subclass,
extend the `Transformer` class from the barback package:

{% prettify dart %}
class MyTransformer extends Transformer { ... }
{% endprettify %}

### Define `asPlugin` {#define-asPlugin}

The `asPlugin` constructor can be empty, but it must be present,
and it must be named `asPlugin`.
Its presence is how pub determines that you want this class
to be publicly available as a loadable transformer plugin.

{% prettify dart %}
MyTransformer.asPlugin();
{% endprettify %}

You can also define a single-argument `asPlugin(BarbackSettings)` constructor
that you can use to pass information to the transformer.

For example, say you want a transformer to execute when your app is deployed,
but not during the development process, when you are debugging.
You can achieve this by using the `mode` option.
The `mode` value defaults to "debug" for `pub serve` and "release"
for `pub build`, but the value can be configured to use any string
for either command.

The following code shows how this might look:

{% prettify dart %}
class InsertCopyright extends Transformer {
  final BarbackSettings _settings;

  InsertCopyright.asPlugin(this._settings);

  Future apply(Transform transform) {
    // Skip the transform in debug mode.
    if (_settings.mode.name == 'debug') return;

    // Apply the transform.
    // ...
  }
}
{% endprettify %}

For more information on the mode option, see
[pub serve]({{site.webdev}}/tools/pub/pub-serve#options) and
[pub build]({{site.webdev}}/tools/pub/pub-build#options).

### Claim input assets {#claim-input-assets}

A transformer can limit which assets that it processes. It can
do this in one of two ways:

* Implement `allowedExtensions` to return a
  space-separated list of file extensions. The following
  code, from [markdown_converter](examples),
  limits input assets to those
  files with one of three Markdown file extensions:

{% prettify dart %}
String get allowedExtensions => ".md .markdown .mdown";
{% endprettify %}

* Override `isPrimary()`. The following code
  limits input assets to those from a top-level directory
  named `sources`:

{% prettify dart %}
Future<bool> isPrimary(AssetId id) {
  return new Future.value(id.path.startsWith('sources/');
}
{% endprettify %}

Note that defining `allowedExtensions` is shorthand for defining an
`isPrimary` method that only checks the extension of the asset ID's path.
If you need to perform any other checks, you must explicitly define
`isPrimary()`.

If you don't override either `allowedExtensions` or `isPrimary()`,
then the transformer gets the opportunity to process all assets.

### Process input assets {#process-input-assets}

To process assets, implement the `apply()` method.
In this method, you read each asset from the passed-in transform,
manipulate it, and write out the new asset.

<aside class="alert alert-warning" markdown="1">
**Note:**
Read assets _only_ from the transform. Do not read assets directly
from the file system, as that will cause problems if your
transformer is used in a series of transformers.
</aside>

<aside class="alert alert-info" markdown="1">
**Specifying where to put assets:**
A transformer accepts one or more assets and outputs zero or more assets.
(A linter or a filter might not produce an output asset.)

An Asset is identified by an AssetId. The Asset class provides
several constructors that you can use to create an output asset:

* fromBytes(AssetId, List)
* fromFile(AssetId, File)
* fromPath(AssetId, String)
* fromStream(AssetId, Stream)
* fromString(AssetId, String)
</aside>

The following example, from SimpleTransformer, inserts a
copyright string at the beginning of the input asset:

{% prettify dart %}
String copyright =
  "Copyright (c) 2014, the Example project authors.\n";

Future apply(Transform transform) async {
  var content = await transform.primaryInput.readAsString();
  var id = transform.primaryInput.id;
  var newContent = copyright + content;
  transform.addOutput(new Asset.fromString(id, newContent));
}
{% endprettify %}

### Produce output assets {#produce-output-assets}

To write data to an output asset, use Transformer's
`addOutput()` method.

The previous example writes data to a new output asset like this:

{% prettify dart %}
var id = transform.primaryInput.id;
...
transform.addOutput(new Asset.fromString(id, newContent));
{% endprettify %}

That code creates a new asset with the same name and file extension as
the input asset. For example, if the input asset is `test.txt`, the output
asset is `test.txt`.

You can create an output with any name or file extension. The only
restriction is that the output asset must end up in the same package
as the primary input.

You can construct an AssetId directly:

{% prettify dart %}
new AssetId("package", "some/path.ext");
{% endprettify %}

To create an output with a different file extension than the input,
or with a new file extension, use one of the following AssetId methods:

* `changeExtension()`
* `addExtension()`

The MarkdownConverter example converts Markdown to HTML and replaces the
original file extension with `.html`, as follows:

{% prettify dart %}
var id = transform.primaryInput.id.changeExtension(".html");

String newContent = ...;
transform.addOutput(new Asset.fromString(id, newContent));
{% endprettify %}

## Configuring pubspec {#configuring-pubspec}

Add the transformer and the barback dependency
to the `pubspec.yaml` file.

### Add the transformer {#add-transformer}

To apply a transformer to the assets in your package,
list it in your pubspec.
If your transformer is implemented in `lib/<package>.dart` or
`lib/transformer.dart`, add the following to your pubspec:

{% prettify yaml %}
transformers:
- <pkgname>
{% endprettify %}

SimpleTransformer's package name (as specified in the pubspec)
is `simple_transformer`, so here's the pubspec entry that
specifies running SimpleTransformer's transformer:

{% prettify yaml %}
transformers:
- simple_transformer
{% endprettify %}

If you put your transformer class into a file other than
`<package>.dart` or `transformer.dart`&mdash;for example,
`lib/stuff/insert_copyright.dart`&mdash;you add it to the
pubspec file like this:

{% prettify yaml %}
transformers:
- simple_transformer/stuff/insert_copyright
{% endprettify %}

### Depend on barback {#depend-on-barback}

You also need to add barback as a dependency in your package's
pubspec, as described in [get barback](#get-barback).

## Running the transformer {#running-transformer}

Assets can be in any directory in the package. However, if you want an
asset to be publicly available to another package,
it must be in the `lib` directory.
You can organize the assets underneath `lib`
using any structure that you want. See
[Where to put assets](/tools/pub/assets-and-transformers#where-to-put-assets)
and
[How to refer to assets](/tools/pub/assets-and-transformers#how-to-refer-to-assets)
for specifics.

The `pub build`, `pub serve`, and `pub run` commands automatically run
transformers. For more information, see
[How transformers work](/tools/pub/assets-and-transformers#how-transformers-work).

## More information {#more-info}

* [Writing an Aggregate Transformer](aggregate)
: How to write a transformer that combines multiple input assets
  into a single output.
* [Writing a Lazy Transformer](lazy-transformer)
: How to write a transformer that processes lazily, in the background.
* [Examples of Transformer Code](examples)
: Examples to get you started.
* [barback library](https://pub.dartlang.org/packages/barback)
: API docs for the barback package.
* [Barback - Can We Build It? Yes, We Can!](https://docs.google.com/a/google.com/document/d/1juHkCRg-1YH6LvwhGPHgF2ihX-UQtR1fv-8aknO7t_4/edit?pli=1#)
: A description of the barback asset system, written by a
  member of the Dart engineering team.

