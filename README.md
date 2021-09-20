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

> NOTE: If you clone this repo locally, see the instructions below on cloning
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

### 1. Get the prerequisites

Install the following tools if you don't have them already.

- **bash**, the Bourne shell. These instructions assume you're using `bash`;
setup might not work if you use another shell.
- **[nvm][]**, the Node Version Manager.

  > NOTE: To make `nvm` immediately available in your current shell,
  > run `source <PATH_TO_INSTALLATION>`. For example:
  > ```console
  > $ source ~/.nvm/nvm.sh
  > ```

- **[rvm][]**, the Ruby Version Manager.

  > NOTE: To make `rvm` immediately available in your current shell,
  > run `source <PATH_TO_INSTALLATION>`. For example:
  > ```console
  > $ source ~/.rvm/bin/rvm
  > ```
- **[Dart][]**
- **[GNU diffutils][]** version 3.6 or later.
  > NOTE: `diff` v3.6+ is required to ensure that in-page code diffs are
  > consistently refreshed across macOS and Linux.
  > To upgrade `diffutils` on macOS run:<br>
  > ```console
  > $ brew install diffutils
  > ```

> IMPORTANT: Follow the installation instructions for each of the tools
carefully. In particular, configure your shell/environment so
that the tools are available in every terminal/command window you create.

### 2. Clone this repo _and_ its submodule

> NOTE: This repo has a git _submodule_, which affects how you clone it.

To **clone this repo** ([site-www][]), follow the instructions given in the
GitHub help on [Cloning a repository][], and _choose one_ of the following
submodule-cloning techniques:

- Clone this repo and its submodule _at the same time_, use the
  `--recurse-submodules` option:<br>

  ```console
  $ git clone --recurse-submodules https://github.com/dart-lang/site-www.git
  ```

  OR
- If you've already cloned this repo without its submodule, then run
  this command from the repo root:<br>

  ```console
  $ git submodule update --init --recursive
  ```

> IMPORTANT:
> Whenever you update your repo, update the submodule as well:<br>
> `git pull; git submodule update --init --recursive`

### 3. Run installation scripts

> NOTE: It is safe to (re-)run all of the commands and scripts given below even
> if you already have the required packages installed.

**Open a bash terminal/command window** and execute the following commands:

1. After you have cloned this repo, change to the _root of this repo_:

   ```console
   $ cd <PATH_TO_REPO>
   ```
1.  Run the `env-set.sh` script to initialize environment variables,
    and to install/use required Node & Ruby version:

    ```console
    $ source ./tool/env-set.sh
    ```
1.  Run `before-install.sh` to install the  core set of required tools:

    ```console
    $ ./tool/before-install.sh
    ```
1.  Run `install.sh` to install everything else needed to build this site:

    ```console
    $ ./tool/install.sh
    ```

You _may_ need to run `gem install bundler` to upgrade it to the latest version
if you get errors such as `require: cannot load such file` later.
Another command that seems to be useful
when the usual installation process doesn't work is
`bundle install --force`.

> IMPORTANT:
> - Any time you create a **new terminal/command window** to work on
>   this repo, **repeat steps 1 and 2** above.

## Building this site

Once everything is installed, you need to do a full site build at least once:

```console
$ jekyll build # full site build
```

The generated site is placed in the `_site` folder. To serve this folder use:

```console
$ npx superstatic --port 4000
```

Or, if you aren't testing redirects, use this command (which has the bonus of
autorefreshing your browser after edits):

```console
$ jekyll serve --livereload
```

