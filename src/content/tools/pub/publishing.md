---
title: Publishing packages
description: Learn how to publish a Dart package to pub.dev.
---

[The pub package manager][pub] isn't just for using other people's packages.
It also allows you to share your packages with the world. If you have a useful
project and you want others to be able to use it, use the `dart pub publish`
command.

:::note
To publish to a location other than pub.dev,
or to prevent publication anywhere, use the `publish_to` field,
as defined in the [pubspec][].
:::

Watch the following video for an overview of building and publishing packages.

<iframe
  {{yt.std-size}}
  src="{{yt.embed}}/8V_TLiWszK0"
  title="Learn how to build and publish Dart packages"
  {{yt.set}}>
</iframe>

## Remember: Publishing is forever

Keep in mind that a published package lasts forever.
As soon as you publish your package, users can depend on it.
Once they start depending on it, removing the package would break theirs.
To avoid that, the [pub.dev policy][policy]
disallows unpublishing packages except for very few cases.

You can always upload new versions of your package,
but old ones remain available for users that can't upgrade yet.

For published packages that have lost relevance or lack maintainance,
[mark them as discontinued](#discontinue).

## Prepare your package for publication

When publishing a package, follow the conventions found in the
[pubspec format][pubspec] and [package layout][pkg-layout] structure.
To simplify using your package, Dart requires these conventions.
These conventions contain some exceptions noted on the linked guides.
When invoked, `pub` points out what changes you can make so your package
works better within the Dart ecosystem.

Beyond these conventions, you must follow these requirements:

* Include a `LICENSE` file in your package.
  We recommend the [BSD 3-clause license][],
  which the Dart and Flutter teams typically use.
  However, you can use any license appropriate for your package.

* Verify that you have the legal right to redistribute anything that
  you upload as part of your package.

* Keep package size to less than 100 MB after gzip compression.
  If it's too large, consider splitting it into multiple packages,
  using a `.pubignore` file to remove unnecessary content,
  or cutting down on the number of included resources or examples.

* Have your package depend only on hosted dependencies
  from the default pub package server and SDK dependencies
  (`sdk: flutter`).
  These restrictions ensure that dependencies of your packages
  can be found and accessed in the future.

* Own a [Google Account][]. Pub uses a Google account to manage package
  upload permissions. Your Google Account can be associated with
  a Gmail address or any other email address.

### Populate your pub.dev web page

Pub uses the contents of a few files to create a page for your
package at `pub.dev/packages/<your_package>`.
The following files affect the contents of your package's web page.

**`README.md`**
  : This file contains the main content featured in
  your package's web page.
  The file's contents should be marked up using [Markdown][].
  To learn how to write a great README, see
  [Writing package pages](/tools/pub/writing-package-pages).

**`CHANGELOG.md`**
  : If found, this file populates its own tab on your package's web page.
  Developers can read your changes right from pub.dev.
  The file's contents should be marked up using [Markdown][].

**`pubspec.yaml`**
  : This file populates details about your package
  on the right side of your package's web page.
  The file's contents should follow YAML conventions.
  These details include description, homepage, and the like.

### Advantages of using a verified publisher {:#verified-publisher}

You can publish packages using either a verified publisher (recommended)
or an independent Google Account.
Using a verified publisher has the following advantages:

* The consumers of your package know that the publisher domain has been verified.
* You can avoid having pub.dev display your personal email address.
  Instead, pub.dev displays the publisher domain and contact address.
* The pub.dev site displays a verified publisher badge
  <img src="/assets/img/verified-publisher.svg" width="20" height="20" alt="pub.dev verified publisher logo">
  next to your package name on search pages and individual package pages.

### Create a verified publisher {:#create-verified-publisher}

To create a [verified publisher][create-verified-publisher], follow these steps:

1. Go to [pub.dev]({{site.pub}}).

1. Log in to pub.dev using a Google Account.

1. From the user menu in the top-right corner, select **Create Publisher**.

1. Enter the domain name that you want to associate with your publisher
   (for example, `dart.dev`).

1. Click **Create Publisher**.

1. In the confirmation dialog, select **OK**.

1. If prompted, complete the verification flow.
   This opens the [Google Search Console][google-search].

   * When adding DNS records,
     a few hours might pass before the Search Console reflects the changes.
   * When the verification flow is complete, return to step 4.

:::tip
We strongly recommend you invite other members of your
organization to be members of the verified publisher.
This helps ensure that your organization retains access to
the publisher when you are not available.
:::

## Publish your package

Use the [`dart pub publish`][] command to publish your package
for the first time or to update it to a new version.

### What files are published?

The published package includes **all files** under the package root directory,
with the following exceptions:

* Any _hidden_ files or directories.
  These have names that begin with dot (`.`).
* Files and directories listed to be ignored in a
  `.pubignore` or `.gitignore` file

To use different ignore rules for `git` and `dart pub publish`,
create a `.pubignore` file to overrule the
`.gitignore` file in a given directory.
If a directory contains both a `.pubignore` file and a `.gitignore` file,
then  `dart pub publish` _ignores_ that directory's `.gitignore` file.
The `.pubignore` files follow the same format as the
[`.gitignore` file][git-ignore-format].

To avoid publishing unwanted files, follow these practices:

* Delete any files that you don't want to include or add them
  to a `.pubignore`  or `.gitignore` file.
* When uploading your package,
  examine the list of files that
  `dart pub publish --dry-run` shows it will publish.
  Cancel the upload if any undesired files appear in that list.

:::note
Most packages don't need a  `.pubignore` file.
To learn more about useful scenarios for this,
consult this [StackOverflow answer][pubignore-when].
:::

### Test publishing your package

To test how `dart pub publish` will work, you can perform a dry run:

```console
$ dart pub publish --dry-run
```

With this command, `dart pub` performs the following tasks:

1. Verifies that your package follows the [pubspec format][pubspec] and
   [package layout conventions][pkg-layout].

1. Shows all of the files it intends to publish.

The following example shows the publishing a package named `transmogrify`:

```plaintext
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

### Publish to pub.dev

To publish your package when it's ready, remove the `--dry-run` argument:

```console
$ dart pub publish
```

With this command, `dart pub` performs the following tasks:

1. Verifies that your package follows the [pubspec format][pubspec] and
   [package layout conventions][pkg-layout].

1. Shows all of the files it intends to publish.

1. Uploads your package to [pub.dev]({{site.pub}}).

:::note
The pub command doesn't support direct publishing a new package to a
verified publisher. As a temporary workaround, publish new packages to a Google Account,
and then [transfer the package to a publisher](#transferring-a-package-to-a-verified-publisher).

Once a package has been transferred to a publisher,
you can update the package using `dart pub publish`.
:::

After your package succeeded in uploading to pub.dev, any pub user can
download it or depend on it in their projects.

For example, if you just published version 1.0.0 of your `transmogrify` package,
then another Dart developer can add it as a dependency in their `pubspec.yaml`:

```yaml
dependencies:
  transmogrify: ^1.0.0
```

### Detect supported platforms

The [pub.dev site]({{site.pub}}) detects which platforms a package supports,
displaying these platforms on the package page.
Users of pub.dev can filter searches by platform.

To change the generated list of supported platforms,
[specify supported platforms][] in the `pubspec.yaml` file.

[specify supported platforms]: /tools/pub/pubspec#platforms

### Automate publishing

Once you have published the first version of a package,
you can configure automated publishing
through GitHub Actions or Google Cloud service accounts.
To learn more about automated publishing, consult
[Automated publishing of packages to pub.dev](/tools/pub/automated-publishing).

### Publish prerelease versions {:#publishing-prereleases}

As you work on a package, consider publishing it as a prerelease.
Prereleases can be useful when:

* You're actively developing the next major version of the package.
* You want beta testers for the next release candidate of the package.
* The package depends on an unstable version of the Dart or Flutter SDK.

As described in [semantic versioning][semver],
to make a prerelease of a version, append a suffix to the version.
For example, to make a prerelease of version `2.0.0`,
you might use the version `2.0.0-dev.1`.
Later, when you release version `2.0.0`, it takes precedence over all
`2.0.0-XXX` prereleases.

As pub prefers stable releases when available, users of a prerelease package
might need to change their dependency constraints.
For example, if a user wants to test prereleases of version `2.1.0`, then
instead of `^2.0.0` or `^2.1.0` they might specify `^2.1.0-dev.1`.

:::note
While `pub` prefers stable releases the same way it prefers newer versions,
the version solver does not attempt all solutions and may pick a prerelease,
even when a resolution that doesn't use prereleases exists.
Though this rarely happens in practice.
:::

When you publish a prerelease to pub.dev,
the package page displays links to both the prerelease and the stable release.
The prerelease doesn't affect the analysis score, show up in search results,
or replace the package `README.md` and documentation.

### Publish preview versions

Previews can be useful when _all_ of the following are true:

* The next stable version of the package is complete.
* That package version depends on an API or feature in the Dart SDK that
  hasn't yet been released in a stable version of the Dart SDK.
* You know that the API or feature that the package depends on is
  API-stable and won't change before it reaches the stable SDK.

As an example, consider a new version of `package:args` that has
a finished version `2.0.0`.
It depends on a feature in Dart `3.0.0-417.1.beta`.
However, the stable version of Dart SDK `3.0.0` hasn't been released.
The `pubspec.yaml` file might look like this:

```yaml title="pubspec.yaml"
name: args
version: 2.0.0

environment:
  sdk: '^3.0.0-417.1.beta'
```

When you publish this package to pub.dev, it's tagged as a preview version.
The following screenshot illustrates this.
It lists the stable version as `1.6.0` and the preview version as `2.0.0`.

![Illustration of a preview version](/assets/img/tools/pub/preview-version.png){:width="600px"}<br>

When Dart releases the stable version of `3.0.0`,
pub.dev updates the package listing to display
`2.0.0` as the latest (stable) version of the package.

If all of the conditions at the beginning of this section are true,
ignore the following warning from `dart pub publish`:

   _"Packages with an SDK constraint on a pre-release of the Dart SDK should
   themselves be published as a pre-release version. If this package needs Dart
   version 3.0.0-0, consider publishing the package as a pre-release
   instead."_

## Manage publishing permissions

### Locate the package publisher

If a package has a verified publisher,
the pub.dev page for that package displays the publisher domain.

For packages published without a publisher,
pub.dev doesn't disclose the publisher for privacy reasons.
The **Publisher** field displays "unverified uploader".

### Manage package uploaders {:#uploaders}

Whoever publishes the first version of a package becomes
the first and _only_ person authorized to upload additional
versions of that package.

To allow or disallow other people to upload versions, either:

* Manage authorized uploaders on the admin page for the package:
  `https://pub.dev/packages/<package>/admin`.
* Transfer the package to a [verified publisher][];
  all members of a publisher are authorized to upload.

:::tip
Invite other members of your team to become uploaders of the package.
This ensures that your team can access to the package when you aren't available.
:::

### Transfer a package to a verified publisher {:#transferring-a-package-to-a-verified-publisher}

To transfer a package to a verified publisher,
you must be an [uploader](#uploaders) for the package
and an admin for the verified publisher.

:::important
_You can't reverse this process._ Once you transfer a package to a publisher,
you can't transfer it back to an individual account.
:::

To transfer a package to a verified publisher:

1. Log in to [pub.dev]({{site.pub}}) with a Google Account that's listed as
   an uploader of the package.

1. Go to the package details page (for example,
   `{{site.pub-pkg}}/http`).

1. Select the **Admin** tab.

1. Enter the name of the publisher, and click **Transfer to Publisher**.

## Manage your package

### Retract a package version {:#retract}

To prevent new package consumers from adopting a published version
of your package within a seven-day window,
you can retract that package version within seven days of publication.
The retracted version can be restored again within seven days of retraction.

_Retraction isn't deletion._
A retracted package version appears in the version listing
of the package on pub.dev in the **Retracted versions** section.
The detailed view of that package version displays a **RETRACTED** badge.

Before retracting a package, consider publishing a new version instead.
Retracting a package can have a negative impact on package users.

If you publish a new version with either
a _missing dependency constraint_
or a _lax dependency constraint_,
then retracting the package version might be the only solution.
Publishing a newer version of your package won't stop the version
solver from picking the old version.
That version might be the only version pub can choose.
Retracting a package version with incorrect dependency constraints
forces users to either upgrade other dependencies or get a dependency conflict.

However, if your package contains a minor bug,
you might not need to retract the version.
Publish a newer version with the bug fixed and a
description of the fixed bug in `CHANGELOG.md`.
This helps users to understand what happened.
Publishing a newer version is less disruptive to package users.

:::version-note
Package retraction was introduced in Dart 2.15.
In pre-2.15 SDKs, the pub version solver ignores the retracted status.
:::

#### How to use a retracted version of a package

If a package depends on a package version that later is retracted,
it can still use that version as long as that version is in
the dependent package's `pubspec.lock` file.
To depend on a specific version that's already retracted,
the dependent package must pin the version in the
`dependency_overrides` section of the `pubspec.yaml` file.

#### How to migrate away from a retracted package version

When a package depends on a retracted package version,
you have choices in how you migrate away from this version depending
on other available versions.

#### Upgrade to a newer version

In most cases a newer version has been published to
replace the retracted version.
In this case run `dart pub upgrade <package>`.

#### Downgrade to the newest non-retracted version

If no newer version is available, consider downgrading
to the newest non-retracted version.
You can do this in one of two ways.

1. Use [pub tool](/tools/pub/cmd) commands:

   1. Run `dart pub downgrade <package>` to
      get the lowest version  of the specified package that
      matches the constraints in the `pubspec.yaml` file.

   1. Run `dart pub upgrade <package>` to get the
      newest compatible and non-retracted version available.

1. Edit the `pubspec.lock` file in your preferred IDE:

   1. Delete the entire package entry for the package
      with the retracted version.

   1. Run `dart pub get` to get the
      newest compatible and non-retracted version available.

Though you could delete the `pubspec.lock` file and run `dart pub get`,
this is not recommended.
It might result in version changes for other dependencies.

#### Upgrade or downgrade to a version outside the specified version constraint

If there is no alternative version available that satisfies the
current version constraint, edit the version constraint
in the `pubspec.yaml` file and run `dart pub upgrade`.

#### How to retract or restore a package version

To retract or restore a package version,
first sign in to pub.dev using a Google Account
that's either an uploader or a [verified publisher][] admin for the package.
Then go to the package's **Admin** tab,
where you can retract or restore recent package versions.

### Discontinue a package {:#discontinue}

Although packages remain published, you can signal to
developers that a package receives no active maintenance.
This requires you to mark the package as **discontinued**.

Once you discontinue a package, the package will:

* Remain published on pub.dev.
* Remain viewable on pub.dev.
* Display a clear **DISCONTINUED** badge.
* Not appear in pub.dev search results.

To mark a package as discontinued:

1. Sign in to pub.dev using a Google Account with uploader or
   [verified publisher][]permissions for the package.

1. Navigate to the package's **Admin** tab.

1. To discontinue a package, select **Mark "discontinued"**.

You can also recommend a replacement package.

1. In the field under **Suggested replacement**,
   type the name of another package.

1. Click **Update "Suggested Replacement"**.

If you change your mind, you can remove the discontinued mark at any time.

[create-verified-publisher]: {{site.pub}}/create-publisher
[BSD 3-clause license]: https://opensource.org/licenses/BSD-3-Clause
[Google Account]: https://support.google.com/accounts/answer/27441
[Markdown]: {{site.pub-pkg}}/markdown
[pkg-layout]: /tools/pub/package-layout
[policy]: {{site.pub}}/policy
[pub]: /guides/packages
[`dart pub publish`]: /tools/pub/cmd/pub-lish
[pubspec]: /tools/pub/pubspec
[semver]: https://semver.org/spec/v2.0.0-rc.1.html
[verified publisher]: /tools/pub/verified-publishers
[git-ignore-format]: https://git-scm.com/docs/gitignore#_pattern_format
[pubignore-when]: https://stackoverflow.com/a/69767697
[google-search]: https://search.google.com/search-console/about
