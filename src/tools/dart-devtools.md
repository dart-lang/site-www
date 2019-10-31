---
title: Dart DevTools
description: A suite of debugging and performance tools.
toc: false
---

Dart DevTools is a suite of debugging and performance tools for Dart and
Flutter. In addition to [Flutter-specific features][Flutter DevTools documentation.],
DevTools supports source-level debugging of Dart apps, as well as viewing
general log and diagnostics information about a running app.

## Using DevTools with a command-line app

### Install DevTools

If you have `pub` on your path, you can run:

```console
$ pub global activate devtools
```

That command installs (or updates) DevTools on your machine.

### Launch the DevTools application server

Next, run the local web server, which serves the DevTools application itself. To
do that, run the following command. You should see output that looks something
like this:

```console
$ pub global run devtools

Serving DevTools at http://127.0.0.1.9100
```

### Start an application to debug

Next, start an app to connect to. Once the app starts, you'll see a message in
your terminal that looks like:

```console
$ cd path/to/dart/app
$ dart --observe main.dart

Observatory listening on http://127.0.0.1:8181/wYDP3x9mvbw=/
```

Keep note this URL, as you will use it to connect your app to DevTools.

### Open DevTools and connect to the target app

Once it's set up, using DevTools is as simple as opening a Chrome browser window
and navigating to `http://localhost:9100`.

Once DevTools opens, you should see a connect dialog:

![DevTools connection dialog]({% asset tools/devtools-connect.png @path %}){:width="100%"}

Paste the URL you got from running your app (in this example,
`http://127.0.0.1:8181/wYDP3x9mvbw=/`) into the connect dialog to connect your
app to DevTools.

This URL contains a security token, so it will be different for each run of your
app. This means that if you stop your application and re-run it, you need to
connect to DevTools with the new URL.


## Using DevTools with a Flutter app

For more information about using DevTools with a Flutter app, see the [Flutter
DevTools documentation.][]

[Flutter DevTools documentation.]: https://flutter.dev/docs/development/tools/devtools/overview
