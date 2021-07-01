---
title: IntelliJ & Android Studio
description: Use Dart with a variety of IDEs and editors from JetBrains.
---

The [Dart plugin][] adds Dart support to JetBrains IDEs such as
IntelliJ IDEA and Android Studio.
IntelliJ IDEA is an intelligent Java IDE
with support for many other languages and frameworks.
Android Studio is an IDE based on IntelliJ IDEA
that's used for Android and Flutter development.

Whichever JetBrains IDE you choose for Dart development,
this page has resources to help you get started quickly
and find more information when you need it.

{{site.alert.note}}
  [WebStorm,](https://www.jetbrains.com/webstorm/)
  a JetBrains IDE for client-side development,
  comes with the Dart plugin pre-installed.
{{site.alert.end}}

## Getting started

If you don't already have the IDE and the Dart SDK, get them.
Then install the Dart plugin and tell it where to find the Dart SDK.


### Downloading the IDE

Install a JetBrains IDE if you don't already have one. Choose one:

* [IntelliJ IDEA][IDEA]{:target="_blank" rel="noopener"}
* [IntelliJ IDEA EAP][IDEA EAP]{:target="_blank" rel="noopener"}
  (for early access to the latest Dart language features and IntelliJ functionality)
* [Another JetBrains product][Other]{:target="_blank" rel="noopener"}

[IDEA]: https://www.jetbrains.com/idea/download/
[IDEA EAP]: https://www.jetbrains.com/idea/nextversion/
[Other]: https://www.jetbrains.com/products.html

{{site.alert.note}}
  The Community Edition of IntelliJ IDEA has limited functionality.
  For example, it doesn't directly support debugging web apps.
  It also has very little support for JavaScript, HTML, CSS, and YAML.
{{site.alert.end}}


### Downloading the Dart SDK

If you don't already have the Dart SDK,
install it.
You can get it either by itself or by downloading the Flutter SDK,
which (as of Flutter 1.21) includes the full Dart SDK.

Choose one:

* [Download the Dart SDK](/get-dart)
* [Download the Flutter SDK]({{site.flutter}}/docs/get-started/install)


### Configuring Dart support

Here's one way to configure Dart support:

<ol>
<li>
  <p>
    Start the IDE, and install the <b>Dart</b> plugin.
  </p>

  <ol type="a">
    <li>From the Welcome screen, choose <b>Plugins</b>.</li>
    <li>Search for <b>Dart</b>.</li>
    <li>Once you've installed the Dart plugin, restart the IDE.</li>
  </ol>
</li>
<br>

<li>
  <p>
    Create a new Dart project:
  </p>

  <ol type="a">
    <li>From the Welcome screen, click <b>New Project</b>.</li>
    <li>In the next dialog, click <b>Dart</b>.</li>
  </ol>
</li>
<br>

<li>
  <p>
    If you don't see a value for the <b>Dart SDK</b> path,
    enter it.
  </p>

  <p>
    For example, the SDK path might be
    <code><em>&lt;dart installation directory></em>/dart/dart-sdk</code>.
  </p>

  {{site.alert.note}}
    The **Dart SDK** specifies the directory that
    contains the SDK's `bin` and `lib` directories;
    the `bin` directory contains tools such as `dart` and `dartdoc`.
    The IDE ensures that the path is valid.
  {{site.alert.end}}
</li>

<li>
  <p>
    Choose a starting template.
  </p>

  <ol type="a">
    <li>To enable starting templates, click <b>Generate sample content</b>.</li>
    <li>Pick your desired template.</li>
  </ol>

  {{site.alert.info}}
    The provided templates are supplied and created
    by [`dart create`](/tools/dart-create).
  {{site.alert.end}}
</li>

<li>
  <p>Click <b>Next</b> and continue project setup.</p>
</li>
</ol>

An alternative to Step 2 is to open an existing Dart project,
and then open its `pubspec.yaml` file or any of its Dart files.


## Reporting issues

Please report issues and feedback via the official
[JetBrains issue tracker for Dart.][]

Include details of the expected behavior, the actual behavior,
and screenshots if appropriate.

[JetBrains issue tracker for Dart.]: https://youtrack.jetbrains.com/issues/WEB?q=Subsystem:%20Dart

## More information

See the JetBrains website for more information.

* [IntelliJ IDEA](https://www.jetbrains.com/idea/)
  * [Dart WebStorm Help](https://www.jetbrains.com/help/webstorm/dart.html)
  * [Features](https://www.jetbrains.com/idea/features/)
  * [Quick start](https://www.jetbrains.com/help/idea/getting-started.html)
* [Dart Plugin by JetBrains][Dart plugin]
* [Eclipse to IntelliJ migration guide](https://www.jetbrains.com/help/idea/migrating-from-eclipse-to-intellij-idea.html)

[Dart plugin]: https://plugins.jetbrains.com/plugin/6351-dart/
