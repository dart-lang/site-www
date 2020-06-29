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

DartPad supports
[dart:* libraries]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}})
that work with web apps; it doesn't support
[dart:io]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io) or
libraries from [packages.]({{site.pub}})
If you want to use dart:io, use the [Dart SDK](/tools/sdk) instead.
If you want to use a package, get the SDK for a
[platform](/platforms) that the package supports.

## Getting started

To get familiar with DartPad,
try running some samples and then creating a simple command-line app.


### Open DartPad, and run some samples {#step-1-open-and-run}

<ol markdown="1">
  <li markdown="1">
  Go to <a href="{{site.dartpad}}" target="_blank" rel="noopener">DartPad.</a>

  A sample appears on the left and the output appears on the right.
  If you've played with DartPad before,
  you can click **New Pad** to get back to the original sample.
  </li>

  <li markdown="1">
  Click **Run**.

  The sample runs again, updating the output.
  </li>

  <li markdown="1">
  Choose an HTML sample like **Sunflower**,
  using the **Samples** list at the upper right.

  Again, the output appears to the right.
  By default, you see the HTML output—what you'd see in a browser.
  </li>

  <li markdown="1">
  Click **CONSOLE** to view the sample's console output.
  </li>

  <li markdown="1">
  On the left, click the **HTML** tab to view the sample's HTML markup.
  </li>
</ol>


### Create a command-line app {#step-2-server}

To create a simple command-line app, use **New Pad**.

<ol markdown="1">
  <li markdown="1">
  Click the **New Pad** button,
  and confirm that you want to discard changes to the current pad.

  The source code for the Hello World app appears
  under the DART tab.
  </li>

  <li markdown="1">
  Clear the **Show web content** checkbox,
  at the bottom right of DartPad.

  The HTML and CSS tabs disappear.
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
  you get warnings at the bottom of the window and in the Run button.
  If you run the app, you'll see output from an uncaught exception.
  </li>
</ol>


## Checking Dart version info

The language features and APIs that DartPad supports depend on the
**Dart SDK** version that DartPad is based on.
You can find the SDK version at the bottom right of DartPad.

## Embedding DartPad in web pages {#embedding}

You can embed DartPad inside of web pages,
customizing it to suit your purpose.
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

