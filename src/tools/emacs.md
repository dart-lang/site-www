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

{% comment %}

Add a vanilla Emacs config that has all above + hooks and stuff.

{% endcomment %}
  
[Doom Emacs][doom-emacs] is a popular Doom configuration framework that has
these modes pre-setup.

To enable and configure all above in [Doom Emacs][doom-emacs], you 
need to enable `:lang dart` in your `init.el` file in your `$DOOMDIR`
directory, which by default is in `~/.doom.d`.
After enabling dart module (and flags of your choice, see [flags in
README][dart-flags]), refresh your Doom by `doom refresh`
command.

{% comment %}

Add a Spacemacs config that has all above + hooks and stuff.

{% endcomment %}

[dart-mode]: https://github.com/bradyt/dart-mode
[dart-snippets]: https://github.com/MYDavoodeh/dart-snippets
[doom-emacs]: https://github.com/hlissner/doom-emacs
[dart-flags]: https://github.com/hlissner/doom-emacs/blob/develop/modules/lang/dart/README.org#module-flags
[lsp-mode]: https://github.com/emacs-lsp/lsp-mode
[flutter-mode]: https://github.com/amake/flutter.el
