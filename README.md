# <img src="https://github.com/dart-lang/site-shared/blob/main/src/_assets/image/dart/logo/64.png" alt="Dart" width="28" height="28"/> The Dart language site (dart.dev)

[![Build Status SVG][]][Repo on GitHub Actions]
[![OpenSSF Scorecard SVG][]][Scorecard Results]

The documentation site for the [Dart programming language](https://dart.dev), 
built with [Eleventy][] and hosted on [Firebase][].

We welcome contributions of all kinds!
To set up the site locally, follow the
below guidelines on [Building the site](#build-the-site).
To learn more about contributing to this repository,
check out the [Contributing guidelines](CONTRIBUTING.md).

## Getting started

Start by looking for an [issue](https://github.com/dart-lang/site-www/issues)
that catches your interest, or create an issue with your proposed change.
Consider adding a comment to let everyone know that you're working on it, and
feel free to ask any questions you have on the same issue.

To update this site, fork the repo, make your changes,
and generate a pull request.
For simple changes (such as style and typo fixes),
you probably don't need to build this site.
Often you can make changes using the GitHub UI.
We can stage the changes automatically in your pull request.

> [!IMPORTANT]  
> If you are cloning this repository locally,
> follow the below instruction on cloning with its submodule.

If your change involves code samples, adds/removes pages, or affects navigation,
do consider building and test your work before submitting.

If you want or need to build the site, follow the steps below.

## Build the site

For changes beyond simple text and CSS tweaks,
we recommend running the site locally to
enable an edit-refresh cycle. 

### Get the prerequisites

Install the following tools, if you don't have them already:

- **Dart**
  The latest stable release of Dart is required to build the site
  and run its tooling. This can be the Dart included in the Flutter SDK.
  If you don't have Dart or need to update, follow the
  instructions at [Get the Dart SDK][].

- **Node.js**
  The latest stable LTS release of Node.js is required to build the site.
  If you don't have Node.js or need to update, download your
  computer's corresponding version and follow the instructions
  from the [Node.js download archive][].

[Get the Dart SDK]: https://dart.dev/get-dart
[Node.js download archive]: https://nodejs.org/en/download/

### Clone this repo and its submodules

> [!NOTE]
> This repository has git _submodules_, which affects how you clone it.
> The GitHub documentation has general help on
> [forking][] and [cloning][] repos.

If you're not a member of the Dart organization,
we recommend you **create a fork** of this repo under your own account,
and then submit a PR from that fork.

Once you have a fork (or you're a Dart org member),
_choose one_ of the following submodule-cloning techniques:

- Clone the repo and its submodule at the same time
  using the `--recurse-submodules` option:

  ```terminal
  git clone --recurse-submodules https://github.com/dart-lang/site-www.git
  ```

  *OR*

- If you've already cloned the repo without its submodule,
  then run this command from the repo root:

  ```terminal
  git submodule update --init --recursive
  ```

> [!NOTE]
> At any time during development
> you can use the `git submodule` command to refresh submodules:
>
> ```terminal
> git pull && git submodule update --init --recursive
> ```

## Set up your local environment and serve changes

1. _Optional:_ After cloning the repo and its submodules,
   create a branch for your changes:

   ```terminal
   git checkout -b <BRANCH_NAME>
   ```

2. From the root directory of the repository,
   fetch the site's Dart dependencies.

   ```terminal
   dart pub get
   ```

3. From the root directory of the repository,
   enable `corepack` to set up `pnpm`, then
   fetch the site's npm dependencies.
   If you already have `pnpm` installed,
   you can skip the `corepack` commands.

   ```terminal
   corepack enable
   corepack install
   pnpm install
   ```

4. From the root directory, serve the site locally.

   ```terminal
   dart run dart_site serve
   ```

   This command generates and serves the site on a
   local port that's printed to your terminal.

5. View your changes in the browser by navigating to `http://localhost:4000`.

   The port might be different if `4000` is taken.
   If you need to view the generated fields,
   they can be found in the `_site` directory.

6. Make your changes to the local repo.

   The site should automatically rebuild on most changes, but if
   something doesn't update, exit the process and rerun the command.
   Improvements to this functionality are planned.

7. Commit your changes to the branch and submit your PR.

   If your change is large, or you'd like to test it,
   consider [validating your changes](#validate-your-changes) and
   [deploying to a staging site](#deploy-to-a-staging-site).

> [!TIP]
> To find additional commands that you can run,
> run `dart run dart_site --help` from the repository's root directory.

## Validate your changes

### Check documentation and example code

If you've made changes to the code in the `/examples` or `/tool` directories,
commit your work, then run the following command to
verify it is up to date and matches the site standards.

```terminal
dart run dart_site check-all
```

If this script reports any errors or warnings,
then address those issues and rerun the command.
If you have any issues, reach out for help.

## Deploy to a staging site

Submitted pull requests can be automatically staged
by a site maintainer.
If you'd like to stage the site yourself though,
you can build a full version and upload it to Firebase.

1. If you don't already have a Firebase project,

   - Navigate to the [Firebase Console](https://console.firebase.google.com)
     and create your own Firebase project (for example, `dart-dev-staging`).

   - Head back to your local terminal and verify that you are logged in.

     ```terminal
     firebase login
     ```

   - Ensure that your project exists and activate that project:

     ```terminal
     firebase projects:list
     firebase use <your-project>
     ```

2. From the root directory of the repository, build the site:

   ```terminal
   dart run dart_site build
   ```

   This will build the site and copy it to your local `_site` directory.
   If that directory previously existed, it will be replaced.

3. Deploy to your activated Firebase project's default hosting site:

   ```terminal
   firebase deploy --only hosting
   ```

4. Navigate to your PR on GitHub and include the link of the staged version.
   Do consider adding a reference to the commit you staged,
   so that reviewers know if any further changes have been made.


[Build Status SVG]: https://github.com/dart-lang/site-www/workflows/build/badge.svg
[OpenSSF Scorecard SVG]: https://api.securityscorecards.dev/projects/github.com/dart-lang/site-www/badge
[Scorecard Results]: https://deps.dev/project/github/dart-lang%2Fsite-www
[cloning]: https://docs.github.com/repositories/creating-and-managing-repositories/cloning-a-repository
[Eleventy]: https://www.11ty.dev/
[Firebase]: https://firebase.google.com/
[forking]: https://docs.github.com/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo
[Repo on GitHub Actions]: https://github.com/dart-lang/site-www/actions?query=workflow%3Abuild+branch%3Amain
