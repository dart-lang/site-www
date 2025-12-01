---
title: IntelliJ & Android Studio
description: Use the Dart plugin with a variety of IntelliJ Platform-based IDEs.
---

The [Dart plugin][] adds Dart support
to IntelliJ Platform-based IDEs.
These IDEs provide features unique to specific development technologies.
The IDEs recommended for Dart and Flutter development include:

- [IntelliJ IDEA][] which specializes in JVM-based language development.
- [WebStorm][] which specializes in web app development.
- [Android Studio][] which specializes in Android and Flutter development.

Whichever JetBrains IDE you choose for Dart development,
this page has resources to help you get started quickly
and find more information when you need it.

[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[WebStorm]: https://www.jetbrains.com/webstorm/
[Android Studio]: {{site.android-dev}}/studio

## Getting started

If you don't already have the IDE and the Dart SDK, get them.
Then install the Dart plugin and tell it where to find the Dart SDK.



### Downloading the IDE

Install a JetBrains IDE if you don't already have one. Choose one:

* [IntelliJ IDEA][IDEA-Install]{:target="_blank" rel="noopener"}
* [IntelliJ IDEA EAP][IDEA-EAP-Install]{:target="_blank" rel="noopener"}
  (for early access to the latest Dart language features and IntelliJ functionality)
* [WebStorm][WS-Install]{:target="_blank" rel="noopener"}
* [Android Studio][AS-Install]{:target="_blank" rel="noopener"}
* [Another JetBrains product][Other]{:target="_blank" rel="noopener"}

[IDEA-Install]: https://www.jetbrains.com/idea/download/
[IDEA-EAP-Install]: https://www.jetbrains.com/idea/nextversion/
[WS-Install]: https://www.jetbrains.com/webstorm/download/
[AS-Install]: {{site.android-dev}}/studio/install
[Other]: https://www.jetbrains.com/products.html

:::note
The Community Edition of IntelliJ IDEA has limited functionality.
For example, it doesn't directly support debugging web apps.
It also has very little support for JavaScript, HTML, CSS, and YAML.
:::


### Downloading the Dart SDK

If you don't already have the Dart SDK,
install it.
You can get it either by itself or by downloading the Flutter SDK,
which includes the full Dart SDK.

Choose one:

* [Download the Dart SDK](/get-dart)
* [Download the Flutter SDK]({{site.flutter-docs}}/get-started/install)


### Configuring Dart support

Here's one way to configure Dart support:

1. Start the IDE, and install the **Dart** plugin.
   1. From the Welcome screen, choose **Plugins**.
   2. Search for **Dart**.
   3. Once you've installed the Dart plugin, restart the IDE.

2. Create a new Dart project:
   1. From the Welcome screen, click **New Project**.
   2. In the next dialog, click **Dart**.

3. If you don't see a value for the **Dart SDK** path,
   enter or select it.

   For example, the SDK path might be `<dart installation directory>/dart/dart-sdk`.

   :::note
   The **Dart SDK** specifies the directory that contains the SDK's `bin` and `lib` directories;
   the `bin` directory contains tools such as `dart` and `dartaotruntime`.
   The IDE ensures that the path is valid.
   :::

4. Choose a starting template.
   1. To enable starting templates, click **Generate sample content**.
   2. Pick your desired template.

   :::note
   The provided templates are supplied and created by
   [`dart create`](/tools/dart-create).
   :::

5. Click **Next** and continue project setup.

An alternative to Step 2 is to open an existing Dart project,
and then open its `pubspec.yaml` file or any of its Dart files.


## Reporting issues

Please report issues and feedback via the official
[JetBrains issue tracker for Dart][]

Include details of the expected behavior, the actual behavior,
and screenshots if appropriate.

[JetBrains issue tracker for Dart]: https://youtrack.jetbrains.com/issues?q=Subsystem:%20%7BLang.%20Dart%7D%20

## More information

See the JetBrains website for more information.

* [IntelliJ IDEA](https://www.jetbrains.com/idea/)
  * [Dart WebStorm Help](https://www.jetbrains.com/help/webstorm/dart.html)
  * [Features](https://www.jetbrains.com/idea/features/)
  * [Quick start](https://www.jetbrains.com/help/idea/getting-started.html)
* [Dart Plugin by JetBrains][Dart plugin]

[Dart plugin]: https://plugins.jetbrains.com/plugin/6351-dart/
