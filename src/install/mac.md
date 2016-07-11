---
layout: default
title: "Installing Dart on Mac"
description: "Installing and updating the Dart SDK on your Mac with homebrew."
permalink: /install/mac
---

Homebrew is a package manager for Mac OS.
With [Homebrew](http://brew.sh/),
installing and updating Dart is easy.

Don't want to use homebrew?
Another option is [downloading Dart manually](archive/).

## Installing {#homebrew-install-dart}

The Dart SDK contains the VM, analyzer, formatter,
documentation generator, package manager, and the core libraries.

[Install homebrew](http://brew.sh/), and then run:

{% prettify shell %}
$ brew tap dart-lang/dart
$ brew install dart
{% endprettify %}

If you use Dart for web development work, you should also install Dartium and Content Shell:

{% prettify shell %}
$ brew tap dart-lang/dart
$ brew install dart --with-content-shell --with-dartium
{% endprettify %}

### Installing dev channel releases

To choose the dev channel version of whatever Dart software you install,
use `--devel`:

{% prettify shell %}
$ brew install dart --devel
{% endprettify %}

You can use any combination of the
`--devel`,
`--with-dartium`, and
`--with-content-shell` options.

<aside class="alert alert-warning" markdown="1">
**Warning:**
To give you early access to new features and fixes,
dev channel releases are not as heavily tested as the stable release.
</aside>


## Updating {#homebrew-update-dart}

To update Dart once you've installed it using Homebrew, run:

{% prettify shell %}
$ brew update
$ brew upgrade dart
{% endprettify %}

{% comment %}
PENDING: clarify what arguments you should supply,
depending on what arguments you used before.
{% endcomment %}


## Installation locations

Many tools, such as editors, ask you to specify the Dart SDK
installation directory and the location of Dartium.
Homebrew uses the following locations,
where you replace `HOMEBREW_INSTALL` with the
the homebrew installation directory
(which you can get using `brew --prefix`):

* SDK directory: `HOMEBREW_INSTALL/opt/dart/libexec`
* Dartium: `HOMEBREW_INSTALL/opt/dart/Chromium.app`


### Specifying a custom installation location {#homebrew-custom-location}

By default, Homebrew installs to `/usr/local`.
If your Mac is set up so that installing to `/usr/local` requires
using `sudo`, we recommend
downloading to another location where you have write permissions, such
as your home directory.

1. Go to the directory above where you want
   Homebrew and Dart to live.
   For example, if you want Homebrew and Dart to live under
   `~/homebrew`, go to `~`.

   {% prettify shell %}
   $ cd ~    # The directory that will contain Homebrew and Dart
   {% endprettify %}

2. Clone Homebrew. This creates a `homebrew` directory.

   {% prettify shell %}
   $ git clone https://github.com/Homebrew/homebrew.git
   {% endprettify %}

3. Add the `homebrew/bin` directory to your PATH.

4. Follow the `brew` instructions in
[Installing Dart](#homebrew-install-dart).
Dart will be installed under `homebrew`.
