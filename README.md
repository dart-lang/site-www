# <img src="https://github.com/dart-lang/site-shared/blob/master/src/_assets/image/dart/logo/64.png" alt="Dart" width="28" height="28"/> The Dart language site (dart.dev)

[![Build Status SVG][]][Repo on GitHub Actions]
[![first-timers SVG][]][first-timers]

The https://dart.dev site, built with [Jekyll][] and hosted on [Firebase][].

[We welcome contributions](CONTRIBUTING.md), and we're
[first-timer friendly][first-timers]!

## Getting started
Start by looking for an [issue](https://github.com/dart-lang/site-www/issues)
that catches your interest, or create an issue with your proposed change.
Ask for the issue to be assigned to you.

To update this site, fork the repo, make your changes, and generate a pull
request. For simple changes (such as to CSS and text), you probably don't need
to build this site. Often you can make changes using the GitHub UI.

> **NOTE:** If you clone this repo locally, see the instructions below on cloning
> with its submodule.

If your change involves code samples, adds/removes pages, or affects
navigation, you'll need to build and test your work before submitting.

If you want or need to build, follow the steps below.

> **Help us improve these instructions!**
> If you have any problems getting set up to build or performing the
> actual build, please
> [edit this README](https://github.com/dart-lang/site-www/edit/master/README.md)
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
  On Windows the easiest way to install Make is `choco install make`. 
  Other options include using a [subsystem](https://docs.microsoft.com/en-us/windows/wsl/install-win10). 
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

If you're outside of the Dart organization, we recommend you **create a fork** of this repo under your own account, and then submit a PR from that fork. 

Once you have a fork (or you're a Dart org member), 
_choose one_ of the following submodule-cloning techniques:

- Clone the repo and its submodule at the same using the `--recurse-submodules` option:
  ```bash
  $ git clone --recurse-submodules https://github.com/dart-lang/site-www.git
  ```

  *OR*
  
- If you've already cloned the repo without its submodule, then run this command from the repo root:
  ```bash
  $ git submodule update --init --recursive
  ```

> **Note:** At any time during development 
> you can use the `git submodule` command to refresh submodules:
> ```bash
> $ git pull; git submodule update --init --recursive
> ```


## Setting up your local environment and serve changes

1. _Optional:_ After cloning the repo and its submodules, 
   create a branch for your changes:
   ```bash
   $ git checkout -b <BRANCH_NAME>
   ```
   
1. If the Docker Desktop application isn't already running on your machine, 
   start it. Look for the Docker status icon: if it has an exclamation 
   point (`!`), then update Docker Desktop before proceeding.

1. Run the initial local setup command:
   ```bash
   $ make setup
   ```

1. Serve the site locally (via `docker-compose`):
   ```bash
   $ make up
   ```
   The site is generated, and then the development server runs in the 
   Docker container, with the generated `_site` directory visible locally as a mirrored volume from inside the container.

1. View your changes in the browser by navigating to `http://localhost:4000`.
   > **Note:** Unless you're editing files under `site-shared`, 
   > you can safely ignore `ERROR: directory is already being watched` messages. 
   > For details, see [#1363](https://github.com/flutter/website/issues/1363).

1. Make your changes to the local repo. 

   The site will rebuild and the browser will autoreload to reflect the changes. 

   > **Tip:** If you aren't seeing the changes you expect (e.g. src/_data), 
   > `ctrl-C` out of your running dev server and rebuild the site from scratch 
   > using the following commands:
   > ```bash
   > $ make down && make clean && make up
   > ```


1. Commit your changes to the branch and submit your PR.
   > See [Pre-push site checks](#pre-push-site-checks)

1. When you've finished developing, shut down the Docker container:
   ```bash
   $ make down
   ```
   
> **Tip:** To find additional commands, read the [Makefile][]. 
> For example, if you need to debug the Docker setup, 
> you can run:
> ```bash
> $ make run
> ```


## Pre-push site checks

### Checking documentation and example code
If you've made changes to this site's documentation and/or example code, and committed locally, then run the following command before pushing your work:

```bash
# Enter a running Docker container shell
make run

# Check/validate example code
tool/test.sh

# Check links for 404 errors
tool/check-links.sh
```

If these scripts report errors or warnings, then address those issues and rerun the above commands. Otherwise, you can push your changes.


## Deploying to a staging site
You can deploy your local edits to a personal Firebase hosting staging site as follows.

1. If you don't already have a Firebase project, 
   
   - Navigate to the [Firebase Console](https://console.firebase.google.com) 
   and create your own Firebase project (for example, `dart-dev-staging`).

   - Head back to your local repo shell and verify that you are logged in.
      ```bash
      $ firebase login
      ```

   - Ensure that your project exists and activate that project:
      ```bash
      $ firebase projects:list
      $ firebase use <your-project>
      ```
   
1. Build the site via Docker:
   ```bash
   $ make build
   ```

   This will build the site and copy it to your local `_site` directory. 
   If that directory previously existed, it will be replaced. 

1. Deploy to your activated Firebase project's default hosting site:
   ```bash
   $ firebase deploy
   ```

1. Navigate to your PR on GitHub and update it with the location of 
  the staged version, the names of your reviewers, and so on.



[Build Status SVG]: https://github.com/dart-lang/site-www/workflows/build/badge.svg
[cloning]: https://help.github.com/articles/cloning-a-repository
[Firebase]: https://firebase.google.com/
[first-timers SVG]: https://img.shields.io/badge/first--timers--only-friendly-blue.svg?style=flat-square
[first-timers]: https://www.firsttimersonly.com/
[forking]: https://docs.github.com/en/get-started/quickstart/fork-a-repo
[Jekyll]: https://jekyllrb.com
[Makefile]: (https://github.com/dart-lang/site-www/blob/master/Makefile)
[Repo on GitHub Actions]: https://github.com/dart-lang/site-www/actions?query=workflow%3Abuild+branch%3Amaster
[site-www]: https://github.com/dart-lang/site-www
[Troubleshooting wiki page]: https://github.com/dart-lang/site-www/wiki/Troubleshooting
