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
1. Make sure you have Ruby. Consider using `rvm` to manage Ruby versions.
1. Install `npm` by installing [Node.js](https://nodejs.org/en/).
1. Install Firebase:

    ```
    npm install -g firebase-tools     # might require sudo
    ```   

1. Install bundles:

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

Navigate to http://localhost:4000. (webdev is 4001)

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

## Checking against the old sitemap

To make sure we are not breaking any links (or bookmarks) from yesteryear, you
can take the old sitemap as input for the link checker.

Again, make sure you are runnig the localhost server (`firebase serve`), then:

```
linkcheck -i deploy/urls/old_site_urls.txt
```
