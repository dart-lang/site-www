# The Dart language site (www.dartlang.org)

[![Build Status SVG][]][Repo on Travis]
[![first-timers SVG][]][first-timers]

The www.dartlang.org site, built with [Jekyll][] and hosted on [Firebase][].

[We welcome contributions](CONTRIBUTING.md), and we're [first-timer friendly][first-timers]!

For simple changes (such as to CSS and text), you probably don't need to build this site.
But if you want/need to build, here's how.

## Before you build this site

### 1. Get the prerequisites

Install the following tools if you don't have them already.

- **[nvm][]**, the Node Version Manager.
- **[rvm][]**, the Ruby Version Manager.
- **[Dart][]**

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

### 3. Run installation scripts

> NOTE: It is safe to (re-)run all of the commands and scripts given below even
if you already have the required packages installed.

**Open a terminal/command window** and execute the following commands:

1. <code>cd <i>\<path-to-this-repo></i></code> &nbsp;&nbsp;# change to
   **root of this repo**
1. `source ./scripts/env-set.sh` &nbsp;&nbsp;#
   initialize environment variables; install/use required Node & Ruby version
1. `./scripts/before-install.sh` &nbsp;&nbsp;#
   install core set of required tools
1. `./scripts/install.sh` &nbsp;&nbsp;#
   install everything else needed to build this site

> IMPORTANT:
> - Any time you create a **new terminal/command window** to work on
>   this repo, **repeat steps 1 and 2** above.
> - If you upgrade Dart then rerun all of the steps above.

## Building this site

Once everything is installed, you need to do a full site build at least once:

- `jekyll build` &nbsp;&nbsp;# full site build

The generated site is placed in the `publish` folder. To serve this folder use:

- `superstatic --port 4000`

To view the generated site open [localhost:4000](http://localhost:4000) in a browser.

You can build, serve, and have a watcher for changes by running the following command:

- `./scripts/serve_local.sh`

## Site checks

### Checking example code

If you've made changes to the example code run the following commands:

- `./scripts/dartfmt.sh`
- `./scripts/refresh-code-excerpts.sh`
- `./scripts/analyze-and-test-examples.sh -q`

If the last command reports failed tests and you'd like to know which
test failed, then rerun the command without the `-q` flag.

### Checking the site's HTML

First, make sure you're using the Firebase server:

```
jekyll build && firebase serve --port 4000
```

Next, to check for broken links,
run this from the top of the repo:

```
linkcheck :4000
```

If the link checker crashes:
* Make sure you're using the firebase server.
* Rerun the command with the `-d` option to figure out what triggered the crash.

To also check external URLs (which is much slower), run the linkcheck command
with the `--external` (or `-e`, for short) option.

With this tool you can check any URL by simply specifying it as a parameter:

```
linkcheck https://webdev.dartlang.org/
```

To check for valid HTML, good images, and broken links (though not as well
as linkcheck.dart), run this from the top of the repo:

```
./deploy/html_proof.rb
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
1. Enter a project name in the dialog, such as
  `zz-www-dartlang-1`.
1. Click **Create Project**. This takes you to the
  page for your new project.

**Note:** To keep the number of projects under control,
we reuse them. Our naming convention is
`<first initial><last initial>-www-dartlang-<number>`, for example,
`sz-www-dartlang-1` and `kw-www-dartlang-1`. For webdev.org, replace `www`
with `webdev`.

Return to the [Firebase console](https://console.firebase.google.com/).
You should now see your project in the list.
Copy the name of your project (e.g. `sz-www-dartlang-2`) to your clipboard.

On the command line, from the top of GitHub repo, edit the
`.firebaserc` file.

Change `www-dartlang-org` to the name of your project. For example:

```
{
  "projects": {
    "default": "sz-www-dartlang-2"
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
firebase deploy
```

You can now navigate to the staged version at
`https://<your-instance>.firebaseapp.com`/—for example,
`https://sz-www-dartlang-2.firebaseapp.com/`.

**Important:** Don't commit the `.firebaserc` file containing the name of your staged version.

Navigate to the PR on GitHub and update the it with the location of the staged version,
the names of your reviewers, and so on.

Before making any more changes, stash `.firebaserc`:

`git stash`

You can later retrieve the stashed file, if you need to stage again,
using `git stash pop`.

### Checking against the old sitemap

To make sure we are not breaking any links (or bookmarks) from yesteryear, you
can take the old sitemap as input for the link checker.

Again, make sure you are running the localhost server (`./serve_local.sh`), then:

```
linkcheck :4000 -i deploy/urls/old_site_urls.txt
```

[Build Status SVG]: https://travis-ci.org/dart-lang/site-www.svg?branch=master
[Cloning a repository]: https://help.github.com/articles/cloning-a-repository
[Dart]: https://www.dartlang.org/install
[Dart install]: https://www.dartlang.org/install
[Firebase]: https://firebase.google.com/
[first-timers SVG]: https://img.shields.io/badge/first--timers--only-friendly-blue.svg?style=flat-square
[first-timers]: https://www.firsttimersonly.com/
[Jekyll]: https://jekyllrb.com/
[nvm]: https://github.com/creationix/nvm#installation
[Repo on Travis]: https://travis-ci.org/dart-lang/site-www
[rvm]: https://rvm.io/rvm/install#installation
[site-www]: https://github.com/dart-lang/site-www
