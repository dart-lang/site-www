---
title: Publishing packages
description: Learn how to publish a Dart package to pub.dev.
---

[The pub package manager][pub] isn't just for using other people's packages.
It also allows you to share your packages with the world. If you have a useful
project and you want others to be able to use it, use the `pub publish`
command.

{{site.alert.note}}
  To publish to a location other than pub.dev,
  or to prevent publication anywhere, use the `publish_to` field,
  as defined in the [pubspec][].
{{site.alert.end}}

## Publishing is forever

Keep in mind that publishing is forever. As soon as you publish your package,
users can depend on it. Once they start doing that, removing
the package would break theirs. To avoid that, the [pub.dev policy][policy]
disallows unpublishing packages except for very few cases.

You can always upload new versions of your package, but
old ones will continue to be available for users that aren't ready to
upgrade yet.

For already published packages that are no longer relevant or being maintained,
you can [mark them as discontinued](#discontinue).

## Preparing to publish

When publishing a package, it's important to follow the [pubspec
format][pubspec] and
[package layout conventions][].
Some of these are required in order for others to be able to use your package.
Others are suggestions to help make it easier for users to understand and work
with your package. In both cases, pub tries to help you by pointing out what
changes will help make your package play nicer with the Dart ecosystem. There
are a few additional requirements for uploading a package:

* You must include a license file (named `LICENSE`, `COPYING`, or some
  variation) that contains an [open-source license.][open-source license]
  We recommend the [BSD license,][BSD license]
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

{{site.alert.note}}
  Unless you publish using a [verified publisher][],
  **pub.dev displays the email address associated with your Google Account.**
{{site.alert.end}}

### Important files

Pub uses the contents of a few files to create a page for your
package at `pub.dev/packages/<your_package>`. Here are the files that
affect how your package's page looks:

* **README**: The README file (`README`, `README.md`, `README.mdown`,
  `README.markdown`) is the main content featured in your package's page.
* **CHANGELOG**: Your package's CHANGELOG (`CHANGELOG`, `CHANGELOG.md`,
  `CHANGELOG.mdown`, `CHANGELOG.markdown`), if found, is also featured in a
  tab on your package's page, so that developers can read it right from
  pub.dev.
* **The pubspec**: Your package's `pubspec.yaml` file is used to fill out
  details about your package on the right side of your package's page, like its
  description, homepage, etc.


### Advantages of using a verified publisher {#verified-publisher}

You can publish packages using either a verified publisher (recommended)
or an independent Google Account.
Using a verified publisher has the following advantages:

* The consumers of your package know that the publisher domain has been verified.
* You can avoid having pub.dev display your personal email address.
  Instead, pub.dev displays displays the publisher domain and contact address.
* A verified publisher badge {% asset verified-publisher.svg
  alt="pub.dev verified publisher logo" %} is displayed next to your package name
  on both search pages and individual package pages.


### Creating a verified publisher {#create-verified-publisher}

To create a verified publisher, follow these steps:

1. Go to [pub.dev.]({{site.pub}})

1. Log in to pub.dev using a Google Account.

1. In the user menu in the top-right corner, select **Create Publisher**.

1. Enter the domain name that you want to associate with your publisher (for example,
   `dart.dev`), and click **Create Publisher**.

1. In the confirmation dialog, select **OK**.

