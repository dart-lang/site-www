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

* Make sure you're using one of the latest two versions of Chrome,
  Edge, Firefox, or Safari.
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
  (in these cases, **dart.dev** and **docs.flutter.dev**, respectively).

* If you repeatedly reload a page that contains embedded DartPads, 
  then you might run into [GitHub rate limiting.][]
  Within 60 minutes, you should be able to reload the page and 
  see code in the embedded DartPads.

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
  To learn more about adding package dependencies to your own project,
  see the documentation for [`dart pub add`](/tools/pub/cmd/pub-add).

* If Dart can't find certain methods or properties,
  check the code included provided alongside the exercise.

* If the code has other compilation errors,
  make sure you're using the latest stable version of the Dart SDK.
  DartPad and embedded samples 
  generally use the latest stable release of the SDK,
  and older versions might be missing necessary language or library features.
  To learn how to update the Dart SDK,
  see [Get the Dart SDK](/get-dart).

* If you're creating a web app,
  make sure you have the proper project setup.
  DartPad doesn't show all the necessary markup to run Dart code.
  To get started creating web apps with Dart,
  check out [Build a web app with Dart](/web/get-started).

## Previously working code now has errors

If the code is using language or library features no longer supported
in the latest stable release of Dart,
the code may no longer analyze or run without errors.

* If possible, update the code to work with the latest Dart release,
  as DartPad only supports the **stable** and **beta** channels.
* If the code worked in an earlier Dart release,
  you can use that version of Dart locally.
  To learn how to install a specific version of Dart,
  check out [Get the Dart SDK](/get-dart).

## DartPad doesn't work in China
  
Try [dartpad.cn.](https://dartpad.cn)

## Other issues

If you have any other problems when using DartPad,
[create an issue on GitHub.][new-issue]

[GitHub rate limiting.]: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting
[browser]: /resources/faq#q-what-browsers-do-you-support-as-javascript-compilation-targets
[chrome-cookies]: https://support.google.com/chrome/answer/95647
[new-issue]: {{site.repo.dart.org}}/dart-pad/issues/new