To view the generated site open [localhost:4000](http://localhost:4000).

You can build, serve, and have a watcher for changes by
running the following command:

```console
$ ./tool/serve.sh
```

## Pre-push checks

If you've made changes to this site's documentation and committed locally, then
run the following command before pushing your work:

```console
$ ./tool/pre-push.sh
```

If the script reports errors or warnings, then address the issues and rerun the
script. Otherwise, you can push your changes.

## Site checks

### Checking example code

If you've made changes to the example code run the following commands:

```console
$ ./tool/dartformat.sh
$ ./tool/refresh-code-excerpts.sh
$ ./tool/analyze-and-test-examples.sh --quick
```

If the last command reports failed tests and you'd like to know which
test failed, then rerun the command without the `-q` flag.

### Checking the site's HTML

1. Build the site and launch the server:

    ```console
    $ jekyll build && npx superstatic --port 4000
    ```

1. Next, to check for broken links, run this from the top of the repo:

    ```console
    $ ./tool/shared/check-links.sh
    ```

    To also check external URLs (which is much slower), run the linkcheck command
    with the `--external` (or `-e`, for short) option.

    With this tool you can check any URL by simply specifying it as a parameter:

    ```console
    $ dart pub global activate linkcheck
    $ linkcheck https://dart.dev
    ```

    To check for valid HTML, good images, and broken links (though not as well
    as linkcheck.dart), run this from the top of the repo:
    **NOTE: As of April 16, 2019, this doesn't work. See
    [issue #1461](https://github.com/dart-lang/site-www/issues/1461).**

    ```console
    $ ./deploy/html_proof.rb
    ```

    To find old links (from the site version before this one) that are broken,
    use these commands:

    ```console
    $ ./tool/serve.sh &
    $ linkcheck -i deploy/urls/old_site_urls.txt
    ```

## Staging the site

1. Save your changes. For example, from the top directory:

    ```consolew
    $ git commit src
    ```

1. Create a pull request by pushing your branch to GitHub.

    ```console
    $ git push origin <branchname>
    ```

1. Navigate to the Firebase console,
[console.firebase.google.com](https://console.firebase.google.com/).

1. If you don't already have a project to stage to,
   create it:

   1. Select **Create New Project**.
   1. Enter a project name in the dialog, such as `staging-1`.
   1. Click **Create Project**. This takes you to the
      page for your new project.

    > **Note:** To keep the number of projects under control,
    > we reuse them. Our naming convention is
    > `<first initial><last initial>-dart-dev-<number>`. For example,
    > `sz-dart-dev-1` and `kw-dart-dev-1`.

1. Build the docs, to get the latest changes:

    ```console
    $ jekyll build
    ```

1. Return to the [Firebase console](https://console.firebase.google.com),
   and get the name of your project (e.g. `sz-dart-dev-2`),
   which the following step calls FB-NAME.

1. Deploy the docs, substituting the name of your project for FB-NAME:

    ```console
    $ ./tool/shared/deploy.sh --local FB-NAME
    ```

    You can now navigate to the staged version at
    `https://<your-instance>.firebaseapp.com` -— for example,
    `https://sz-dart-dev-2.firebaseapp.com`.

1. Navigate to the PR on GitHub and update it with
   the location of the staged version,
   the names of your reviewers, and so on.


## Troubleshooting the build

See the [Troubleshooting wiki page][].


[Build Status SVG]: https://github.com/dart-lang/site-www/workflows/build/badge.svg
[Cloning a repository]: https://docs.github.com/repositories/creating-and-managing-repositories/cloning-a-repository
[Dart]: https://dart.dev/get-dart
[Dart install]: https://dart.dev/get-dart
[Firebase]: https://firebase.google.com/
[first-timers SVG]: https://img.shields.io/badge/first--timers--only-friendly-blue.svg?style=flat-square
[first-timers]: https://www.firsttimersonly.com/
[GNU diffutils]: https://www.gnu.org/software/diffutils
[Jekyll]: https://jekyllrb.com/
[nvm]: https://github.com/nvm-sh/nvm/blob/master/README.md#installing-and-updating
[Repo on GitHub Actions]: https://github.com/dart-lang/site-www/actions?query=workflow%3Abuild+branch%3Amaster
[rvm]: https://rvm.io/rvm/install#installation
[site-www]: https://github.com/dart-lang/site-www
[Troubleshooting wiki page]: https://github.com/dart-lang/site-www/wiki/Troubleshooting
