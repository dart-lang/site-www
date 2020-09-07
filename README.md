# The Dart language site (dart.dev)

[![Build Status SVG][]][Repo on Travis]
[![first-timers SVG][]][first-timers]

The https://dart.dev site, built with [Jekyll][] and hosted on [Firebase][].

[We welcome contributions](CONTRIBUTING.md), and we're [first-timer friendly][first-timers]!

## Getting started

Start by looking for an [issue](https://github.com/dart-lang/site-www/) that catches your
interest or generate one with your proposed change. Ask for it to be assigned to you.

To update this site, fork the repo, make your changes, and generate a pull request.
For simple changes (such as to CSS and text), you probably don't need to build this site.
Often you can make changes using the GitHub UI.

> NOTE: If you clone this repo locally, see the instructions below on cloning
> with its submodule.

If your change involves code samples, adds/removes pages, or affects navigation,
you'll need to build and test your work before submitting.

If you want or need to build, follow the steps below.

> **Help us improve these instructions!**
> If you have any problems getting set up to build or performing the actual build,
> please [edit this README](https://github.com/dart-lang/site-www/edit/master/README.md)
> or [file an issue](https://github.com/dart-lang/site-www/issues/new?title=README%20issue)
> (or both).

## Before you build this site

### 1. Get the prerequisites

Install the following tools if you don't have them already.

- **bash**, the Bourne shell. These instructions assume you're using `bash` -- setup might not work if you use another shell.
- **[nvm][]**, the Node Version Manager.
- **[rvm][]**, the Ruby Version Manager.
- **[Dart][]**
- **[GNU diffutils][]** version 3.6 or later.
  > NOTE: `diff` v3.6+ is required to ensure that in-page code diffs are
  > consistently refreshed across macOS and Linux.
  > To upgrade `diffutils` on macOS run:<br>
  > `brew install diffutils`

> IMPORTANT: Follow the installation instructions for each of the tools
carefully. In particular, configure your shell/environment so
that the tools are available in every terminal/command window you create.

### 2. Clone this repo _and_ its submodule

> NOTE: This repo has a git _submodule_, which affects how you clone it.

To **clone this repo** ([site-www][]), follow the instructions given in the
GitHub help on [Cloning a repository][], and _choose one_ of the following
submodule-cloning techniques:

- Clone this repo and its submodule _at the same_, use the
  `--recurse-submodules` option:<br>
  `git clone --recurse-submodules https://github.com/dart-lang/site-www.git`
- If you've already cloned this repo without its submodule, then run
  this command from the repo root:<br>
  `git submodule update --init --remote`

> IMPORTANT:
> Whenever you update your repo, update the submodule as well:<br>
> `git pull; git submodule update --init --remote`

### 3. Run installation scripts

> NOTE: It is safe to (re-)run all of the commands and scripts given below even
if you already have the required packages installed.

**Open a bash terminal/command window** and execute the following commands:

1. <code>cd <i>\<path-to-this-repo></i></code> &nbsp;&nbsp;# change to
   **root of this repo**
1. `source ./tool/env-set.sh` &nbsp;&nbsp;#
   initialize environment variables; install/use required Node & Ruby version
1. `./tool/before-install.sh` &nbsp;&nbsp;#
   install core set of required tools
1. `./tool/install.sh` &nbsp;&nbsp;#
   install everything else needed to build this site

> IMPORTANT:
> - Any time you create a **new terminal/command window** to work on
>   this repo, **repeat steps 1 and 2** above.
> - If you upgrade Dart then rerun all of the steps above.

## Building this site

Once everything is installed, you need to do a full site build at least once:

- `jekyll build` &nbsp;&nbsp;# full site build

The generated site is placed in the `_site` folder. To serve this folder use:

- `npx superstatic --port 4000`

Or, if you aren't testing redirects, use this command (which has the bonus of
autorefreshing your browser after edits):

- `jekyll serve --livereload`

To view the generated site open [localhost:4000](http://localhost:4000) in a browser.

You can build, serve, and have a watcher for changes by running the following command:

- `./tool/serve.sh`

## Pre-push checks

If you've made changes to this site's documentation and committed locally, then
run the following command before pushing your work:

    ./tool/pre-push.sh

If the script reports errors or warnings, then address the issues and rerun the
script. Otherwise, you can push your changes.

## Site checks

### Checking example code

If you've made changes to the example code run the following commands:

- `./tool/dartformat.sh`
- `./tool/refresh-code-excerpts.sh`
- `./tool/analyze-and-test-examples.sh --quick`

If the last command reports failed tests and you'd like to know which
test failed, then rerun the command without the `-q` flag.

### Checking the site's HTML

First, build the site and launch the server:

```
jekyll build && npx superstatic --port 4000
```

Next, to check for broken links,
run this from the top of the repo:

```
./tool/shared/check-links.sh
```

To also check external URLs (which is much slower), run the linkcheck command
with the `--external` (or `-e`, for short) option.

With this tool you can check any URL by simply specifying it as a parameter:

```
pub global activate linkcheck
linkcheck https://dart.dev
```

To check for valid HTML, good images, and broken links (though not as well
as linkcheck.dart), run this from the top of the repo:
**NOTE: As of April 16, 2019, this doesn't work. See
[issue #1461](https://github.com/dart-lang/site-www/issues/1461).**

```
./deploy/html_proof.rb
```

To find old links (from the site version before this one) that are broken,
use these commands:

```
./tool/serve.sh &
linkcheck -i deploy/urls/old_site_urls.txt
```

## Staging the site

First, save your changes.
For example, from the top directory:

```
git commit src
```

Create a pull request by pushing your branch to GitHub.

```
git push origin <branchname>
```

Navigate to the Firebase console,
[console.firebase.google.com](https://console.firebase.google.com/).

If you don't already have a project to stage to,
create it:

1. Select **Create New Project**.
1. Enter a project name in the dialog, such as `staging-1`.
1. Click **Create Project**. This takes you to the
  page for your new project.

> **Note:** To keep the number of projects under control,
we reuse them. Our naming convention is
`<first initial><last initial>-dart-dev-<number>`, for example,
`sz-dart-dev-1` and `kw-dart-dev-1`.

Return to the [Firebase console](https://console.firebase.google.com).
You should now see your project in the list.
Copy the name of your project (e.g. `sz-dart-dev-2`) to your clipboard.

On the command line, from the top of GitHub repo, edit the `.firebaserc` file.

Change `dart-dev` to the name of your project. For example:

```json
{
  "projects": {
    "default": "sz-dart-dev-2"
  }
}
```

Build the docs, to get the latest changes
and set the new project name:

```
jekyll build
```

Then deploy the docs:

```
./tool/shared/deploy.sh --local --robots ok default
```

You can now navigate to the staged version at
`https://<your-instance>.firebaseapp.com` -— for example,
`https://sz-dart-dev-2.firebaseapp.com`.

**Important:** Don't commit the `.firebaserc` file containing the name of your staged version.

Navigate to the PR on GitHub and update it with the location of the staged version,
the names of your reviewers, and so on.

Before making any more changes, stash `.firebaserc`:

```
git stash
```

You can later retrieve the stashed file, if you need to stage again,
using `git stash pop`.

## Troubleshooting the build

See the [Troubleshooting wiki page].


[Build Status SVG]: https://travis-ci.org/dart-lang/site-www.svg?branch=master
[Cloning a repository]: https://help.github.com/articles/cloning-a-repository
[Dart]: https://dart.dev/get-dart
[Dart install]: https://dart.dev/get-dart
[Firebase]: https://firebase.google.com/
[first-timers SVG]: https://img.shields.io/badge/first--timers--only-friendly-blue.svg?style=flat-square
[first-timers]: https://www.firsttimersonly.com/
[GNU diffutils]: https://www.gnu.org/software/diffutils
[Jekyll]: https://jekyllrb.com/
[nvm]: https://github.com/nvm-sh/nvm/blob/master/README.md#installing-and-updating
[Repo on Travis]: https://travis-ci.org/dart-lang/site-www
[rvm]: https://rvm.io/rvm/install#installation
[site-www]: https://github.com/dart-lang/site-www
[Troubleshooting wiki page]: https://github.com/dart-lang/site-www/wiki/Troubleshooting
