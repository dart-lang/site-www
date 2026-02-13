---
title: "Screenshots and automated publishing for pub.dev"
description: "We have a couple of new features available on pub.dev starting today: You can now declare screenshots for a package, enabling a more visual…"
publishDate: 2023-01-18
author: "jonasfj"
image: images/169KfhhHmmvZ6BLvypXjx2A.png
category: other
tags:
  - dartlang
  - github-actions
  - pubdev
  - package
  - package-management
---


We have a couple of new features available on pub.dev starting today: You can now declare screenshots for a package, enabling a more visual approach to search. And the publishing flow can now be fully automated, powered by GitHub Actions.

## Adding screenshots to pub.dev

One of the core objectives of pub.dev is to make it easy to find the right package for a given purpose. When you search for widgets or other visual components, images play an important role. We are now showing screenshots in package search results, to make it easier than ever to find a package.

### Screenshots in package search and on the package page

Thumbnails of screenshots now appear in the search results and you can also filter the search to only list packages with screenshots.

<DashImage src="images/1B2bqbwEtObMoGQTm8B-FVQ.png" />


The screenshot thumbnail is also shown on the package page, and clicking the thumbnail triggers an image carousel with all the screenshots.

<DashImage src="images/169KfhhHmmvZ6BLvypXjx2A.png" />


### Declaring screenshots in `pubspec.yaml`

Adding screenshots to a package is really simple. Declare the files in `pubspec.yaml` under the `screenshots` field with a `description` and a `path`. Below is an example from the `animations` package.

```yaml
name: animations
...
screenshots:
 - description: 'Examples of the container transform pattern.'
   path: example/screenshots/container_transform_lineup.webp
 - description: 'Examples of the fade pattern.'
   path: example/screenshots/fade_lineup.webp
   ...
```


For more details see [dart.dev/tools/pub/pubspec#screenshots](https://dart.dev/tools/pub/pubspec#screenshots).

## Automated publishing for pub.dev

Thousands of Dart community members publish packages on pub.dev, for the benefit of all Dart and Flutter developers. Traditionally, these package publishers have published to pub.dev by running a local terminal command, `dart pub publish`, and authenticating with their Google account. Behind the scenes a *refresh token* was stored in a configuration file on their development machine, which enabled them to publish a new version without authenticating again. This flow is simple and easy to understand, but requires a number of manual steps. We’re happy to introduce a new automated publishing flow, that enables publishing new pub.dev versions directly from a GitHub Action. This has several benefits:

* Each release is automatically tagged with consistent release tags in GitHub

* It’s easy to configure a review and approval flow for publishing new versions.

* The publishing process is authenticated by a token signed by GitHub, ensuring no credentials have to be stored on disk.

<DashImage src="images/1dqxBy1vvLW108xdpqLLZ5Q.png" />


### Making automated publishing secure

Currently, some users have resorted to storing the `pub-credentials.json` configuration file containing the *refresh token* in a secret environment variable on GitHub Actions. This way, they could write a GitHub Action workflow that recovered the configuration file and used it to publish a new version of the package. While this flow technically works, the tooling wasn’t designed with this in mind and the flow has multiple downsides:

* The `pub-credentials.json` files can be used to publish any package the author has permission to publish, not just the one package published from the configured flow.

* If leaked, the `pub-credentials.json` can be used to publish new versions and new packages, impersonating the user who created the `pub-credentials.json` file.

* The [UI for revoking](https://myaccount.google.com/permissions) the *refresh token* in `pub-credentials.json` is not easy to find.

Indeed, it has happened more than once that a package was published and it accidentally included the author’s `pub-credentials.json` file, because the author extracted the file inside a CI job. Publishing a package along with the credentials required to update the package is a pretty severe security vulnerability and we eventually [implemented leak detection](https://dart.dev/go/false-secrets) in `dart pub publish`.

Our new automated publishing support mitigates these issues, making it possible to authenticate to pub.dev using one of the following:

* A temporary [OIDC token signed by Github Actions](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect).

* A GCP service account that can be used from most GCP resources like Google Cloud Build or other cloud environments, such as Azure or AWS.

These flows enable automated publishing relying on long-lived secret tokens that can easily be abused, if leaked by accident. If deploying your publishing flow to a custom machine, you can, of course, rely on exported service account keys, but great care must be taken to properly secure such keys.

### Enabling secure publishing

You can enable automated publishing from GitHub with just a few steps — see [dart.dev/go/automated-publishing](http://dart.dev/go/automated-publishing) for all the details.