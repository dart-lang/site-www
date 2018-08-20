---
title: DartPad
description: The tool that lets you interactively play with Dart in a browser.
---

<a href="{{site.custom.dartpad.direct-link}}"
target="_blank">DartPad (dartpad.dartlang.org)</a>
is an open-source tool that
lets you play with the Dart language in any modern browser.
Here's what DartPad looks like:

<img src="{% asset_path dartpad-hello.png %}" alt="DartPad Hello World" />


## Library support

DartPad supports
[dart:* libraries]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}})
that work with web apps; it doesn't support
[dart:io]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io) or
libraries from [packages.]({{site.pub}})
If you want to use dart:io, use the [Dart SDK](/tools/sdk) instead.
If you want to use a package, get the SDK for a
[platform](/guides/platforms) that the package supports.

## Getting started

To get familiar with DartPad, try these steps:

* [Run some samples.](#step-1-open-and-run)
* [Create a simple command-line app.](#step-2-server)
* [Create a simple web app.](#step-3-web)


### Open DartPad, and run some samples {#step-1-open-and-run}

<ol markdown="1">
  <li markdown="1">
  Go to <a href="{{site.custom.dartpad.direct-link}}" target="_blank">dartpad.dartlang.org.</a>

  A sample appears on the left and the output appears on the right.
  If you've played with DartPad before,
  you can click **New Pad** to get back to the original sample.
  </li>

  <li markdown="1">
  Click **Run**.

  The sample runs again, updating the output.
  </li>

  <li markdown="1">
  Choose an HTML sample, using the **Samples** list at the upper right.

  For example, choose **Hello World HTML**.
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
  Click the **New Pad** button.

  The source code for the Hello World app appears
  under the DART tab.
  </li>

  <li markdown="1">
  Change the code. For example, change the `main()` function
  to contain this code:

<!-- library-tour/string-tests/bin/main.dart -->
{% prettify dart %}
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


### Create a web app {#step-3-web}

To create a simple web app, start with the Hello World HTML sample.

<ol>
  <li>
    Click <b>Samples</b>, and choose <b>Hello World HTML</b>.
    If you've already edited Hello World HTML,
    click <b>Reset</b> to restore the original version.
  </li>

  <li>
    Edit the HTML:
    <ol>
      <li>
        Click <b>HTML</b> to view the HTML code.
      </li>
      <li>
        Change the text inside the h2 element
        from <code>Hello world</code> to something else—perhaps
        <b>Hola mundo</b>.
      </li>
    </ol>
    <p>
      The display under HTML OUTPUT updates as you type.
    </p>
  </li>

  <li>
    Edit the Dart code:
    <ol>
      <li>
        Click <b>DART</b> to view the Dart code.
      </li>
      <li>
        Change the value displayed by <code>count.text</code>.
        For example, change <code>'${i}'</code> to <code>'#${i}'</code>.
      </li>
      <li>
        Click <b>Run</b> to compile and run the Dart code,
        updating the HTML OUTPUT display.
      </li>
    </ol>
  </li>
</ol>

## Checking Dart version info

DartPad's various language features and APIs depend on the **Dart SDK version**
that DartPad is based on. You can find the SDK version in the DartPad editor
footer.
