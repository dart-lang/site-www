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

{% assign y = '<span class="material-icons" title="supported">done</span>' %}
{% assign b = '&nbsp;' %}
{% assign na = '&nbsp;' %}
{% comment %}
  Considered using this instead:
  assign b = '<span class="material-icons" title="use browser tools instead">web</span>'
{% endcomment %}

<div class="table-wrapper" markdown="1">
<table class="table table-striped" markdown="1">
  <thead>
    <tr markdown="1">
      <th>&nbsp;</th>
      <th scope="col" markdown="1">[Flutter mobile or desktop][Flutter devtools]</th>
      <th scope="col" markdown="1">[Flutter web][Flutter devtools]</th>
      <th scope="col" markdown="1">[Other web][]</th>
      <th scope="col" markdown="1">[Command-line][]</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row" markdown="1">[Debugger][]</th>
      <td>{{y}}</td> <!-- fma -->
      <td>{{y}}</td> <!-- fwa -->
      <td>{{y}}</td> <!-- owa -->
      <td>{{y}}</td> <!-- cla -->
    </tr>
    <tr>
      <th scope="row" markdown="1">[Logging view][]</th>
      <td>{{y}}</td> <!-- fma -->
      <td>{{y}}</td> <!-- fwa -->
      <td>{{y}}</td> <!-- owa -->
      <td>{{y}}</td> <!-- cla -->
    </tr>
    <tr>
      <th scope="row" markdown="1">[App size tool][]</th>
      <td>{{y}}</td> <!-- fma -->
      <td>{{b}}</td> <!-- fwa -->
      <td>{{b}}</td> <!-- owa -->
      <td>{{y}}</td> <!-- cla -->
    </tr>
    <tr>
      <th scope="row" markdown="1">[CPU profiler][]</th>
      <td>{{y}}</td> <!-- fma -->
      <td>{{b}}</td> <!-- fwa -->
      <td>{{b}}</td> <!-- owa -->
      <td>{{y}}</td> <!-- cla -->
    </tr>
    <tr>
      <th scope="row" markdown="1">[Memory view][]</th>
      <td>{{y}}</td> <!-- fma -->
      <td>{{b}}</td> <!-- fwa -->
      <td>{{b}}</td> <!-- owa -->
      <td>{{y}}</td> <!-- cla -->
    </tr>
    <tr>
      <th scope="row" markdown="1">[Network view][]</th>
      <td>{{y}}</td> <!-- fma -->
      <td>{{b}}</td> <!-- fwa -->
      <td>{{b}}</td> <!-- owa -->
      <td>{{y}}</td> <!-- cla -->
    </tr>
    <tr>
      <th scope="row" markdown="1">[Performance view][]</th>
      <td>{{y}}</td> <!-- fma -->
      <td>{{b}}</td> <!-- fwa -->
      <td>{{b}}</td> <!-- owa -->
      <td>{{y}}</td> <!-- cla -->
    </tr>
    <tr>
      <th scope="row" markdown="1">[Flutter inspector][]</th>
      <td>{{y}}</td> <!-- fma -->
      <td>{{y}}</td> <!-- fwa -->
      <td>{{b}}</td> <!-- owa -->
      <td>{{na}}</td> <!-- cla -->
    </tr>
  </tbody>
</table>
</div>

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

```terminal
$ cd path/to/dart/app
$ dart run --pause-isolates-on-start --observe main.dart

The Dart VM service is listening on http://127.0.0.1:8181/afZySiNbDPg=/
The Dart DevTools debugger and profiler is available at: http://127.0.0.1:8181/afZySiNbDPg=/devtools/#/?uri=ws%3A%2F%2F127.0.0.1%3A8181%2FafZySiNbDPg%3D%2Fws
```

Note the **Dart DevTools debugger and profiler** URL.
You'll need it in the next step.

{{site.alert.important}}
  This URL contains a security token and
  is different for each run of your app.
  If you stop your app and rerun it,
  then you need to connect to DevTools with the new URL.
{{site.alert.end}}

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

```terminal
$ webdev serve --debug
```

For more information, see [Debugging Dart web apps][].

[App size tool]: {{site.flutter-docs}}/development/tools/devtools/app-size
[Chrome DevTools.]: https://developer.chrome.com/docs/devtools/
[Command-line]: #using-devtools-with-a-command-line-app
[CPU profiler]: {{site.flutter-docs}}/development/tools/devtools/cpu-profiler
[Debugger]: {{site.flutter-docs}}/development/tools/devtools/debugger
[Debugging Dart web apps]: /web/debugging
[Flutter inspector]: {{site.flutter-docs}}/development/tools/devtools/inspector
[Flutter devtools]: {{site.flutter-docs}}/development/tools/devtools/overview
[Logging view]: {{site.flutter-docs}}/development/tools/devtools/logging
[Memory view]: {{site.flutter-docs}}/development/tools/devtools/memory
[Network view]: {{site.flutter-docs}}/development/tools/devtools/network
[Other web]: #using-devtools-with-a-non-flutter-web-app
[Performance view]: {{site.flutter-docs}}/development/tools/devtools/performance
[Timeline view]: {{site.flutter-docs}}/development/tools/devtools/timeline
