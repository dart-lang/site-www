---
title: Emacs
description: Use Dart on Emacs and its flavors
toc: false
---

Emacs has a few major and minor modes built for Dart and Flutter development.

All the steps are identical for enabling Flutter since
[Dart-Snippets][dart-snippets] contain Flutter snippets too.
[Flutter.el][flutter-mode] only allows you to run Flutter commands inside your Emacs.

* [Dart-Mode][dart-mode] is the main mode for development.
* [Dart-Snippets][dart-snippets] enables [Visual Studio Code](/tools/vs-code)
  like snippets and more. Snippets like `if` that expand to structured code upon
  pressing the tab key.
* [LSP-Mode][lsp-mode] adds IDE-like features to Dart mode. Features like
  helpers, auto-complete, error listing and other typical feature that you
  expect from an IDE. (Requires SDK).
  
{{site.alert.note}} [Yasnippet-Snippets][yas-snippets] is a general snippet
package containing a limited collection of the most common snippets.
It is available on MELPA and can be an alternative to
[Dart-Snippets][dart-snippets] if you prefer to have all your packages installed
from MELPA. {{site.alert.end}}

## Doom Emacs
[Doom Emacs][doom-emacs] is a popular Doom configuration framework that has
these modes pre-setup.

To enable and configure all above in [Doom Emacs][doom-emacs], you 
need to enable `:lang dart` in your `init.el` file in your `$DOOMDIR`
directory, which by default is in `~/.doom.d`.
After enabling dart module (and flags of your choice, see [flags in
README][dart-flags]), refresh your Doom by `doom refresh`
command.

{% comment %}

*Add more details on Vanilla Emacs. More specific.*

{% endcomment %}

## Vanilla Emacs

Unless you want to build the packages from the source, you must use [MELPA][melpa] and
GNU to install the packages.

In detail instructions are addressed in each repository. A summary is as below.

* Make or find your [Init File](https://www.emacswiki.org/emacs/InitFile)
  (Default: `~/.emacs.d/init.el`).

* Add and enable MELPA and GNU

  To enable MELPA and GNU you just need to paste the code below in your init
  file.

  ```lisp
  (require 'package)
  (setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
  (package-initialize)
  ```

* Once MELPA is added you can append the code below to get all the packages installed.
  Or you can (`Alt-x`) `M-x package-list-packages` to install your packages of choice manually.

  ```lisp
  (setq package-list
      '(dart-mode
        lsp-mode
        yasnippet
        ;; yasnippet-snippets
        flutter))

  (unless package-archive-contents
    (package-refresh-contents))

  (dolist (package package-list)
    (unless (package-installed-p package)
      (package-install package)))

  (add-to-list 'load-path "~/.emacs.d/plugins/dart-snippets")
  (require 'dart-snippets)
  ```

* At last just clone [Dart-Snippets][dart-snippets] to your
  `~/.emacs/plugins/dart-snippets` folder.

  ```shell
  mkdir -p '~/.emacs.d/plugins'
  cd '~/.emacs.d/plugins'
  git clone https://github.com/MYDavoodeh/dart-snippets
  ```

{{site.alert.warning}} In order to get the Flutter.el to work correctly,
you need `flutter` in your PATH and preferably have Flutter installed
in `~/.flutter/` or have `~/.flutter/` linked to your installation folder.
{{site.alert.end}}

{% comment %}

## Spacemacs

Add a Spacemacs config that has all above + hooks and stuff.

# Configuration

Go thro common `def-cutoms` if ever needed.

{% endcomment %}


[dart-mode]: https://github.com/bradyt/dart-mode
[dart-snippets]: https://github.com/MYDavoodeh/dart-snippets
[doom-emacs]: https://github.com/hlissner/doom-emacs
[dart-flags]: https://github.com/hlissner/doom-emacs/blob/develop/modules/lang/dart/README.org#module-flags
[lsp-mode]: https://github.com/emacs-lsp/lsp-mode
[flutter-mode]: https://github.com/amake/flutter.el
[melpa]: http://melpa.org/
[yas-snippets]: https://github.com/AndreaCrotti/yasnippet-snippets
