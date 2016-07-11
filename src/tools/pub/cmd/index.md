---
layout: default
permalink: /tools/pub/cmd/
title: "Pub Commands"
description: "Pub, a package and asset management tool for Dart, supports a variety of commands."
---

Aside from managing packages, [pub](/tools/pub/) also has support for
building web and command line apps.

If your web app's directory structure follows pub's [package layout
conventions](/tools/pub/package-layout), you can use the pub
development server (<code class="literal">pub serve</code>) to continuously
build and serve the app's assets. Once you're ready to deploy the web app,
use <code class="literal">pub build</code> to generate the final files.

Quick links to the `pub` commands:

* [`pub build`]({{site.webdev}}/tools/pub/pub-build)
* [`pub cache`](pub-cache)
* [`pub deps`](pub-deps)
* [`pub downgrade`](pub-downgrade)
* [`pub get`](pub-get)
* [`pub global`](pub-global)
* [`pub publish`](pub-lish)
* [`pub run`](pub-run)
* [`pub serve`]({{site.webdev}}/tools/pub/pub-serve)
* [`pub upgrade`](pub-upgrade)
* [`pub uploader`](pub-uploader)

<aside class="alert alert-info" markdown="1">
*Problems?*
See [Troubleshooting Pub](../troubleshoot).
</aside>

Pub's commands fall into the following categories:

## App creation and maintenance

Pub provides a number of commands that support
the creation and maintenance of a Dart application.

* The [`pub cache`](pub-cache) command works with your system cache.
  You can add new packages to your cache,
  or perform a clean reinstall of all packages in your cache.

* The [`pub deps`](pub-deps) command lists all of the dependencies
  used by a package.

* The [`pub downgrade`](pub-downgrade) command retrieves the lowest
  versions of all the packages that are listed as dependencies
  used by the application. This is useful for testing the lower range
  of your package's dependencies.

* The [`pub get`](pub-get) command retrieves the packages that are
  listed as the dependencies for the application.

* The [`pub upgrade`](pub-upgrade) command retrieves the latest
  versions of all the packages that are listed as dependencies
  used by the application.

## Development

Pub supports development for web-based apps and command-line apps.

### Web-based apps

During the development cycle of an application, the
[`pub serve`]({{site.webdev}}/tools/pub/pub-serve)
command is used to start up a development server.
This server can be accessed via the browser on localhost and
allows you to view your web-based app.

IDEs such as WebStorm also use `pub serve` to serve all of the
Dart scripts and assets (HTML, images, CSS) to Dartium.

### Command-line apps

There are two commands that you can use to run Dart scripts
from the command line. Each command first runs any needed
transformers before invoking the specified script.

* The [`pub run`](pub-run) command invokes a Dart script in your
  package, or in one of its dependencies.

* The [`pub global`](pub-global) command lets you work with globally
  available packages that can be run when you are not currently inside
  a package.

## Deployment

When you are ready to deploy your app, the
[`pub build`]({{site.webdev}}/tools/pub/pub-build) command
creates the `build` directory, compiles the Dart code, and places
the assets into the build directory.

## Publication

If you want to share your Dart packages with the world, you can
use the [`pub publish`](pub-lish) command to upload your package to
[pub.dartlang.org](https://pub.dartlang.org). The
[`pub uploader`](pub-uploader) command enables specific users
to modify and upload new versions of your package.

---

## Global options {#global-options}

Several command-line options work with all of the pub commands.
These include:

`--help` or `-h`
: Print usage information.

`--version`
: Print version of pub.

`--trace`
: Print debugging information when an error occurs.

`--verbosity=<level>`
: The specified level determines the amount of information that is displayed:

* `all`
: Show all output, including internal tracing messages.

* `io`
: Show I/O operations.

* `normal`
: Show errors, warnings, and user messages.

* `solver`
: Show steps during version resolution.

`-verbose` or `-v`
: Equivalent to `--verbosity=all`.
