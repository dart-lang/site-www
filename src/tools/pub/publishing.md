---
title: Publishing packages
description: Learn how to publish a Dart package to the Pub site.
---

[The pub package manager](/guides/packages) isn't just for using other people's packages.
It also allows you to share your packages with the world. If you have a useful
project and you want others to be able to use it, use the `pub publish`
command.

<aside class="alert alert-info" markdown="1">
**Note:**
To publish to a location other than the Pub site,
or to prevent publication anywhere, use the `publish_to` field,
as defined in the [pubspec](/tools/pub/pubspec).
</aside>

## Preparing to publish

When publishing a package, it's important to follow the [pubspec
format](/tools/pub/pubspec) and
[package layout conventions](/tools/pub/package-layout).
Some of these are required in order for others to be able to use your package.
Others are suggestions to help make it easier for users to understand and work
with your package. In both cases, pub tries to help you by pointing out what
changes will help make your package play nicer with the Dart ecosystem. There
are a few additional requirements for uploading a package:

* You must include a license file (named `LICENSE`, `COPYING`, or some
  variation) that contains an [open-source license](http://opensource.org/). We
  recommend the [BSD license](http://opensource.org/licenses/BSD-2-Clause),
  which is used by Dart itself. You must also have the legal right to
  redistribute anything that you upload as part of your package.

* Your package must be less than 10 MB large after gzip compression. If
  it's too large, consider splitting it into multiple packages, or cutting down
  on the number of included resources or examples.

* Your package should only have hosted dependencies. Git dependencies are
  allowed but strongly discouraged; not everyone using Dart has Git installed,
  and Git dependencies don't support version resolution as well as hosted
  dependencies do.

Be aware that the email address associated with your Google account is
displayed on the [Pub site]({{site.pub}}) along with any
packages you upload.

### Important files

Pub uses the contents of a few files to create a page for your
package at `<package site>/packages/<your_package>`. Here are the files that
affect how your package's page looks:

* **README**: The README file (`README`, `README.md`, `README.mdown`,
  `README.markdown`) is the main content featured in your package's page.
* **CHANGELOG**: Your package's CHANGELOG (`CHANGELOG`, `CHANGELOG.md`,
  `CHANGELOG.mdown`, `CHANGELOG.markdown`), if found, will also be featured in a
  tab on your package's page, so that developers can read it right from
  the Pub site.
* **The pubspec**: Your package's `pubspec.yaml` file is used to fill out
  details about your package on the right side of your package's page, like its
  description, authors, etc.

## Publishing your package

For your first time around, you can perform a dry run:

{% prettify none %}
$ pub publish --dry-run
{% endprettify %}

Pub will check to make sure that your package follows the
[pubspec format](/tools/pub/pubspec) and
[package layout conventions](/tools/pub/package-layout),
and then upload your package to the
[Pub site]({{site.pub}}). Pub will also show you all of
the files it intends to publish. Here's an example of publishing a package
named `transmogrify`:

{% prettify none %}
Publishing transmogrify 1.0.0
    .gitignore
    CHANGELOG.md
    README.md
    lib
        transmogrify.dart
        src
            transmogrifier.dart
            transmogrification.dart
    pubspec.yaml
    test
        transmogrify_test.dart

Package has 0 warnings.
{% endprettify %}

When you're ready to publish your package, remove the `--dry-run` argument:

{% prettify none %}
$ pub publish
{% endprettify %}

After your package has been successfully uploaded to
[Pub site]({{site.pub}}), any pub user will be able to
download it or depend on it in their projects. For example, if you just
published version 1.0.0 of your `transmogrify` package, then another Dart
developer can add it as a dependency in their `pubspec.yaml`:

{% prettify yaml %}
dependencies:
  transmogrify: ^1.0.0
{% endprettify %}

## What files are published?

**All files** in your package are included in the published package, with
the following exceptions:

* Any `packages` directories.
* Your package's [lockfile](/tools/pub/glossary#lockfile).
* If you aren't using Git, all _hidden_ files (that is,
  files whose names begin with `.`).
* If you're using Git, any files ignored by your `.gitignore` file.

{% comment %}
PENDING: Here only to make it easy to find the packages discussion: packages-dir.html
{% endcomment %}

Be sure to delete any files you don't want to include (or add them to
`.gitignore`). `pub publish` lists all files that it's going to publish
before uploading your package,
so examine the list carefully before completing your upload.

## Authors versus uploaders

The package authors as listed in the `pubspec.yaml` file
are different from the list of people authorized to publish that package.
Whoever publishes the first version of some package automatically becomes
the first and only person authorized to upload additional versions of the package.
To allow or disallow other people to upload versions,
use the [`pub uploader`](cmd/pub-uploader) command.

## Publishing is forever

Keep in mind that publishing is forever. As soon as you publish your package,
users will be able to depend on it. Once they start doing that, removing
the package would break theirs. To avoid that, pub strongly discourages
deleting packages. You can always upload new versions of your package, but
old ones will continue to be available for users that aren't ready to
upgrade yet.

## Resources

For more information, see the reference pages for:

* [`pub publish`](/tools/pub/cmd/pub-lish)
* [`pub uploader`](/tools/pub/cmd/pub-uploader)
