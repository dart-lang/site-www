---
title: Installing Dart on Mac
short-title: Mac Install
description: Installing and updating the Dart SDK on your Mac with homebrew.
permalink: /install/mac
---

Homebrew is a package manager for macOS.
With [Homebrew](http://brew.sh/),
installing and updating Dart is easy.

Don't want to use homebrew?
Another option is [downloading Dart manually](/install/archive).

## Installing {#homebrew-install-dart}

The Dart SDK contains the VM, analyzer, formatter,
documentation generator, package manager, and the core libraries.

[Install homebrew](http://brew.sh/), and then run:

```terminal
$ brew tap dart-lang/dart
$ brew install dart
```


### Installing dev channel releases

To choose the dev channel version of whatever Dart software you install,
use `--devel`:

```terminal
$ brew install dart --devel
```

<aside class="alert alert-warning" markdown="1">
**Warning:**
To give you early access to new features and fixes,
dev channel releases are not as heavily tested as the stable release.
</aside>


## Updating {#homebrew-update-dart}

To update Dart once you've installed it using Homebrew, run:

```terminal
$ brew update
$ brew upgrade dart
$ brew cleanup dart
```

{% comment %}
PENDING: clarify what arguments you should supply,
depending on what arguments you used before.
{% endcomment %}


## SDK installation location {#installation-locations}

Many tools, such as editors, ask you to specify the Dart SDK
installation directory.
Homebrew uses the following location,
where you replace `HOMEBREW_INSTALL` with the
the homebrew installation directory
(which you can get using `brew --prefix`):

`HOMEBREW_INSTALL/opt/dart/libexec`


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

   ```terminal
   $ cd ~    # The directory that will contain Homebrew and Dart
   ```

2. Clone Homebrew. This creates a `homebrew` directory.

   ```terminal
   $ git clone https://github.com/Homebrew/homebrew.git
   ```

3. Add the `homebrew/bin` directory to your PATH.

4. Follow the `brew` instructions in
[Installing Dart](#homebrew-install-dart).
Dart will be installed under `homebrew`.
