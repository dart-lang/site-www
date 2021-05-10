---
title: Dart DevTools
description: A suite of debugging and performance tools.
---

Dart DevTools is a suite of debugging and performance tools
for Dart and Flutter.
These tools are distributed in IDEs, the `flutter` tool, the `webdev` tool,
and the [devtools package.][devtools package]

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
      <th scope="col" markdown="1">[Flutter mobile or desktop][]</th>
      <th scope="col" markdown="1">[Flutter web][]</th>
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


## Using DevTools with a Flutter app

For details on using DevTools with a Flutter app for any platform
(including web) see the
[DevTools documentation on flutter.dev.][flutter-devtools]

[flutter-devtools]: {{site.flutter}}/docs/development/tools/devtools/overview


## Using DevTools with a non-Flutter web app

To launch a web app so that you can use Dart DevTools,
use the `webdev serve` command with the `--debug` or `--debug-extension` flag:

```terminal
$ webdev serve --debug
```

For more information, see [Debugging Dart web apps][].


## Using DevTools with a command-line app

You can use DevTools to perform source-level debugging 
or to view general log and diagnostics information
for a running command-line app.

### 1. Install DevTools

Use [pub](/tools/pub) to install or update DevTools:

```terminal
$ dart pub global activate devtools
```

### 2. Launch the DevTools server

Once you have DevTools, use the `devtools` command
to run the local web server for DevTools:

```terminal
$ dart pub global run devtools
Serving DevTools at http://127.0.0.1:9100
```

{{site.alert.note}}
  If the [system cache `bin` directory is in your path][cache-bin],
  then you can just run `dart devtools`, without `dart pub global run`.
{{site.alert.end}}
[cache-bin]: /tools/pub/cmd/pub-global#running-a-script-from-your-path


### 3. Start the target app

Use the `dart run --observe` command to execute the main file
for the Dart command-line app that you want to debug or observe.
Optionally add `--pause-isolates-on-start`,
which automatically breaks execution at the start of the script.

```terminal
$ cd path/to/dart/app
$ dart run --observe main.dart

Observatory listening on http://127.0.0.1:8181/wYDP3x9mvbw=/
```

**Note the "listening" URL.**
You'll need this URL in the next step.

{{site.alert.important}}
  This URL contains a security token and
  is different for each run of your app.
  If you stop your app and rerun it,
  then you need to connect to DevTools with the new "listening" URL.
{{site.alert.end}}

### 4. Open DevTools and connect to the target app

1. Open Chrome browser window and navigate to `http://localhost:9100`.
2. Paste the "listening" URL into the text field
   under **Connect to a running app**, and click the **Connect** button.

![DevTools connection dialog]({% asset tools/devtools-connect.png @path %})


## Resources

* [Using DevTools for Flutter development][Flutter mobile or desktop]
* [devtools package page][devtools package]


[App size tool]: {{site.flutter}}/docs/development/tools/devtools/app-size
[Chrome DevTools.]: https://developers.google.com/web/tools/chrome-devtools
[Command-line]: #using-devtools-with-a-command-line-app
[CPU profiler]: https://flutter.dev/docs/development/tools/devtools/cpu-profiler
[Debugger]: {{site.flutter}}/docs/development/tools/devtools/debugger
[Debugging Dart web apps]: /web/debugging
[devtools package]: {{site.pub-pkg}}/devtools
[Flutter inspector]: {{site.flutter}}/docs/development/tools/devtools/inspector
[Flutter mobile or desktop]: {{site.flutter}}/docs/development/tools/devtools/overview
[Flutter web]: {{site.flutter}}/docs/development/tools/devtools/overview
[Logging view]: {{site.flutter}}/docs/development/tools/devtools/logging
[Memory view]: {{site.flutter}}/docs/development/tools/devtools/memory
[Network view]: {{site.flutter}}/docs/development/tools/devtools/network
[Other web]: #using-devtools-with-a-non-flutter-web-app
[Performance view]: {{site.flutter}}/docs/development/tools/devtools/performance
[Timeline view]: {{site.flutter}}/docs/development/tools/devtools/timeline
