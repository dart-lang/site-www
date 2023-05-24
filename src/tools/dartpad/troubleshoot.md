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
  [implicit animations codelab]({{site.flutter-docs}}/codelabs/implicit-animations),
  you might need to allow cookies for the embedding site domain, as well
  (in these cases, **dart.dev** and **flutter.dev**, respectively).

* If you repeatedly reload a page that contains embedded DartPads, 
  then you might run into [GitHub rate limiting.][]
  Within 60 minutes, you should be able to reload the page and see code in the embedded DartPads.

Although DartPad doesn't use cookies, it does rely on local storage,
which browsers usually disable when cookies are disabled.


## Code doesn't work outside DartPad

If you copy code from DartPad into another environment,
the code might not run successfully.
Here are some possible causes and fixes:

* If Dart can't find an imported library,
  make sure you've added all necessary package dependencies.
  DartPad includes many built-in packages by default,
  but your own project must explicitly list the packages that it depends on.
  To see the packages that DartPad includes, 
  go to [dartpad.dev]({{site.dartpad}}) 
  and click the **i** icon at the bottom right of the window.
  To learn more about adding package dependencies,
  see the documentation for [`dart pub add`](/tools/pub/cmd/pub-add).

* If Dart can't find certain methods or properties,
  check the code included with the tests.
  For instructional and brevity purposes, 
  some code is not included in the primary code editing window,
  but instead implemented separately alongside the tests.

* If the code has other compilation errors,
  make sure you're using the latest stable version of the Dart SDK.
  DartPad and embedded samples 
  generally use the latest stable release of the SDK,
  and older versions might be missing necessary language or library features.
  To learn how to update the Dart SDK,
  see [Get the Dart SDK](/get-dart).

* If you're creating a web app,
  make sure you have the proper project setup.
  For example, the `HTML` tab doesn't show
  all the necessary markup to run Dart code.
  To learn about connecting Dart code to the web,
  see [HTML and Dart connections][].
  To get started creating web apps with Dart,
  see [Get started: Web apps](/tutorials/web/get-started).


## Analysis issues and compilation results don't match displayed code

DartPad only compiles and analyzes code in the primary **Dart** tab.

If the listed analysis issues and compilation results
don't match the code being displayed, 
verify you are editing the code in the **Dart** tab,
not **Solution** or **Tests**.


## Previously working code now has errors

If the code is using language or library features no longer supported
in the latest stable release of Dart,
the code may no longer analyze or run without errors.

* If the code worked in the previous Dart release,
  consider switching to the **old channel**
  with the **channel** dropdown at the bottom left of the playground.
  If possible, update the code to work with the latest release,
  as the **old channel** only supports the previous stable release.

* If the code doesn't support [null safety][], update your code.
  DartPad no longer supports non-nullable Dart code.


## DartPad doesn't work in China
  
Try [dartpad.cn.](https://dartpad.cn)


## Other issues

If you have any other problems when using DartPad,
[create an issue on GitHub.][new-issue]

[GitHub rate limiting.]: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting
[browser]: /resources/faq#q-what-browsers-do-you-support-as-javascript-compilation-targets
[chrome-cookies]: https://support.google.com/chrome/answer/95647
[new-issue]: https://github.com/dart-lang/dart-pad/issues/new
[null safety]: /null-safety
[HTML and Dart connections]: /tutorials/web/low-level-html/connect-dart-html#connections
