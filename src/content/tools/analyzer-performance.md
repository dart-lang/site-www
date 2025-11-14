---
title: Troubleshoot Analyzer Performance
description: Help users with analyzer performance issues.
---

This guide helps you diagnose and resolve common Dart analysis server 
performance issues in your Dart or Flutter IDE.

## Known Performance Issues

Several common issues significantly hurt the performance of 
the Dart analysis server (the analyzer).
Check the following issues to see if they might be impacting 
your development environment.

### Security Software (Windows)

On Windows systems, if Windows Defender (or other real-time security software) 
is enabled, it can slow down the file read times enough 
to impact analyzer performance. The analyzer frequently reads files, 
and constant scanning can introduce latency. To mitigate this, 
you can set up exclusions for the directories the analyzer reads from.

:::warning
Excluding directories from security scans might diminish the 
protection that your antivirus software provides.
Proceed with caution.
:::

If you choose to set up exclusions, include the following directories:

* The analysis server's cache directory: `%LOCALAPPDATA%\.dartServer`
* The directory for packages downloaded by pub: `%LOCALAPPDATA%\Pub\Cache`
* Any other directories containing code for your applications.

For another way to improve file I/O performance, 
consider setting up a [dev drive](https://devblogs.microsoft.com/visualstudio/devdrive/).

### Symbolic links

If your package directory contains symbolic links that point 
to a location inside the same directory, or to a parent directory, 
you may experience performance problems with Dart tooling (like the analyzer).

**Status:** The Dart team is actively working on a fix for this issue.

**Workaround:** There are no known workarounds at this time.

## Report unknown issues

If the known issues don't seem to apply to your situation, 
please open an issue in the [Dart SDK issue tracker](https://github.com/dart-lang/sdk/issues). 
The more information you provide, the faster the team can diagnose and fix
the problem.

###  Include reproduction steps

In your issue, please provide detailed steps to reproduce the behavior you're observing.

* If you're working on an open-source project, include instructions 
    for downloading the code.
* If you can't share your code, create a small, self-contained reproduction case.
* If you can't provide either, please state that in the issue.

### Provide performance data

If the issue is related to performance, providing performance data 
can be very helpful. You can collect this data using the 
analysis server's diagnostic pages:

1. **Open the Analyzer Diagnostics page:**
    * **VS Code:** Open the `Command Palette` (View > Command Palette...), 
        then type and select `Dart: Open Analyzer Diagnostics`.
    * **IntelliJ / Android Studio:** Open the `Dart Analysis` tool window, 
        click the settings icon, and select `View analyzer diagnostics`.
2. **Collect the report:**
    * In the browser page that opens, click `Collect Report` in the top banner.
    * Perform the actions that trigger the slow behavior.
    * Click the `Download report` link.
3. **Attach the report to your issue:** While the report shouldn't contain 
    personal or proprietary information, 
    review it before submitting it. 

### Capture instrumentation logs

In some cases, instrumentation logs can provide additional 
details for diagnosing issues.

To capture these logs:

* **VS Code:** Follow the instructions for [capturing analyzer instrumentation logs in Dart-Code](https://dartcode.org/docs/logging/#analyzer-instrumentation).
* **IntelliJ / Android Studio:** Follow the [Analyzer Instrumentation instructions for IntelliJ / Android Studio](https://github.com/dart-lang/sdk/blob/main/pkg/analysis_server/doc/tutorial/instrumentation.md#intellij-idea-and-android-studio).

Before attaching logs to a GitHub issue, review them carefully 
to ensure they do not contain any personal, sensitive, or proprietary information.