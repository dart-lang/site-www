---
title: DartPad
description: The tool that lets you interactively play with Dart in a browser.
---

DartPad is an open-source tool that
lets you play with the Dart language in any modern browser.
Many pages in this site — especially [codelabs](/codelabs) —
have [embedded DartPads](#embedding).
To get a DartPad as big as your browser window, go to the
<a href="{{site.dartpad}}" target="_blank" rel="noopener">DartPad
site (dartpad.dev).</a>

{{site.alert.tip}}
  If you're in China, try [dartpad.cn.](https://dartpad.cn)

  If you have issues using DartPad, see the [DartPad troubleshooting
  tips](/tools/dartpad/troubleshoot).
{{site.alert.end}}

Here's what DartPad looks like:

<img src="{% asset dartpad-hello.png @path %}" alt="DartPad Hello World" />


## Library support

DartPad supports `dart:*` [core libraries](/guides/libraries) marked as
multi-platform and web platform. It doesn't support those marked native
platform, and it doesn't support [deferred loading][].

It also doesn't support using packages from the [pub.dev]({{site.pub}}) package
repository.

## Getting started

To get familiar with DartPad,
try running some samples and then creating a simple command-line app.


### Open DartPad, and run a sample {#step-1-open-and-run}

<ol markdown="1">
  <li markdown="1">
  Go to <a href="{{site.dartpad}}" target="_blank" rel="noopener">DartPad.</a>

  Dart code appears on the left, and
  a place for the output appears on the right.
  </li>

  <li markdown="1">
  Choose a Flutter sample such as **Sunflower**,
  using the **Samples** list at the upper right.

  The rendered output appears to the right.
  </li>

</ol>


### Create a command-line app {#step-2-server}

To create a simple command-line app, use **New Pad**.

<ol markdown="1">
  <li markdown="1">
  Click the **New Pad** button,
  and confirm that you want to discard changes to the current pad.

  </li>

  <li markdown="1">
  Click the Dart logo, make sure that **HTML** support is disabled,
  and then click **Create**.
  </li>

  <li markdown="1">
  Change the code. For example, change the `main()` function
  to contain this code:

<!-- library-tour/string-tests/bin/main.dart -->
{% prettify dart tag=pre+code %}
for (var char in 'hello'.split('')) {
  print(char);
}
{% endprettify %}

  As you type, DartPad shows hints, documentation,
  and autocomplete suggestions.
  </li>

  <li markdown="1">
  Click the **Format** button.
  DartPad uses the [Dart formatter](https://github.com/dart-lang/dart_style#readme)
  to ensure that your code has proper indentation, white space, and line wrapping.
  </li>

  <li markdown="1">
  Run your app.
  </li>

  <li markdown="1">
  If you didn't happen to have any bugs while you were entering the code,
  try introducing a bug.

  For example, if you change `split` to `spit`,
  you get warnings at the bottom right of the window.
  If you run the app, a compilation error appears in the console.
  </li>
</ol>


## Checking Dart version info

The language features and APIs that DartPad supports depend on the
**Dart SDK** version that DartPad is based on.
You can find the SDK version at the bottom right of DartPad.

## Embedding DartPad in web pages {#embedding}

You can embed DartPad inside of web pages,
customizing it to suit your use case.
For example, the [futures codelab][]
contains multiple embedded DartPads
labeled as _examples_ and _exercises_.

For more information about how to use embedded DartPads, see
[best practices for using DartPad in tutorials][].

For technical details on embedding DartPads, see the
[DartPad embedding guide.][]

[best practices for using DartPad in tutorials]: /resources/dartpad-best-practices
[DartPad embedding guide.]: https://github.com/dart-lang/dart-pad/wiki/Embedding-Guide
[deferred loading]: /guides/language/language-tour#lazily-loading-a-library
[futures codelab]: /codelabs/async-await
