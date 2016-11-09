# The Dart language site (www.dartlang.org)

[![Build Status](https://travis-ci.org/dart-lang/site-www.svg?branch=master)](https://travis-ci.org/dart-lang/site-www)
&nbsp;&nbsp;
[![Join the chat at https://gitter.im/dart-lang/site-www](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/dart-lang/site-www?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The www.dartlang.org site. Built with
[Jekyll](https://github.com/mojombo/jekyll)
and hosted on Firebase.

Also see:
* [github.com/dart-lang/site-webdev](http://github.com/dart-lang/site-webdev)
* [github.com/dart-lang/site-events](http://github.com/dart-lang/site-events)
* [github.com/dart-lang/www.dartlang.org](https://github.com/dart-lang/www.dartlang.org)
  (the original www.dartlang.org site, which included information now in
  [webdev.dartlang.org](http://webdev.dartlang.org) &
  [events.dartlang.org](http://events.dartlang.org); the repo includes more setup info than we have here)


## Editing the site

See [Writing for *.dartlang.org](https://github.com/dart-lang/site-www/wiki/Writing-for-*.dartlang.org).

Contributions welcome!
(Just sign our [CLA](https://developers.google.com/open-source/cla/individual).)

## Building the site

### One-time setup

1. If you're on a Mac, install Xcode.
1. Make sure you have Ruby. Consider using [rvm](http://rvm.io/rvm/install) to manage Ruby versions.
1. Install `npm` by installing [Node.js](https://nodejs.org/en/); only needed to install firebase tools.
1. Install Firebase:

    ```
    npm install -g firebase-tools     # might require sudo
    ```

1. Install bundles (you might need to run `gem install bundler` first):

    ```
    bundle install
    ```

1. Install the `linkcheck` tool

    ```
    pub global activate linkcheck
    ```

    Follow the instructions provided by `pub global` to put the `linkcheck`
    command on your path.

### While you're editing the site

While you're working on the site, the best way to see your changes is
to run the provided script, which runs `jekyll build --watch` and
`firebase serve --port 4000` in parallel.

In terminal, run:

```
./serve_local.sh
```

Navigate to [localhost:4000](http://localhost:4000); webdev is served from [localhost:4001](http://localhost:4001).

Since we host on Firebase, using the Firebase server
makes sure everything works as closely to production as possible.
Firebase hosting behaves very differently from Jekyll's WEBrick server,
and our redirects in `firebase.json` obviously only work with Firebase.


## Checking the site's HTML

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
  (Hint: If the last file read is get-started-flowchart.png,
  then you're probably running the jekyll server, not the firebase one.)

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


## Checking against the old sitemap

To make sure we are not breaking any links (or bookmarks) from yesteryear, you
can take the old sitemap as input for the link checker.

Again, make sure you are runnig the localhost server (`firebase serve`), then:

```
linkcheck -i deploy/urls/old_site_urls.txt
```
