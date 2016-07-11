---
layout: default
permalink: /tools/pub/assets-and-transformers
title: "Assets and Transformers"
description: "How pub transforms and generates assets and files during development and build time."
---

The [`pub serve`]({{site.webdev}}/tools/pub/pub-serve),
[`pub build`]({{site.webdev}}/tools/pub/pub-build),
and [`pub run`](cmd/pub-run) commands use [transformers][]
to prepare a package's [assets][] before serving the app,
building the app for deployment, or executing the command-line app,
as the case may be.

Use the `pubspec.yaml` file to specify which transformers your package uses
and, if necessary, to configure the transformers. (See
[Specifying transformers](#specifying-transformers) for details.) For example:

{% prettify yaml %}
name: myapp
dependencies:
  [[highlight]]polymer: ^0.16.3
transformers:
- polymer:[[/highlight]]
    [[highlight]]entry_points:[[/highlight]]
    [[highlight]]- web/index.html[[/highlight]]
    [[highlight]]- web/index2.html[[/highlight]]
{% endprettify %}

A package's assets can be in any directory in the root package.
However, if you want to make an asset available publicly (to other
packages, or to multiple directories within your package), it needs
to be in `lib`.

After transformation by `pub build`, assets are
available somewhere under build. For example, consider the
following directory structure:

{% prettify none %}
myapp/
  example/
    foo/
      bar.txt
{% endprettify %}

When you build this example (`pub build example`), you end up with
`build/example/foo/bar.txt`.

Assets generated from files in a package's `lib` directory appear
under a directory named <code>packages/<em>&lt;pkg_name&gt;</em></code>.
For details, see
[Where to put assets](#where-to-put-assets) and
[How to refer to assets](#how-to-refer-to-assets).

## How transformers work {#how-transformers-work}

Here are some examples of transformers:

* The dart2js transformer, which reads in all of the `.dart` files for a
  program and compiles them to a single `.js` file.
* The polymer transformer, which converts HTML and Dart files into
  optimized HTML and Dart files.
* A linter that reads in files and produces warnings but no actual file.

Although you specify which transformers to use, you don't explicitly say
which transformers should be applied to which assets. Instead, each
transformer determines which assets it can apply itself to. For `pub serve`,
the transformers run when the dev server starts up and whenever a source
asset changes. The `pub build` and `pub run` commands run the transformers
once and then exit.

As the following figure shows, source assets can pass through, untransformed,
and become generated assets. Or a source asset can be transformed, such as a
`.dart` file (along with the `.dart` files that it refers to) that is
compiled to `.js`.

{% img 'tools/assets-and-transformers.png' %}

Dart files are a special case. The `pub build` command doesn't produce `.dart`
files because browsers in the wild don't support Dart natively. The `pub
serve` command, on the other hand, does generate `.dart` assets, because
you can use Dartium while you're developing your app.

## Specifying transformers  {#specifying-transformers}

To tell pub to apply a transformer to your package's assets, specify the
transformer, as well as the package that contains the transformer, in your
package's `pubspec.yaml` file. In the following pubspec, the highlighted lines
specify that this package requires the polymer transformer, which is in the
polymer package (along with the rest of polymer.dart):

{% prettify yaml %}
name: myapp
dependencies:
  [[highlight]]polymer: ^0.16.3[[/highlight]]
[[highlight]]transformers:
- polymer:[[/highlight]]
    [[highlight]]entry_points: web/index.html[[/highlight]]
{% endprettify %}

The following example configures the
[dart2js]({{site.webdev}}/tools/dart2js) transformer,
which is used by [`pub serve`]({{site.webdev}}/tools/pub/pub-serve),
[`pub build`]({{site.webdev}}/tools/pub/pub-build),
and [`pub run`](cmd/pub-run), to analyze the code:

{% prettify yaml %}
transformers:
- $dart2js:
  analyzeAll: true
{% endprettify %}

For more information, see
[Configuring the Built-in dart2js
Transformer]({{site.webdev}}/tools/pub/dart2js-transformer).

We expect more transformers to be available in the future. You can specify
multiple transformers, to run either in parallel (if they're independent of
each other) or in separate phases. To specify that transformers run in
parallel, use [<code><em>transformer_1</em>, ...,
<em>transformer_n</em></code>]. If order matters, put the transformers on
separate lines.

For example, consider three transformers, specified as follows:

{% prettify yaml %}
transformers:
- [t1, t2]
- t3
{% endprettify %}

The `t1` and `t2` transformers run first, in parallel. The `t3` transformer
runs in a separate phase, after `t1` and `t2` are finished, and can see the
outputs of `t1` and `t2`.

Pub build implicitly appends a transformer that converts your Dart code to
JavaScript, so your code can run in any modern browser.

## Where to put assets  {#where-to-put-assets}

An asset can be in any root-level directory of your package. However,
assets located under the `lib` directory have additional visibilty:

* Assets that other packages depend on need to be in `lib`.

* Assets in your package that you want to access from other directories
  within your package need to be in your package's `lib` directory.

* Assets in `lib/src` are invisible to other packages.

<aside class="alert alert-info" markdown="1">
In earlier releases, assets were also placed in the top-level
`asset` directory. Pub no longer recognizes the `asset` directory.
</aside>

The following picture shows how you might structure your app's source assets,
with your main Dart file under `web` and additional Dart files under `lib`.

{% prettify none %}
app/
  lib/
    *.dart
    *.png
    *.html
    ...
  packages/
    pck/
      lib/
        *.dart
        *.js
  web/
    app.dart
    *.html
    *.css
    *.png
    ...
{% endprettify %}

After transformation, `pub build` places generated assets under a directory
named `build`. Underneath `build`, pub creates a directory of the same
name as the root directory containing the source files. For example,
for a web app (where the source files are in `/web`),
pub creates a `build/web` directory.

<aside class="alert alert-info" markdown="1">
**Note**:
By default, `pub build` assumes that you are building a web app.
If you type `pub build` (with no arguments) but the package doesn't
include a `web` directory, pub produces an error.

You can build a command-line app (where the source files are in `bin`),
for example, by specifying `pub build bin`.
For more information, see [pub build]({{site.webdev}}/tools/pub/pub-build).
</aside>

The following is an example of a build command for a more complex package
layout:

{% prettify sh %}
$ pub build test example/one example/two
{% endprettify %}

The resulting build directory looks like:

{% prettify none %}
build/
  example/
    one/
      packages/
    two/
      packages/
  test/
    packages/
{% endprettify %}

The dev server simulates this hierarchy without generating files.

## How to refer to assets

Here's how source asset locations correlate to generated asset locations,
for untransformed files:

<table border="1" cellpadding="2">
  <thead>
    <tr>
      <th valign="center">Source asset location</th>
      <th valign="center">Generated asset location<br>
                          (under <code>build</code>)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td> <code>.../<em>&lt;your_pkg></em>/web/<em>&lt;path></em></code> </td>
      <td> <code>/web/<em>&lt;path></em></code> </td>
    </tr>
    <tr>
      <td><code>.../<em>&lt;your_pkg></em>/lib/<em>&lt;path></em></code></td>
      <td><code>/packages/<em>&lt;pkg_name></em>/<em>&lt;path></em></code></td>
    </tr>
  </tbody>
</table>
<p></p>

For example, consider a helloworld app's HTML file, which is in the
helloworld directory at `web/helloworld.html`. Running `pub build` produces a
copy at `build/web/helloworld.html`. In the dev server,
you can get the HTML file contents by using the URL
`http://localhost:8080/helloworld.html`.

Or, perhaps you are compiling the source for a my_game web app that includes
a drawing library in the `lib/draw` directory.
If you build the `web` directory,
the result is `build/web/packages/my_game/draw/...`.

Transformers might change any part of <em>&lt;path&gt;</em>, especially the
filename, but they can't change the directory structure above
<em>&lt;path&gt;</em>.

[assets]: glossary#asset
[transformers]: glossary#transformer

## How to control which assets are processed {#exclude-assets}

You can use `$exclude` to tell a transformer _not_ to process one
or more assets. You can use `$include` to tell a transformer
to process _only_ one or more assets. You
can use glob syntax to make it easier to include, or exclude,
a group of assets, including entire directories.

### Excluding assets {#excluding-assets}

If you have an asset that you do not want a transformer to process,
you can exclude it, by name, in the pubspec. For example, a transformer
named `simple_transformer` operates on HTML files,
but you do not want it to process your `lib/README.html` file.
You can exclude it by using the `$exclude` tag. The following example
tells pub to run the transformer on everything it would normally
process _except_ for lib/foo.html:

{% prettify yaml %}
transformers:
- simple_transformer:
    $exclude: "lib/foo.html"
{% endprettify %}

You must provide the file's location from the top of the package.

<aside class="alert alert-info" markdown="1">
**Note**:
To pass a value to the transformer,
put a colon (`:`) after the transformer's name.
Indent the next line by 4 spaces and use the form:

        <parameter>: <value>
</aside>

### Processing specific assets {#specified-assets}

If you want a transformer to run _only_ on a particular file, you can
use `$include`. The following example tells pub to run the transformer
only on lib/foo.html, assuming that foo.html is a file type that it
would operate on under normal conditions:

{% prettify yaml %}
transformers:
- simple_transformer:
    $include: "lib/foo.html"
{% endprettify %}

You can't use the include tag to force a transformer to operate on a
file type that it would not otherwise process.

### Using glob syntax {#glob-syntax}

You can specify a list of files for the include or exclude tags:

{% prettify yaml %}
$exclude: ["lib/foo.html", "lib/bar.html"]
{% endprettify %}

Or you can use _glob_ syntax to specify a group of files.

For example, you can instruct the transformer to process any file that
ends with `.txt`, across all directories in the package, using `**.txt`:

{% prettify yaml %}
transformers:
- my_transformer:
    $include: **.txt
{% endprettify %}

You can also specify an entire directory for inclusion or exclusion.
For example, you can instruct the transformer to ignore any files in
the `lib/untransformed` directory like this:

{% prettify yaml %}
transformers:
- my_transformer:
    $exclude: lib/untransformed
{% endprettify %}

For more information on how to use glob syntax,
see the [glob](https://pub.dartlang.org/packages/glob) package.

If you publish a package that uses the glob syntax, be aware that
earlier versions of pub will not understand. To ensure that a
compatible version of pub is used, add an SDK contraint to your pubspec:

{% prettify yaml %}
environment:
    sdk: ">=1.8.0 <2.0.0"
{% endprettify %}

## How to configure assets {#configure-assets}

You can use include and exclude to make a transformer,
such as dart2js, treat certain assets in a special way.

For example, say that your project includes a Dart file that
was written by another programmer who wasn't as careful as you are
about cleaning up compiler warnings. You want to suppress the
warnings from the dart2js compiler _for this particular file_
when running `pub build` or `pub serve`.
The offending code is in the `lib/lax_code.dart` file.
You can disable the warnings only on that file by using
the following:

{% prettify yaml %}
transformers:
- $dart2js:
    suppressWarnings: true
    $include: "lib/lax_code.dart"
- $dart2js:
    suppressWarnings: false
    $exclude: "lib/lax_code.dart"
{% endprettify %}

This suppresses warnings when processing lib/lax_code.dart, but
allows warnings when compiling all other Dart files.

<aside class="alert alert-info" markdown="1">
**Note**:
To pass a value to the transformer,
put a colon (`:`) after the transformer's name.
Indent the next line by 4 spaces and use the form:

        <parameter>: <value>
</aside>

## Writing a transformer {#writing-transformer}

To write a transformer, see
[Writing a Pub Transformer](transformers/).
