---
title: Dart DevTools
description: A suite of debugging and performance tools.
---

Dart DevTools is a suite of debugging and performance tools
for Dart and Flutter.
These tools are distributed as part of the `dart` tool
and interact with tools such as IDEs, `dart run`, and `webdev`.

<img src="/assets/img/tools/devtools.png" width="800" alt="Screenshot of DevTools' Memory page">

The following table shows which tools
you can use with common Dart app types.

{% assign y = '<span class="material-symbols user-select-none" title="Supported" aria-label="Supported">done</span>' %}
{% assign b = '&nbsp;' %}
{% assign na = '&nbsp;' %}
{% comment %}
  Considered using this instead:
  assign b = '<span class="material-symbols" title="use browser tools instead">web</span>'
{% endcomment %}

| Tool                  | [Flutter mobile or desktop][Flutter devtools] | [Flutter web][Flutter devtools] | [Other web][] | [Command-line][] |
|-----------------------|:---------------------------------------------:|:-------------------------------:|:-------------:|:----------------:|
| [Debugger][]          |                     {{y}}                     |              {{y}}              |     {{y}}     |      {{y}}       |
| [Logging view]        |                     {{y}}                     |              {{y}}              |     {{y}}     |      {{y}}       |
| [App size tool][]     |                     {{y}}                     |                                 |               |      {{y}}       |
| [CPU profiler][]      |                     {{y}}                     |                                 |               |      {{y}}       |
| [Memory view][]       |                     {{y}}                     |                                 |               |      {{y}}       |
| [Network view][]      |                     {{y}}                     |                                 |               |      {{y}}       |
| [Performance view][]  |                     {{y}}                     |                                 |               |      {{y}}       |
| [Flutter inspector][] |                     {{y}}                     |              {{y}}              |               |                  |

{:.table .table-striped .nowrap}

For information about using Dart DevTools with each app type
(for example, command-line apps),
click the app type in the top row.
For details about individual tools
(for example, the debugger),
click the tool name in the left column.

As the table shows, the debugger and the logging view
are the only parts of Dart DevTools that are available to all app types.
Web apps can't use the timeline, memory, and performance views;
instead, they can use browser tools such as the [Chrome DevTools.][]
The Flutter inspector works only for Flutter apps;
other web apps should use browser tools such as the Chrome DevTools.


## Using DevTools with a command-line app

You can use DevTools to perform source-level debugging 
or to view general log and diagnostics information
for a running command-line app.


### 1. Start the target app

Use the `dart run --observe` command to execute the main file
for the Dart command-line app that you want to debug or observe.
Optionally add `--pause-isolates-on-start`,
which automatically breaks execution at the start of the script.

```console
$ cd path/to/dart/app
$ dart run --pause-isolates-on-start --observe main.dart

The Dart VM service is listening on http://127.0.0.1:8181/afZySiNbDPg=/
The Dart DevTools debugger and profiler is available at: http://127.0.0.1:8181/afZySiNbDPg=/devtools/#/?uri=ws%3A%2F%2F127.0.0.1%3A8181%2FafZySiNbDPg%3D%2Fws
```

Note the **Dart DevTools debugger and profiler** URL.
You'll need it in the next step.

:::important
This URL contains a security token and
is different for each run of your app.
If you stop your app and rerun it,
then you need to connect to DevTools with the new URL.
:::

### 2. Open DevTools and connect to the target app

Copy the **Dart DevTools debugger and profiler** URL,
and paste it into the address bar of a Chrome browser window.

When you visit that URL in Chrome,
the Dart DevTools UI appears,
displaying information about the target app.
Click **Debugger** to start debugging the app.


## Using DevTools with a Flutter app

For details on using DevTools with a Flutter app for any platform
(including web) see the
[DevTools documentation on flutter.dev.][Flutter devtools]


## Using DevTools with a non-Flutter web app

To launch a web app so that you can use Dart DevTools,
use the `webdev serve` command with the `--debug` or `--debug-extension` flag:

```console
$ webdev serve --debug
```

For more information, see [Debugging Dart web apps][].

[App size tool]: {{site.flutter-docs}}/tools/devtools/app-size
[Chrome DevTools.]: https://developer.chrome.com/docs/devtools/
[Command-line]: #using-devtools-with-a-command-line-app
[CPU profiler]: {{site.flutter-docs}}/tools/devtools/cpu-profiler
[Debugger]: {{site.flutter-docs}}/tools/devtools/debugger
[Debugging Dart web apps]: /web/debugging
[Flutter inspector]: {{site.flutter-docs}}/tools/devtools/inspector
[Flutter devtools]: {{site.flutter-docs}}/tools/devtools/overview
[Logging view]: {{site.flutter-docs}}/tools/devtools/logging
[Memory view]: {{site.flutter-docs}}/tools/devtools/memory
[Network view]: {{site.flutter-docs}}/tools/devtools/network
[Other web]: #using-devtools-with-a-non-flutter-web-app
[Performance view]: {{site.flutter-docs}}/tools/devtools/performance
[Timeline view]: {{site.flutter-docs}}/tools/devtools/timeline
