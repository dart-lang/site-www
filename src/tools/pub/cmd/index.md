---
layout: default
permalink: /tools/pub/cmd
title: "Pub Commands"
description: "Pub, a package and asset management tool for Dart, supports a variety of commands."
---

The [pub tool](/tools/pub) has commands for managing packages,
running and serving apps, and building and deploying web apps.

Flutter has its own commands for managing and updating packages.
For more information, see
[Using Packages]({{site.flutter}}/using-packages/) and
[Upgrading Flutter]({{site.flutter}}/upgrading/)
on the [Flutter website.]({{site.flutter}})

Quick links to the `pub` commands:

* [`pub build`]({{site.webdev}}/tools/pub/pub-build)
* [`pub cache`](/tools/pub/cmd/pub-cache)
* [`pub deps`](/tools/pub/cmd/pub-deps)
* [`pub downgrade`](/tools/pub/cmd/pub-downgrade)
* [`pub get`](/tools/pub/cmd/pub-get)
* [`pub global`](/tools/pub/cmd/pub-global)
* [`pub publish`](/tools/pub/cmd/pub-lish)
* [`pub run`](/tools/pub/cmd/pub-run)
* [`pub serve`]({{site.webdev}}/tools/pub/pub-serve)
* [`pub upgrade`](/tools/pub/cmd/pub-upgrade)
* [`pub uploader`](/tools/pub/cmd/pub-uploader)

<aside class="alert alert-info" markdown="1">
*Problems?*
See [Troubleshooting Pub](/tools/pub/troubleshoot).
</aside>

Pub's commands fall into the following categories:

* [Managing package dependencies](#managing-apps)
* [Running and serving apps](#running-and-serving-apps)
* [Building
  and deploying apps and packages](#building-and-deploying-apps-and-packages)

<a id="managing-apps"></a>
## Managing package dependencies

Pub provides a number of commands for managing the
[packages your code depends on](/tools/pub/dependencies).

In this group, the most commonly used commands are `pub get` and
`pub upgrade`, which retrieve or upgrade dependencies used by a package.
Every time you modify a pubspec file, run `pub get`
to make sure the dependencies are up to date. Some IDEs
perform this step automatically on the creation of a project,
or any modification of the pubspec.

[`pub cache`](/tools/pub/cmd/pub-cache)
: Manages pub's local package cache. Use this command to add packages
  to your cache, or to perform a clean reinstall of all packages in
  your cache.

[`pub deps`](/tools/pub/cmd/pub-deps)
: Lists all dependencies used by the current package.

[`pub downgrade`](/tools/pub/cmd/pub-downgrade)
: Retrieves the lowest versions of all the packages that are
  listed as dependencies used by the current package. Used for testing
  the lower range of your package's dependencies.

[`pub get`](/tools/pub/cmd/pub-get)
: Retrieves the packages that are listed as the dependencies for
  the current package.
  If a `pubspec.lock` file already exists, fetches the version
  of each dependency (if possible) as listed in the lock file.
  Creates or updates the lock file, as needed.

[`pub upgrade`](/tools/pub/cmd/pub-upgrade)
: Retrieves the latest version of each package listed
  as dependencies used by the current package. If a `pubspec.lock`
  file exists, ignores the versions listed in the lock file and fetches
  the newest versions that honor the constraints in the pubspec.
  Creates or updates the lock file, as needed.


## Running and serving apps

Pub supports development for running web apps and command-line apps.

### Web apps

If your web app's directory structure follows pub's [package layout
conventions](/tools/pub/package-layout), you can use the pub development
server ([`pub serve`](({{site.webdev}}/tools/pub/pub-serve))) to continuously
build and serve the app's assets.
This server can be accessed via the browser on localhost and
allows you to view your web-based app.

IDEs such as WebStorm also use `pub serve` to serve all of the
Dart scripts and assets (HTML, images, CSS) to the browser.

### Command-line apps

There are two commands that you can use to run Dart scripts
from the command line. Each command first runs any needed
transformers before invoking the specified script.

* The [`pub run`](/tools/pub/cmd/pub-run) command invokes a Dart script in your
  package, or in one of its dependencies.

* The [`pub global`](/tools/pub/cmd/pub-global) command lets you work with
  globally available packages that can be run when you are not currently inside
  a package.

## Building and deploying apps and packages

With pub you can publish packages, build deployable web apps, and
deploy command-line apps.

{% include tools/transformers-going-away.md %}

### Sharing packages

To share your Dart packages with the world, you can
use the [`pub publish`](/tools/pub/cmd/pub-lish) command to upload the
package to [pub.dartlang.org](https://pub.dartlang.org). The
[`pub uploader`](/tools/pub/cmd/pub-uploader) command enables specific
users to modify and upload new versions of your package.

### Web apps

Once you're ready to deploy a web app,
use [`pub build`]({{site.webdev}}/tools/pub/pub-build)
to generate the final files. This command creates the `build` directory,
compiles the Dart code, and places all necessary files into the build
directory.

### Command-line apps

For any package that contains scripts (anything under the `bin/`
directory), consider adding the `executables` tag to the pubspec file.
When a script is listed under `executables`, users can run
[`pub global activate`](/tools/pub/cmd/pub-global#activating-a-package)
to make it directly available from the command line.

---

## Global options

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
