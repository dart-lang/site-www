---
title: Troubleshooting DartPad
description: Common problems with using DartPad
---

This page describes solutions to problems that might occur when
you're trying to use DartPad, whether at [dartpad.dev]({{site.dartpad}})
or in a page that has embedded DartPads.
For an overview of DartPad, see the
[DartPad page](/tools/dartpad).


## Embedded DartPads don't appear

The dart.dev homepage and many codelabs have embedded DartPads.
If these DartPads don't appear at all,
then try the following:

* Make sure you're using a [supported browser][browser].
  DartPad might not work in other browsers, and is known not to work in
  the default configuration of the Brave browser.

* If you're using an ad blocker, disable it.

* Check whether you've disabled third-party
  tracking cookies ([Chrome instructions][chrome-cookies]).
  If you've disabled cookies, change your settings to
  **allow cookies for dartpad.dev**.
  If you're using embedded DartPads,
  such as in the [Dart cheatsheet codelab](/codelabs/dart-cheatsheet) or the
  [implicit animations codelab]({{site.flutter}}/docs/codelabs/implicit-animations),
  you might need to allow cookies for the embedding site domain, as well
  (in these cases, **dart.dev** and **flutter.dev**, respectively).

* If you repeatedly reload a page that contains embedded DartPads, 
  then you might run into [GitHub rate limiting.][]
  Within 60 minutes, you should be able to reload the page and see code in the embedded DartPads.

Although DartPad doesn't use cookies, it does rely on local storage,
which browsers usually disable when cookies are disabled.


## DartPad doesn't work in China
  
Try [dartpad.cn.](https://dartpad.cn)

## Other issues

If you have any other problems when using DartPad,
[create an issue on GitHub.][new-issue]

[GitHub rate limiting.]: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting
[browser]: /faq#q-what-browsers-do-you-support-as-javascript-compilation-targets
[chrome-cookies]: https://support.google.com/chrome/answer/95647
[new-issue]: https://github.com/dart-lang/dart-pad/issues/new
