---
title: IntelliJ & Android Studio
description: Use Dart with a variety of IDEs and editors from JetBrains.
---

The Dart plugin adds Dart support to JetBrains IDEs such as
IntelliJ IDEA and Android Studio.
IntelliJ IDEA is an intelligent Java IDE
with support for many other languages and frameworks.
Android Studio is an IDE based on IntelliJ IDEA
that's used for Android and Flutter development.

Whichever JetBrains IDE you choose for Dart development,
this page has resources to help you get started quickly
and find more information when you need it.

<aside class="alert alert-info" markdown="1">
  **Note:**
  [WebStorm,](https://www.jetbrains.com/webstorm/)
  a JetBrains IDE for client-side development,
  comes with the Dart plugin pre-installed.
</aside>

## Getting started

If you don't already have the IDE and the Dart SDK, get them.
Then install the Dart plugin and tell it where to find the Dart SDK.


### Downloading the IDE

Install a JetBrains IDE if you don't already have one.

* <a href="https://www.jetbrains.com/idea/download/"
  target="_blank">Download IntelliJ IDEA</a> or,
  to try out the latest Dart language features,
  [install IntelliJ IDEA EAP.](https://confluence.jetbrains.com/display/IDEADEV/EAP)
* Or <a href="https://www.jetbrains.com/products.html"
  target="_blank">find another JetBrains product.</a>

<aside class="alert alert-info" markdown="1">
  **Note:**
  The Community Edition of IntelliJ IDEA has limited functionality.
  For example, it doesn't directly support debugging web apps.
  It also has very little support for JavaScript, HTML, CSS, and YAML.
</aside>


### Downloading the Dart SDK

If you don't already have the Dart SDK,
install it.

* [Download the Dart SDK](/get-dart)


### Configuring Dart support

Here's one way to configure Dart support:

<ol>
<li>
  <p>
    Start the IDE, and install the <b>Dart</b> plugin.
    To find the Dart plugin, from the Welcome screen
    choose <b>Configure > Plugins</b>,
    then click <b>Install JetBrains plugin</b>,
    and then search or scroll down until you find <b>Dart</b>.
    Once you've installed the Dart plugin, restart the IDE.
  </p>
</li>

<li>
  <p>
    Create a new Dart project:
  </p>

  <ol type="a">
    <li> From the Welcome screen, click <b>Create New Project</b>. </li>
    <li> In the next dialog, click <b>Dart</b>.</li>
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

<aside class="alert alert-info" markdown="1">
  <b>Note:</b>
  The <b>Dart SDK</b> path specifies the directory that
  contains the SDK's `bin` and `lib` directories;
  the `bin` directory contains tools such as `dart` and `dartfmt`.
  The IDE ensures that the path is valid.
</aside>
</li>
</ol>

An alternative to Step 2 is to open an existing Dart project,
and then open its `pubspec.yaml` file or any of its Dart files.


{% comment %}

NOTE TO EDITORS OF THIS FILE:
[PENDING: put instructions here on how to reset to the initial
IntelliJ experience.
It probably involves deleting the IDE settings
by removing a directory.

{% endcomment %}


## Reporting issues

{% include tools/jetbrains-reporting-issues.html %}


## More information

See the JetBrains website for more information.

* [IntelliJ IDEA](https://www.jetbrains.com/idea/)
  * [Dart PhpStorm Help](https://www.jetbrains.com/help/phpstorm/dart.html)
  * [Features](https://www.jetbrains.com/idea/features/)
  * [Quick start](https://www.jetbrains.com/help/idea/meet-intellij-idea.html)
* [Dart Plugin by JetBrains](https://plugins.jetbrains.com/plugin/6351)
* [Eclipse to IntelliJ migration guide](https://www.jetbrains.com/help/idea/eclipse.html)
