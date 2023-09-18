# <img src="https://github.com/dart-lang/site-shared/blob/main/src/_assets/image/dart/logo/64.png" alt="Dart" width="28" height="28"/> The Dart language site (dart.dev)

[![Build Status SVG][]][Repo on GitHub Actions]
[![OpenSSF Scorecard SVG][]][Scorecard Results]
[![first-timers SVG][]][first-timers]

The https://dart.dev site, built with [Jekyll][] and hosted on [Firebase][].

[We welcome contributions](CONTRIBUTING.md),
and we're [first-timer friendly][first-timers]!

## Getting started

Start by looking for an [issue](https://github.com/dart-lang/site-www/issues)
that catches your interest, or create an issue with your proposed change.
Ask for the issue to be assigned to you.

To update this site, fork the repo, make your changes, and generate a pull
request. For simple changes (such as to CSS and text), you probably don't need
to build this site. Often you can make changes using the GitHub UI.

> **NOTE:** If you clone this repo locally,
> see the instructions below on cloning with its submodule.

If your change involves code samples, adds/removes pages, or affects navigation,
you'll need to build and test your work before submitting.

If you want or need to build, follow the steps below.

> **Help us improve these instructions!**
> If you have any problems getting set up to build or performing the
> actual build, please
> [edit this README](https://github.com/dart-lang/site-www/edit/main/README.md)
> or [file an issue](https://github.com/dart-lang/site-www/issues/new?title=README%20issue)
> (or both).

## Before you build this site

For changes beyond simple text and CSS tweaks,
we recommend building the site.

### 1. Get the prerequisites

Install the following tools, if you don't have them already:

- **bash**, the Bourne shell.
  These instructions assume you're using `bash`,
  and setup might not work if you use another shell.

- **GNU Make**.
  On Windows the easiest way to install Make is `choco install make`
  using command prompt or powershell as an admin.
  Other options include using a [subsystem][wsl].

- **Docker**.
  We use Docker for local dev, tests, and building the site.
  Install it from https://docs.docker.com/get-docker/.

- **Firebase CLI**, for hosting the site locally.
  One way to get this is to run `npm install -g firebase-tools`.
  For full setup details,
  read the [Firebase CLI documentation](https://firebase.google.com/docs/cli).

### 2. Clone this repo _and_ its submodules

> **Note:** This repo has git _submodules_, which affects how you clone it.
> The GitHub documentation has general help on [forking][] and [cloning][] repos.

If you're not a member of the Dart organization,
we recommend you **create a fork** of this repo under your own account,
and then submit a PR from that fork.

Once you have a fork (or you're a Dart org member),
_choose one_ of the following submodule-cloning techniques:

- Clone the repo and its submodule at the same time
  using the `--recurse-submodules` option:

  ```terminal
  $ git clone --recurse-submodules https://github.com/dart-lang/site-www.git
  ```

  *OR*

- If you've already cloned the repo without its submodule,
  then run this command from the repo root:

  ```terminal
  $ git submodule update --init --recursive
  ```

> **Note:** At any time during development
> you can use the `git submodule` command to refresh submodules:
>
> ```terminal
> $ git pull; git submodule update --init --recursive
> ```

## Setting up your local environment and serve changes

1. _Optional:_ After cloning the repo and its submodules,
   create a branch for your changes:

   ```terminal
   $ git checkout -b <BRANCH_NAME>
   ```

2. If the Docker Desktop application isn't already running on your machine,
   start it. Look for the Docker status icon: if it has an exclamation
   point (`!`), then update Docker Desktop before proceeding.

3. Run the initial local setup command:

   ```terminal
   $ make setup
   ```

4. Serve the site locally (via `docker-compose`):

   ```terminal
   $ make up
   ```

   The site is generated, and then the development server runs in the
   Docker container, with the generated `_site` directory visible locally
   as a mirrored volume from inside the container.

5. View your changes in the browser by navigating to `http://localhost:4000`.
   > **Note:** Unless you're editing files under `site-shared`,
   > you can safely ignore `ERROR: directory is already being watched` messages.
   > For details, see [#1363](https://github.com/flutter/website/issues/1363).

6. Make your changes to the local repo.

   The site will rebuild and the browser will autoreload to reflect the changes.

   > **Tip:** If you aren't seeing the changes you expect (e.g. src/_data),
   > <kbd>Ctrl</kbd> + <kbd>C</kbd> out of your running dev server and rebuild the site from scratch
   > using the following commands:
   >
   > ```terminal
   > $ make down && make clean && make up
   > ```

7. Commit your changes to the branch and submit your PR.
   > See [Pre-push site checks](#pre-push-site-checks)

8. When you've finished developing, shut down the Docker container:

   ```terminal
   $ make down
   ```

> **Tip:** To find additional commands, read the [Makefile][].
> For example, if you need to debug the Docker setup,
> you can run:
>
> ```terminal
> $ make run
> ```

## Pre-push site checks

### Checking documentation and example code

If you've made changes to this site's documentation and/or example code,
and committed locally, then run the following command before pushing your work:

```terminal
# Enter a running Docker container shell
$ make run

# Check/validate example code
$ tool/test.sh

# Check links for 404 errors
$ tool/check-links.sh
```

If these scripts report errors or warnings,
then address those issues and rerun the above commands.
Otherwise, you can push your changes.

## Deploying to a staging site

You can deploy your local edits to a
personal Firebase hosting staging site as follows:

1. If you don't already have a Firebase project,

   - Navigate to the [Firebase Console](https://console.firebase.google.com)
     and create your own Firebase project (for example, `dart-dev-staging`).

   - Head back to your local repo shell and verify that you are logged in.

     ```terminal
     $ firebase login
     ```

   - Ensure that your project exists and activate that project:

     ```terminal
     $ firebase projects:list
     $ firebase use <your-project>
     ```

1. Build the site via Docker:

   ```terminal
   $ make build
   ```

   This will build the site and copy it to your local `_site` directory.
   If that directory previously existed, it will be replaced.

1. Deploy to your activated Firebase project's default hosting site:

   ```terminal
   $ FIREBASE_PROJECT=<your-project> make deploy
   ```

   > **TIP:** Add your `FIREBASE_PROJECT` env var to your `.env` file
   > and it will overwrite the default every time you deploy without specifying.

1. Navigate to your PR on GitHub and update it with the location of
  the staged version, the names of your reviewers, and so on.


## Creating and/or editing DartPad example code

Most of the code used to create [DartPad][] examples is hosted on GitHub.
However, this repo also contains some `*.dart` files
responsible for DartPad example code.

# Refresh DartPad HTML tooltips

Files that require DartPad HTML to be manually updated
include instructions at the top that specify running:

```terminal
$ dart run tool/dart_tools/bin/create_code_with_tooltips.dart
```

Follow the instructions in those files to refresh the appropriate code.

### DartPad picker

The DartPad example picker must be manually compiled if changes are made.
This will regenerate the associated JavaScript file in `src/assets/dash/js`:

```terminal
$ tool/compile.sh
```

## Dockerfile Maintenance

### Dart SDK and Node PPA Checksum values

Since the Dart SDK setup fetches remote files,
it's important to verify checksum values.
Both installs use `latest` and `lts` respectively,
so these files may be periodically updated.
When this happens,
local checksums may fail and **This will break the Docker/Compose setup/build**.
You will see the relevant output in your shell e.g. `DART CHECKSUM FAILED!...`.
When this happens, run the following command:

```terminal
$ make fetch-sums
```

This command will output the updated checksum values for Dart,
and that output will be formatted similar
or the same as what is currently in the Dockerfile.
Copy this output and replace the relevant install code in the Dockerfile,
then rerun your setup/build again.

[Build Status SVG]: https://github.com/dart-lang/site-www/workflows/build/badge.svg
[OpenSSF Scorecard SVG]: https://api.securityscorecards.dev/projects/github.com/dart-lang/site-www/badge
[Scorecard Results]: https://deps.dev/project/github/dart-lang%2Fsite-www
[cloning]: https://help.github.com/articles/cloning-a-repository
[DartPad]: https://dartpad.dev
[Firebase]: https://firebase.google.com/
[first-timers SVG]: https://img.shields.io/badge/first--timers--only-friendly-blue.svg?style=flat-square
[first-timers]: https://www.firsttimersonly.com/
[forking]: https://docs.github.com/en/get-started/quickstart/fork-a-repo
[Jekyll]: https://jekyllrb.com
[Makefile]: (https://github.com/dart-lang/site-www/blob/main/Makefile)
[Repo on GitHub Actions]: https://github.com/dart-lang/site-www/actions?query=workflow%3Abuild+branch%3Amain
[site-www]: https://github.com/dart-lang/site-www
[Troubleshooting wiki page]: https://github.com/dart-lang/site-www/wiki/Troubleshooting
[wsl]: https://docs.microsoft.com/en-us/windows/wsl/install
