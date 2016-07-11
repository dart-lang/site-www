---
layout: default
permalink: /tools/jetbrains-plugin
title: "Dart Plugin from JetBrains"
description: "Use Dart with a variety of IDEs and editors from JetBrains."
---

The Dart plugin adds Dart support to JetBrains IDEs such as
WebStorm and IntelliJ IDEA.
WebStorm is an IDE for client-side development.
IntelliJ IDEA is an intelligent Java IDE
with support for many other languages and frameworks.

Whichever JetBrains IDE you choose for Dart development,
this page has resources to help you get started quickly
and find more information when you need it.

<aside class="alert alert-info" markdown="1">
**Note:**
WebStorm comes with the Dart plugin pre-installed.
For details on using WebStorm,
read the [WebStorm page]({{site.webdev}}/tools/webstorm).
</aside>

## Getting started

Once your IDE has the Dart plugin,
you need to tell it where to find the Dart SDK and
(optionally) Dartium.


### Downloading the IDE

Install a JetBrains IDE if you don't already have one.

* <a href="https://www.jetbrains.com/idea/download/"
  target="_blank">Download IntelliJ IDEA</a> or,
  to try out the latest Dart language features,
  [install IntelliJ IDEA EAP](https://confluence.jetbrains.com/display/IDEADEV/EAP)
* <a href="https://www.jetbrains.com/products.html"
  target="_blank">Find another JetBrains product</a>

<aside class="alert alert-info" markdown="1">
  **Note:**
  The Community Edition of IntelliJ IDEA has limited functionality.
  For example, it doesn't directly support debugging web apps,
  although you can debug using the Chrome DevTools that are built into Dartium.
  It also has very little support for JavaScript, HTML, CSS, and YAML.
</aside>


### Downloading the Dart SDK

If you don't already have the Dart SDK,
you need to install it.
If you're using Dart to develop web apps,
we recommend install Dartium, as well.

* [Download the Dart SDK](/install/)
* [Download Dartium]({{site.webdev}}/tools/dartium) (optional)


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
</li>
<br>

<li>
  <p>
    If you don't see values for the <b>Dart SDK</b> path and
    (optional) <b>Dartium</b> path, enter them.
  </p>

  <p>
    For example, the SDK path might be
    <code><em>&lt;dart installation directory></em>/dart/dart-sdk</code>,
    and the Dartium path might be
    <code><em>&lt;dartium installation directory></em>/Chromium</code>.
  </p>

<aside class="alert alert-info" markdown="1">
  <b>Note:</b>
  The <b>Dart SDK</b> path specifies the directory that
  contains the SDK's `bin` and `lib` directories;
  the `bin` directory contains tools such as `dart` and `dart2js`.
  The <b>Dartium</b> path specifies the full path to the
  `Chromium` executable that contains the Dart VM.
  The IDE ensures that the paths are valid.
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
  * [Dart support](https://www.jetbrains.com/help/idea/2016.1/dart-support.html)
  * [Features](https://www.jetbrains.com/idea/features/)
  * [Quick start](https://www.jetbrains.com/help/idea/2016.1/meet-intellij-idea.html)
* [Dart Plugin by JetBrains](https://plugins.jetbrains.com/plugin/6351)
* [FAQ for Eclipse users migrating to WebStorm/IntelliJ](https://www.jetbrains.com/idea/documentation/migration_faq.html)
