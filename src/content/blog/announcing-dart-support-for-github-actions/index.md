---
title: "Announcing Dart support for GitHub Actions"
description: "GitHub Actions is a popular offering for continuous integration (CI) for GitHub repos. Today, we’re announcing an official setup-dart…"
publishDate: 2021-03-24
author: mit-mit
image: images/15E8_aBC9TBl9oBUwN3jAJw.png
category: announcements
tags:
  - dart
  - continuous-integration
  - github-actions
layout: blog
---


[GitHub Actions](https://github.com/features/actions) is a popular offering for continuous integration (CI) for GitHub repos. Today, we’re announcing an official [**setup-dart** action](https://github.com/marketplace/actions/setup-dart-sdk) by the Dart team. This action supports downloading, installing, and configuring the Dart SDK, so you can run Dart build and test jobs with ease on GitHub Actions.

If you author a Dart package for pub.dev, we encourage you to enable CI testing with Github Actions for your repo, to give you (and package users) a signal about whether your package is healthy. CI jobs on GitHub Actions are [free for public repos](https://github.com/pricing).

<DashImage src="images/15E8_aBC9TBl9oBUwN3jAJw.png" />


## Introducing setup-dart

If you have a GitHub repository with a Dart app in it, you can enable CI testing with GitHub Actions and the setup-dart action with just a few clicks. Here we have a new GitHub repo called [myapp](https://github.com/mit-mit/myapp), which contains the starting point for a small application generated with the Dart tool [by running](https://dart.dev/tutorials/server/get-started#3-create-a-small-app)
`dart create --template console-full myapp`.

Next, open the GitHub web UI, and click the **Actions** tab:

<DashImage src="images/0IA24lXOJ0Zy1uwXF.png" />


Just below the the introduction, you should see a section suggesting a workflow for a Dart repository:

<DashImage src="images/0tz1_DLk4qI1MpI4z.png" />


Click the **Set up this workflow** button, and you’ll be taken to the GitHub UI for adding a new `.github/workflow/dart.yml` file. This is a YAML file that defines the GitHub Actions workflow to run in the repo. Let’s review each of the components suggested by the template [workflow](https://github.com/dart-lang/characters/blob/master/.github/workflows/test-package.yml) file.

First we define the name of the workflow, which will be shown in the Actions admin UI:

```
name: Dart
```


Next, we define when the workflow should be run (the [event](https://docs.github.com/en/actions/learn-github-actions/introduction-to-github-actions) that triggers the workflow). Here the flow is configured to run whenever there is a push to the main branch, or a PR for the main branch. I’ve personally found that when I’m having trouble getting a workflow to run, it’s often because I’ve misspelled the branch name.

```
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
```


Then follows a list of jobs, each with a name (here `test`). Each job has its own definition, consisting of a listing of where to run the job (this job runs on Ubuntu Linux) and what steps to take:

```
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
```


As for the specific test, first we check out the repository under `test`, and then we run the new setup-dart action. This downloads and installs the Dart SDK, and then adds the `dart` CLI and pub global directory to the path. Here we don’t specify which Dart SDK to install, so the action will install the most recent stable-channel SDK.

```
      - uses: actions/checkout@v2
      - uses: dart-lang/setup-dart@v1
```


We can then go ahead and perform our desired tests, like formatting, analysis, and unit tests:

```
      - name: Install dependencies
        run: dart pub get

      - name: Verify formatting
        run: dart format — output=none — set-exit-if-changed .

      - name: Analyze project source
        run: dart analyze

      - name: Run tests
        run: dart test
```


For a full example, see our [workflow for package:characters](https://github.com/dart-lang/characters/blob/master/.github/workflows/test-package.yml).

## Specifying SDK version

The setup-dart action supports specifying the version of Dart you wish to install. This can take one of two forms:

* A specific version, e.g. `2.9.0` or `2.12.0–259.12.beta`

* The latest version from a [release channel](https://dart.dev/get-dart#release-channels), e.g. `stable` or `beta`

To specify a version use the `sdk` argument, either directly or as part of a [test matrix](https://docs.github.com/en/actions/learn-github-actions/managing-complex-workflows#using-a-build-matrix):

```
matrix:
    os: [ubuntu-latest, macos-latest, windows-latest]
    sdk: [2.10.0, stable, beta]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v2
      - uses: dart-lang/setup-dart@v1.0
        with:
          sdk: ${{ matrix.sdk }}
```


The result of this matrix is nine separately run jobs:

<DashImage src="images/0Wm1ERed37w-oyoDq.png" />


Now that everything is passing, you might want to [add a status badge](https://docs.github.com/en/actions/managing-workflow-runs/adding-a-workflow-status-badge) to your `README.md` file to display the test status.

## Alternative solutions

GitHub Actions is one of several popular solutions for continuous integration. Others with support for the Dart SDK include [Travis](https://docs.travis-ci.com/user/languages/dart/), [AppVeyor](https://www.appveyor.com/), and [CodeShip](https://documentation.codeship.com/basic/languages-frameworks/dart/). For testing of [Flutter](https://flutter.dev/) apps, options include [Codemagic from Nevercode](https://developer.nevercode.io/docs/building-flutter-apps), [Cirrus CI](https://cirrus-ci.org/examples/#flutter), and [Bitrise](https://devcenter.bitrise.io/getting-started/getting-started-with-flutter-apps/). GitHub Actions for Flutter apps is enabled by community contributed actions, such as [flutter-action](https://github.com/marketplace/actions/flutter-action).

That’s it for now. We hope you enjoy [this new CI support for Dart](https://github.com/marketplace/actions/setup-dart-sdk), and if you have any feedback or issues with setup-dart, please let us know in [the issue tracker](https://github.com/dart-lang/setup-dart/issues).