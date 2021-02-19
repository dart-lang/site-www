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
platform.

It also doesn't support using packages from the [pub.dev]({{site.pub}}) package
repository.

## Getting started

To get familiar with DartPad,
try running some samples and then creating a simple command-line app.


### Open DartPad, and run some samples {#step-1-open-and-run}

<ol markdown="1">
  <li markdown="1">
  Go to <a href="{{site.dartpad}}" target="_blank" rel="noopener">DartPad.</a>

  A sample appears on the left and the output appears on the right.
  If you've used DartPad before,
  you can click **New Pad** to get back to the original sample.
  </li>

  <li markdown="1">
  Click **Run**.

  The sample runs again, updating the output.
  </li>

  <li markdown="1">
  Choose a Flutter sample like **Sunflower**,
  using the **Samples** list in the upper right.

  Again, the rendered output appears to the right.
  </li>

  <li markdown="1">
  Click **CONSOLE** to view the sample's console output.
  </li>
</ol>


### Create a command-line app {#step-2-server}

To create a simple command-line app, use **New Pad**.

<ol markdown="1">
  <li markdown="1">
  Click the **New Pad** button,
  and confirm that you want to discard changes to the current pad.

  Click on the Dart logo to access the source code for
  the Hello World app.
  </li>

  <li markdown="1">
  Using the toggle underneath the logo,
  verify **HTML** support is disabled.
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

  For example, if you change `split` to `spit`, you get warnings in the bottom
  right of the window.
  If you run the app, you'll see a compilation error in the console.
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
[futures codelab]: /codelabs/async-await