1. If prompted, complete the verification flow, which opens the [Google
   Search Console.](https://search.google.com/search-console/about)
   * When adding DNS records, it may take a few hours before the Search Console
   reflects the changes.
   * When the verification flow is complete, return to step 4.


## Publishing your package

Use the [pub publish][] command to publish your package for the first time,
or to update it to a new version.


### Performing a dry run

To test how `pub publish` will work, you can perform a dry run:

```terminal
$ pub publish --dry-run
```

Pub makes sure that your package follows the
[pubspec format][pubspec] and
[package layout conventions][],
and then uploads your package to [pub.dev.]({{site.pub}}) Pub also shows you all of
the files it intends to publish. Here's an example of publishing a package
named `transmogrify`:

{:.console-output}
```nocode
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
```

### Publishing

When you're ready to publish your package, remove the `--dry-run` argument:

```terminal
$ pub publish
```

{{site.alert.note}}
  The `pub` command currently doesn't support publishing a new package directly to a
  verified publisher. As a temporary workaround, publish new packages to a Google Account,
  and then [transfer the package to a publisher](#transferring-a-package-to-a-verified-publisher).

  Once a package has been transferred to a publisher,
  you can update the package using `pub publish`.
{{site.alert.end}}

After your package has been successfully uploaded to pub.dev, any pub user can
download it or depend on it in their projects. For example, if you just
published version 1.0.0 of your `transmogrify` package, then another Dart
developer can add it as a dependency in their `pubspec.yaml`:

```yaml
dependencies:
  transmogrify: ^1.0.0
```

### Transferring a package to a verified publisher

To transfer a package to a verified publisher,
you must be an [uploader](#uploaders) for the package
and an admin for the verified publisher.

{{site.alert.note}}
  This process isn't reversible. Once you transfer a package to a publisher,
  you can't transfer it back to an individual account.
{{site.alert.end}}

Here's how to transfer a package to a verified publisher:

1. Log in to [pub.dev]({{site.pub}}) with a Google Account that's listed as
   an uploader of the package.
1. Go to the package details page (for example,
   `{{site.pub-pkg}}/http`).
1. Select the **Admin** tab.
1. Enter the name of the publisher, and click **Transfer to Publisher**.


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

## Uploaders

Whoever publishes the first version of a package automatically becomes
the first and only person authorized to upload additional versions of that package.
To allow or disallow other people to upload versions,
use the [pub uploader][] command
or transfer the package to a [verified publisher][].

If a package has a verified publisher,
then the pub.dev page for that package displays the publisher domain.
Otherwise, the page displays the email addresses of
the authorized uploaders for the package.


## Publishing prereleases

As you work on a package, consider publishing it as a prerelease.
Prereleases can be useful when any of the following are true:

* You're actively developing the next major version of the package.
* You want beta testers for the next release candidate of the package.
* The package depends on an unstable version of the Dart or Flutter SDK.

As described in [semantic versioning,][semver] to make a prerelease of a version
you append a suffix to the version. For example, to make a prerelease of
version `2.0.0` you might use the version `2.0.0-dev.1`. Later, when you
release version `2.0.0`, it will take precedence over all `2.0.0-XXX` prereleases.

Because pub prefers stable releases when available, users of a prerelease package
might need to change their dependency constraints.
For example, if a user wants to test prereleases of version 2.1, then
instead of `^2.0.0` or `^2.1.0` they might specify `^2.1.0-dev.1`.

{{site.alert.note}}
  If a stable package in the dependency graph depends on a prerelease,
  then pub chooses that prerelease instead of a stable release.
{{site.alert.end}}

When a prerelease is published to pub.dev,
the package page displays links to both the prerelease and the stable release.
The prerelease doesn't affect the analysis score, show up in search results,
or replace the package README and documentation.


## Marking packages as discontinued {#discontinue}

Although packages always remain published, it can be useful to signal to
developers that a package is no longer being actively maintained.
For this, you can mark a package as **discontinued**.
A discontinued package remains published and viewable on pub.dev,
but it has a clear **DISCONTINUED** badge and
doesn't appear in pub.dev search results.

To mark a package as discontinued, sign in to pub.dev using a Google Account
that's an uploader or verified publisher admin for the package.
Then use the **Admin** tab of the individual package to mark the package as
discontinued.

## Resources

For more information, see the reference pages for the following `pub` commands:

* [pub publish][]
* [pub uploader][]

[BSD license]: https://opensource.org/licenses/BSD-3-Clause
[Google Account]: https://support.google.com/accounts/answer/27441
[open-source license]: https://opensource.org/
[package layout conventions]: /tools/pub/package-layout
[policy]: https://pub.dev/policy
[pub]: /guides/packages
[pub publish]: /tools/pub/cmd/pub-lish
[pub uploader]: /tools/pub/cmd/pub-uploader
[pubspec]: /tools/pub/pubspec
[semver]: https://semver.org/spec/v2.0.0-rc.1.html
[verified publisher]: /tools/pub/verified-publishers

