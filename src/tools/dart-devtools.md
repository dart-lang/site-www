---
title: Dart DevTools
description: A suite of debugging and performance tools.
---

Dart DevTools is a suite of debugging and performance tools
for Dart and Flutter.

## Using DevTools with a Flutter app

For details on using DevTools with a Flutter app, see the [Flutter
DevTools documentation.][flutter-devtools]

[flutter-devtools]: https://flutter.dev/docs/development/tools/devtools/overview

## Using DevTools with a command-line app

You can use DevTools to perform source-level debugging 
or to view general log and diagnostics information
for a running command-line app.

### 1. Install DevTools

Use [pub](/tools/pub) to install or update DevTools:

```terminal
$ pub global activate devtools
```

### 2. Launch the DevTools server

Once you have DevTools, use the `devtools` command
to run the local web server for DevTools:

```terminal
$ pub global run devtools
Serving DevTools at http://127.0.0.1.9100
```

{{site.alert.note}}
  If the [system cache `bin` directory is in your path][cache-bin],
  then you can just run `devtools`, without `pub global run`.
{{site.alert.end}}
[cache-bin]: /tools/pub/cmd/pub-global#running-a-script-from-your-path


### 3. Start the target app

Use the `dart --observe` command to execute the main file
for the Dart command-line app that you want to debug or observe:

```terminal
$ cd path/to/dart/app
$ dart --observe main.dart

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


