---
title: "An introduction to the dart:io library"
description: An introduction to the Dart I/O library, which is aimed at code that runs in Flutter and the standalone Dart VM.
original-date: 2012-03-01
date: 2018-09-04
category: libraries
---

_Written by Mads Ager<br>
March 2012 (updated September 2018)_

The [dart:io]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/dart-io-library.html) library
is aimed at code that runs in Flutter and the standalone Dart VM.
In this article we will give you a feel for
what is currently possible with dart:io
by going through a couple of examples.

<aside class="alert alert-info" markdown="1">
  **Note:**
  When writing a Flutter app, use
  [Flutter-specific APIs]({{site.flutter_api}})
  instead of dart:io whenever possible. For example, use the
  [Flutter asset support]({{site.flutter}}/assets-and-images) to load
  images and other assets into your app.
</aside>

Dart is a single-threaded programming language.
If an operation blocks the Dart thread,
the application makes no progress before that operation completes.
For scalability it is therefore crucial that no I/O operations block.
Instead of blocking on I/O operations,
dart:io uses an asynchronous programming model inspired by
[node.js,](http://nodejs.org)
[EventMachine,](https://github.com/eventmachine/eventmachine/wiki) and
[Twisted.](http://twistedmatrix.com/trac/)

## The Dart VM and the event loop

Before we dive into asynchronous I/O operations,
it might be useful to explain how the standalone Dart VM operates.

When executing a server-side application,
the Dart VM runs in an event loop with
an associated event queue of pending asynchronous operations.
The VM terminates when it has executed the current code to completion
and no more pending operations are in the queue.

One simple way to add an event to the event queue is to
schedule a function to be called in the future.
You can do this by creating a
[Timer]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Timer-class.html) object.
The following example registers a timer with the event queue
and then drops off the end of `main()`.
Because a pending operation is in the event queue,
the VM does not terminate at that point.
After one second,
the timer fires and the code in the argument callback executes.
Once that code executes to completion,
no more pending operations are in the event queue
and the VM terminates.

<?code-excerpt "misc/lib/articles/io/io_timer_test.dart"?>
{% prettify dart %}
import 'dart:async';

void main() {
  Timer(Duration(seconds: 1), () => print('timer'));
  print('end of main');
}
{% endprettify %}

Running this example at the command line, we get:

```terminal
$ dart timer.dart
end of main
timer
```

Had we made the timer repeating by using the
[Timer.periodic]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Timer/Timer.periodic.html) constructor,
the VM would not terminate
and would continue to print out 'timer' every second.

## File system access

The dart:io library provides access to files and directories through the
[File]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/File-class.html) and
[Directory]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Directory-class.html) classes.

The following example prints its own source code.
To determine the location of the source code being executed,
we use the
[Platform]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Platform-class.html)
class.


<?code-excerpt "misc/lib/articles/io/io_file_system_test.dart"?>
{% prettify dart %}
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  var file = File(Platform.script.toFilePath());
  print("${await (file.readAsString(encoding: ascii))}");
}
{% endprettify %}

Notice that the `readAsString()` method is asynchronous;
it returns a [Future]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future-class.html)
that returns the contents of the file
once the file has been read from the underlying system.
This asynchronicity allows the Dart thread to perform other work
while waiting for the I/O operation to complete.

To illustrate more detailed file operations,
let's change the example to read the contents
only up to the first semicolon and then to print that.
You could do this in two ways:
either open the file for random access,
or open a
[Stream]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Stream-class.html)
for the file and stream in the data.

Here is a version that opens the file for random access operations.
The code opens the file for reading and then reads one byte at a time
until it encounters the char code for `;`.

<?code-excerpt "misc/lib/articles/io/io_random_access_test.dart"?>
{% prettify dart %}
import 'dart:io';

Future<void> main() async {
  final semicolon = ';'.codeUnitAt(0);
  var result = <int>[];

  final script = File(Platform.script.toFilePath());
  RandomAccessFile file = await script.open(mode: FileMode.read);

  // Deal with each byte.
  while (true) {
    final byte = await file.readByte();
    result.add(byte);
    if (byte == semicolon) {
      print(String.fromCharCodes(result));
      await file.close();
      break;
    }
  }
}
{% endprettify %}

When you see a use of `async` or `await`, you are seeing a Future in action.
Both the `open()` and `readByte()` methods return a Future object.

This code is, of course,
a very simple use of random-access operations.
Operations are available for writing,
seeking to a given position, truncating, and so on.

Let's implement a version using a stream.
The following code opens the file for reading presenting the content
as a stream of lists of bytes. Like all streams in Dart you listen on
this stream (using `await for`) and the data is given in chunks.

<?code-excerpt "misc/lib/articles/io/io_stream_test.dart"?>
{% prettify dart %}
import 'dart:io';

Future<void> main() async {
  var result = <int>[];

  Stream<List<int>> stream = File(Platform.script.toFilePath()).openRead();
  final semicolon = ';'.codeUnitAt(0);

  await for (var data in stream) {
    for (int i = 0; i < data.length; i++) {
      result.add(data[i]);
      if (data[i] == semicolon) {
        print(String.fromCharCodes(result));
        return;
      }
    }
  }
}
{% endprettify %}

The stream subscription is implicitly handled by `await for`.
Exiting the `await for` statement — using `break`, `return`, or an uncaught exception —
cancels the subscription.

`Stream<List<int>>` is used in multiple places in dart:io:
when working with stdin, files, sockets, HTTP connections, and so on.
Similarly, [IOSink]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/IOSink-class.html) objects
are used to stream data to
stdout, files, sockets, HTTP connections, and so on.

