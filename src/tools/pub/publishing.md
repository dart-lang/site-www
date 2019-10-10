---
title: Publishing packages
description: Learn how to publish a Dart package to the pub.dev site.
---

[The pub package manager](/guides/packages) isn't just for using other people's packages.
It also allows you to share your packages with the world. If you have a useful
project and you want others to be able to use it, use the `pub publish`
command.

<aside class="alert alert-info" markdown="1">
**Note:**
To publish to a location other than the pub.dev site,
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

* Your package should depend only on hosted dependencies (from the default pub
  package server) and SDK dependencies (`sdk: flutter`). These restrictions
  ensure that dependencies of your packages cannot become unavailable in the
  future.

* You must have a [Google Account,][Google Account]
  which pub uses to manage package upload permissions.
  Your Google Account can be associated with a Gmail address or
  with any other email address.

[Google Account]: https://support.google.com/accounts/answer/27441

Be aware that the email address associated with your Google account is
displayed on the [pub.dev site]({{site.pub}}) along with any
packages you upload.

### Important files

Pub uses the contents of a few files to create a page for your
package at `pub.dev/packages/<your_package>`. Here are the files that
affect how your package's page looks:

* **README**: The README file (`README`, `README.md`, `README.mdown`,
  `README.markdown`) is the main content featured in your package's page.
* **CHANGELOG**: Your package's CHANGELOG (`CHANGELOG`, `CHANGELOG.md`,
  `CHANGELOG.mdown`, `CHANGELOG.markdown`), if found, will also be featured in a
  tab on your package's page, so that developers can read it right from
  the pub.dev site.
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
[pub.dev site]({{site.pub}}). Pub will also show you all of
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
[pub.dev site]({{site.pub}}), any pub user will be able to
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

## Publishing prereleases

As you work on a package, consider publishing it as a prerelease.
Prereleases can be useful when any of the following are true:

* You're actively developing the next major version of the package.
* You want beta testers for the next release candidate of the package.
* The package depends on an unstable version of the Dart or Flutter SDK.

As described in [semantic versioning][semver], to make a prerelease of a version,
you append a suffix to the version. For example, to make a prerelease of
version `2.0.0` you might use the version `2.0.0-dev.1`. Later, when you
release version `2.0.0`, it will take precedence over all `2.0.0-XXX` prereleases.

Because pub prefers stable releases when available, users of a prerelease package
might need to change their dependency constraints.
For example, if a user wants to test prereleases of version 2.1, then
instead of `^2.0.0` or `^2.1.0` they might specify `^2.1.0-dev.1`.

<aside class="alert alert-info" markdown="1">
  **Note:**
  If a stable package in the dependency graph depends on a prerelease,
  then pub chooses that prerelease instead of a stable release.
</aside>

When a prerelease is published to [pub.dev](https://pub.dev),
the package page displays links to both the prerelease and the stable release.
The prerelease doesn't affect the analysis score, show up in search results,
or replace the package README and documentation. 

[semver]: https://semver.org/spec/v2.0.0-rc.1.html

## Publishing is forever

Keep in mind that publishing is forever. As soon as you publish your package,
users will be able to depend on it. Once they start doing that, removing
the package would break theirs. To avoid that, pub strongly discourages
deleting packages. You can always upload new versions of your package, but
old ones will continue to be available for users that aren't ready to
upgrade yet.

## Marking packages as discontinued {#discontinue}

Although packages always remain published, it can be useful to signal to
developers that a package is no longer being actively maintained.
For this, you can mark a package as **discontinued**.
A discontinued package remains published and viewable on pub.dev,
but it has a clear `DISCONTINUED` badge and
doesn't appear in pub.dev search results.

To mark a package as discontinued, sign in to pub.dev using a Google Account
that's an uploader or verified publisher admin for the package.
Then use the **Admin** tab of the individual package to mark the package as
discontinued.

## Resources

For more information, see the reference pages for:

* [`pub publish`](/tools/pub/cmd/pub-lish)
* [`pub uploader`](/tools/pub/cmd/pub-uploader)
