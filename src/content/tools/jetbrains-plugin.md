---
title: IntelliJ & Android Studio
description: Use the Dart plugin with a variety of IntelliJ Platform-based IDEs.
---

The Dart plugin adds Dart support to IntelliJ Platform-based IDEs.
These IDEs provide features unique to specific development technologies.
Whichever JetBrains IDE you choose for Dart development,
this page has resources to help you get started quickly
and find more information when you need it.

## Get started

If you don't already have the IDE and the Dart SDK, get them.
Then install the Dart plugin and tell it where to find the Dart SDK.


### Download the IDE

Install a JetBrains IDE if you don't already have one. Choose one:

* [Android Studio][AS-Install]{:target="_blank" rel="noopener"}
* [IntelliJ IDEA Ultimate][IDEA-Install]{:target="_blank" rel="noopener"}
* [GoLand][GoLand-Install]{:target="_blank" rel="noopener"}
* [WebStorm][WS-Install]{:target="_blank" rel="noopener"}

[AS-Install]: {{site.android-dev}}/studio/install
[IDEA-Install]: https://www.jetbrains.com/idea/download/
[GoLand-Install]: https://www.jetbrains.com/help/go/getting-started.html
[WS-Install]: https://www.jetbrains.com/webstorm/download/


### Download the Dart SDK

If you don't already have the Dart SDK,
install it.
You can get it either by itself or by downloading the Flutter SDK,
which includes the full Dart SDK.

Choose one:

* [Download the Dart SDK](/get-dart)
* [Download the Flutter SDK]({{site.flutter-docs}}/get-started/install)


### Install the Dart plugin

To configure Dart support, start by installing the plugin:

1. Start the IDE.
2. From the Welcome screen, choose **Plugins**.
3. Search for **Dart**.
4. Install the plugin and restart the IDE.


### Create a new Dart project

To create a new project:

1. From the Welcome screen, click **New Project**.
2. In the next dialog, click **Dart**.
3. If you don't see a value for the **Dart SDK** path,
   enter or select it.

   For example, the SDK path might be
   `<dart installation directory>/dart/dart-sdk`.

   :::note
   The **Dart SDK** path is the directory containing
   the `bin` and `lib` directories.
   The `bin` directory contains tools such as `dart` and `dartaotruntime`.
   The IDE validates that the selected path is correct.
   :::

4. Choose a starting template.
   1. To enable starting templates, click **Generate sample content**.
   2. Pick your desired template.

5. Click **Next** and continue project setup.


### Open an existing Dart project

To work on an existing Dart application, open the project in the IDE and enable Dart support.

#### Open the project

1. From the Welcome screen, click **Open** or **Import**.
   Alternatively, select **File | Open** from the main menu.
2. Select the folder containing your Dart project.

#### Enable Dart support

1. Open **Settings** (`Cmd` + `,`) and choose **Dart** under **Languages and Frameworks**. This will open the Dart page.
2. Check **Enable Dart support for the project &lt;project name&gt;**.
3. Verify the **Dart SDK Path**.
   The IDE usually detects this automatically.
   If not, manually select the directory containing the Dart SDK.
4. Under **Enable Dart support for the following modules**,
   select the modules that require Dart functionality.


### Work with multiple Dart projects (packages)

To work with multiple Dart projects (packages) in a single IntelliJ IDEA project,
add the additional project's root folder as a content root or as a new module.

1. Go to the [Modules page](https://www.jetbrains.com/help/idea/modules-page.html)
    (**File | Project Structure | Modules**) and add a content root as described in
    [Adding a content root](https://www.jetbrains.com/help/idea/content-roots.html#adding_content_root).

2.  Select **File | New | Module from Existing Sources**
    and select the relevant module in the dialog that opens.

### Configure syntax highlighting

You can customize Dart syntax highlighting to match your preferences.

1. Open **Settings** (`Cmd` + `,`) and go to **Editor | Color Scheme | Dart**.
2. Select a color scheme, or customize the default settings as described in
   [Colors and fonts](https://www.jetbrains.com/help/idea/configuring-colors-and-fonts.html).

## Report issues

Please report issues and feedback via the
[IntelliJ issue tracker][]. Include details of the 
expected behavior, the actual behavior, and screenshots if appropriate.

[IntelliJ issue tracker]: https://github.com/flutter/flutter-intellij/issues

## More information

See the JetBrains website for more information.

* [IntelliJ IDEA](https://www.jetbrains.com/idea/)
  * [Dart WebStorm Help](https://www.jetbrains.com/help/webstorm/dart.html)
  * [Features](https://www.jetbrains.com/idea/features/)
  * [Quick start](https://www.jetbrains.com/help/idea/getting-started.html)
* [Flutter Plugin for IntelliJ](https://github.com/flutter/flutter-intellij)