## Interacting with processes

For the simple case, use
[Process.run()]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Process/run.html)
to run a process
and collect its output. Use `run()` when you don't
need interactive control over the process.

<?code-excerpt "misc/lib/articles/io/io_process_test.dart"?>
{% prettify dart %}
import 'dart:io';

Future<void> main() async {
  // List all files in the current directory,
  // in UNIX-like operating systems.
  ProcessResult results = await Process.run('ls', ['-l']);
  print(results.stdout);
}
{% endprettify %}

You can also start a process by creating a
[Process]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Process-class.html) object
using
[Process.start().]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Process/start.html)

Once you have a Process object you can interact with the process
by writing data to its stdin sink,
reading data from its stderr and stdout streams,
and killing the process.
When the process exits, the `exitCode` future completes with
the exit code of the process.

The following example runs `ls -l` in a separate process
and prints the output and the exit code for the process to stdout.
Since we are interested in getting lines,
we use a
[Utf8Decoder]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/Utf8Decoder-class.html)
(which decodes chunks of bytes into strings) followed by a
[LineSplitter]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/LineSplitter-class.html)
(which splits the strings at line boundaries).

<?code-excerpt "misc/lib/articles/io/io_process_transform_test.dart"?>
{% prettify dart %}
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final process = await Process.start('ls', ['-l']);
  var lineStream =
      process.stdout.transform(Utf8Decoder()).transform(LineSplitter());
  await for (var line in lineStream) {
    print(line);
  }

  await process.stderr.drain();
  print('exit code: ${await process.exitCode}');
}
{% endprettify %}

Notice that `exitCode` can complete before all of the lines of output
have been processed. Also note
that we do not explicitly close the process. In order to
not leak resources we have to listen to both the stderr and stdout
streams. We use `await for` to listen to stdout,
and `stderr.drain()` to listen to (and discard) stderr.

Instead of printing the output to stdout,
we can use the streaming classes
to pipe the output of the process to a file.

<?code-excerpt "misc/lib/articles/io/io_process_stdio_test.dart"?>
{% prettify dart %}
import 'dart:io';

Future<void> main() async {
  final output = File('output.txt').openWrite();
  Process process = await Process.start('ls', ['-l']);

  // Wait for the process to finish; get the exit code.
  final exitCode = (await Future.wait([
    process.stdout.pipe(output), // Send stdout to file.
    process.stderr.drain(), // Discard stderr.
    process.exitCode
  ]))[2];

  print('exit code: $exitCode');
}
{% endprettify %}


## Writing web servers

dart:io makes it easy to write HTTP servers and clients.
To write a simple web server,
all you have to do is create an
[HttpServer]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpServer-class.html)
and hook up a listener (using `await for`) to its stream of `HttpRequest`s.

Here is a simple web server
that just answers 'Hello, world' to any request.

<?code-excerpt "misc/lib/articles/io/io_http_server_test.dart"?>
{% prettify dart %}
import 'dart:io';

Future<void> main() async {
  final server = await HttpServer.bind('127.0.0.1', 8082);
  await for (HttpRequest request in server) {
    request.response.write('Hello, world');
    await request.response.close();
  }
}
{% endprettify %}

Running this application
and pointing your browser to 'http://127.0.0.1:8082'
gives you 'Hello, world' as expected.

Let's add a bit more and actually serve files.
The base path for every file that we serve will be
the location of the script.
If no path is specified in a request we will serve index.html.
For a request with a path,
we will attempt to find the file and serve it.
If the file is not found we will respond with a '404 Not Found' status.
We make use of the streaming interface
to pipe all the data read from a file directly to the response stream.

<?code-excerpt "misc/lib/articles/io/io_http_server_file_test.dart"?>
{% prettify dart %}
import 'dart:io';

Future<void> runServer(String basePath) async {
  final server = await HttpServer.bind('127.0.0.1', 8082);
  await for (HttpRequest request in server) {
    await handleRequest(basePath, request);
  }
}

Future<void> handleRequest(String basePath, HttpRequest request) async {
  final String path = request.uri.toFilePath();
  // PENDING: Do more security checks here.
  final String resultPath = path == '/' ? '/index.html' : path;
  final File file = File('$basePath$resultPath');
  if (await file.exists()) {
    try {
      await file.openRead().pipe(request.response);
    } catch (exception) {
      print('Error happened: $exception');
      await sendInternalError(request.response);
    }
  } else {
    await sendNotFound(request.response);
  }
}

Future<void> sendInternalError(HttpResponse response) async {
  response.statusCode = HttpStatus.internalServerError;
  await response.close();
}

Future<void> sendNotFound(HttpResponse response) async {
  response.statusCode = HttpStatus.notFound;
  await response.close();
}

Future<void> main() async {
  // Compute base path for the request based on the location of the
  // script, and then start the server.
  final script = File(Platform.script.toFilePath());
  await runServer(script.parent.path);
}
{% endprettify %}

Writing HTTP clients is very similar to using the
[HttpClient]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpClient-class.html)
class.


## Feature requests welcome

The dart:io library is already capable of performing a lot of tasks.
For example, the [Pub site]({{site.pub}}) uses dart:io.

Please give dart:io a spin and let us know what you think.
Feature requests are very welcome!
When you file a bug or feature request,
use [dartbug.com.](http://dartbug.com)
To find reported issues, search for the
[library-io label.](https://github.com/dart-lang/sdk/issues?q=label%3Alibrary-io)
