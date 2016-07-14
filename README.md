# The Dart language site (www.dartlang.org)

[![Join the chat at https://gitter.im/dart-lang/site-www](https://badges.gitter.im/dart-lang/site-www.svg)](https://gitter.im/dart-lang/site-www?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

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

## Building the site

### One-time setup

1. If you're on a Mac, install Xcode.
1. Make sure you have Ruby. Consider using `rvm` to manage Ruby versions.
1. Install `npm` by installing [Node.js](https://nodejs.org/en/).
1. Install Firebase:

   ```
npm install -g firebase-tools     # might require sudo
```   
1. Install bundles

   ```
bundle install
```

### While you're editing the site

While you're working on the site, the easiest way to see your changes is to use jekyll:

```
jekyll serve --watch
```

Navigate to localhost:4000. (webdev is 4001)


### To see the Firebase version of the site

Unless your changes are dirt simple (no links, no images),
check them using the Firebase server:

```
jekyll build && firebase serve --port 4000
```


## Checking the site's HTML

To check for valid HTML, good images, and broken links,
run this from the top of the repo:

```
./deploy/html_proof.rb
```

## More processes...

Check the sitemap links using the
following Ruby script.
This command requires npm and Firebase:

From the top-level directory, run:

```
deploy/check_sitemap.rb
```


## Misc notes

We plan to beef these notes up and move them to a separate page.

* If you want italics, use &lt;em&gt;. The i-tag is used for icon fonts, such as
  font-awesome.
* We plan to feature links without trailing slashes. Consequences:
  * If you're editing an index.md/index.html page, use absolute links.
    [PENDING: example here]
  * The permalink must not have a trailing slash. (Otherwise, the link checker won't find issues.)
  * (Are there analytics consequences?)
