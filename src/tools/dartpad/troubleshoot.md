---
title: Troubleshooting DartPad
description: Common problems with using DartPad
---

This page describes solutions to problems that might occur when
you're trying to use DartPad, whether at [dartpad.dev]({{ site.dartpad }})
or in a page that has embedded DartPads.

## Embedded DartPads on flutter.dev are slow in Safari

Try using another major [browser that Dart supports][browser], such as Firefox,
Edge (dev channel), or Chrome. 
This issue is being tracked in the WebKit issue tracker.

[More information](https://github.com/dart-lang/dart-pad/issues/1108)

[browser]: /faq#q-what-browsers-do-you-support-as-javascript-compilation-targets


## Embedded DartPads don't appear

The dart.dev homepage and many codelabs have embedded DartPads.
If these DartPads don't appear at all,
then try the following:

* If you're using an ad blocker, disable it.

* If you don't use an ad blocker, check whether you've disabled third-party
  tracking cookies ([Chrome instructions][chrome-cookies]).
  If you've disabled cookies, change your settings to
  **allow cookies for dartpad.dev.**

  DartPad doesn't use cookies, but it does rely on local storage,
  which browsers generally disable when you disable cookies.


## DartPad doesn't work in China
  
Try [dartpad.cn.](https://dartpad.cn)

## Other issues

If you have any other problems when using DartPad,
[create an issue on GitHub.][new-issue]

[chrome-cookies]: https://support.google.com/chrome/answer/95647
[new-issue]: https://github.com/dart-lang/dart-pad/issues/new
