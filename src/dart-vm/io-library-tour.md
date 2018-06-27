---
layout: default
title: "A Tour of the dart:io Library"
description: Learn about the dart:io library and APIs.
permalink: /dart-vm/io-library-tour
---
<?code-excerpt plaster="none"?>

The [dart:io][] library provides APIs to deal with
files, directories, processes, sockets, WebSockets, and HTTP
clients and servers.

<div class="alert alert-warning" markdown="1">
  **Important:**
  Only [Flutter mobile apps]({{site.flutter}}), command-line scripts, and servers
  can import and use `dart:io`, not web apps.
</div>

In general, the dart:io library implements and promotes an asynchronous
API. Synchronous methods can easily block an application, making it
difficult to scale. Therefore, most operations return results via Future
or Stream objects, a pattern common with modern server platforms such as
Node.js.

The few synchronous methods in the dart:io library are clearly marked
with a Sync suffix on the method name. Synchronous methods aren't covered here.

To use the dart:io library you must import it:
<?code-excerpt "misc/test/library_tour/io_test.dart (import)"?>
{% prettify dart %}
import 'dart:io';
{% endprettify %}

## Files and directories

The I/O library enables command-line apps to read and write files and
browse directories. You have two choices for reading the contents of a
file: all at once, or streaming. Reading a file all at once requires
enough memory to store all the contents of the file. If the file is very
large or you want to process it while reading it, you should use a
Stream, as described in
[Streaming file contents](#streaming-file-contents).

### Reading a file as text

When reading a text file encoded using UTF-8, you can read the entire
file contents with `readAsString()`. When the individual lines are
important, you can use `readAsLines()`. In both cases, a Future object
is returned that provides the contents of the file as one or more
strings.

<?code-excerpt "misc/test/library_tour/io_test.dart (readAsString)" replace="/\btest_data\///g"?>
{% prettify dart %}
Future main() async {
  var config = File('config.txt');
  var contents;

  // Put the whole file in a single string.
  contents = await config.readAsString();
  print('The file is ${contents.length} characters long.');

  // Put each line of the file into its own string.
  contents = await config.readAsLines();
  print('The file is ${contents.length} lines long.');
}
{% endprettify %}


### Reading a file as binary

The following code reads an entire file as bytes into a list of ints.
The call to `readAsBytes()` returns a Future, which provides the result
when it’s available.

<?code-excerpt "misc/test/library_tour/io_test.dart (readAsBytes)" replace="/\btest_data\///g"?>
{% prettify dart %}
Future main() async {
  var config = File('config.txt');

  var contents = await config.readAsBytes();
  print('The file is ${contents.length} bytes long.');
}
{% endprettify %}

### Handling errors

To capture errors so they don't result in uncaught exceptions, you can
register a `catchError` handler on the Future,
or (in an async function) use try-catch:

<?code-excerpt "misc/test/library_tour/io_test.dart (try-catch)" replace="/does-not-exist/config/g"?>
{% prettify dart %}
Future main() async {
  var config = File('config.txt');
  try {
    var contents = await config.readAsString();
    print(contents);
  } catch (e) {
    print(e);
  }
}
{% endprettify %}

### Streaming file contents

Use a Stream to read a file, a little at a time.
You can use either the [Stream API](/guides/libraries/library-tour#stream)
or `await for`, part of Dart's
[asynchrony support.](/guides/language/language-tour#asynchrony-support)

<?code-excerpt "misc/test/library_tour/io_test.dart (read-from-stream)" replace="/_?test_\w*\/?//g"?>
{% prettify dart %}
import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future main() async {
  var config = File('config.txt');
  Stream<List<int>> inputStream = config.openRead();

  var lines = inputStream
      .transform(utf8.decoder)
      .transform(LineSplitter());
  try {
    await for (var line in lines) {
      print('Got ${line.length} characters from stream');
    }
    print('file is now closed');
  } catch (e) {
    print(e);
  }
}
{% endprettify %}

### Writing file contents

You can use an [IOSink][] to
write data to a file. Use the File `openWrite()` method to get an IOSink
that you can write to. The default mode, `FileMode.write`, completely
overwrites existing data in the file.

<?code-excerpt "misc/test/library_tour/io_test.dart (write-file)" replace="/\btest_data\///g"?>
{% prettify dart %}
var logFile = File('log.txt');
var sink = logFile.openWrite();
sink.write('FILE ACCESSED ${DateTime.now()}\n');
await sink.flush();
await sink.close();
{% endprettify %}

To add to the end of the file, use the optional `mode` parameter to
specify `FileMode.append`:

<?code-excerpt "misc/test/library_tour/io_test.dart (append)" replace="/_?test_\w*\/?//g"?>
{% prettify dart %}
var sink = logFile.openWrite(mode: FileMode.append);
{% endprettify %}

To write binary data, use `add(List<int> data)`.


### Listing files in a directory

Finding all files and subdirectories for a directory is an asynchronous
operation. The `list()` method returns a Stream that emits an object
when a file or directory is encountered.

<?code-excerpt "misc/test/library_tour/io_test.dart (list-dir)" replace="/\btest_data\b/tmp/g"?>
{% prettify dart %}
Future main() async {
  var dir = Directory('tmp');

  try {
    var dirList = dir.list();
    await for (FileSystemEntity f in dirList) {
      if (f is File) {
        print('Found file ${f.path}');
      } else if (f is Directory) {
        print('Found dir ${f.path}');
      }
    }
  } catch (e) {
    print(e.toString());
  }
}
{% endprettify %}


### Other common functionality

The File and Directory classes contain other functionality, including
but not limited to:

-   Creating a file or directory: `create()` in File and Directory
-   Deleting a file or directory: `delete()` in File and Directory
-   Getting the length of a file: `length()` in File
-   Getting random access to a file: `open()` in File

Refer to the API docs for [File][] and [Directory][] for a full
list of methods.


## HTTP clients and servers

The dart:io library provides classes that command-line apps can use for
accessing HTTP resources, as well as running HTTP servers.

### HTTP server

The [HttpServer][] class
provides the low-level functionality for building web servers. You can
match request handlers, set headers, stream data, and more.

The following sample web server returns simple text information.
This server listens on port 8888 and address 127.0.0.1 (localhost),
responding to requests for the path `/dart`. For any other path,
the response is status code 404 (page not found).

<?code-excerpt "misc/lib/library_tour/io/http_server.dart" replace="/\b_//g"?>
{% prettify dart %}
Future main() async {
  final requests = await HttpServer.bind('localhost', 8888);
  await for (var request in requests) {
    processRequest(request);
  }
}

void processRequest(HttpRequest request) {
  print('Got request for ${request.uri.path}');
  final response = request.response;
  if (request.uri.path == '/dart') {
    response
      ..headers.contentType = ContentType(
        'text',
        'plain',
      )
      ..write('Hello from the server');
  } else {
    response.statusCode = HttpStatus.notFound;
  }
  response.close();
}
{% endprettify %}

### HTTP client

The [HttpClient][] class
helps you connect to HTTP resources from your Dart command-line or
server-side application. You can set headers, use HTTP methods, and read
and write data. The HttpClient class does not work in browser-based
apps. When programming in the browser, use the
[dart:html HttpRequest class.][HttpRequest]
Here’s an example of using HttpClient:

<?code-excerpt "misc/test/library_tour/io_test.dart (client)"?>
{% prettify dart %}
Future main() async {
  var url = Uri.parse('http://localhost:8888/dart');
  var httpClient = HttpClient();
  var request = await httpClient.getUrl(url);
  var response = await request.close();
  var data = await response.transform(utf8.decoder).toList();
  print('Response ${response.statusCode}: $data');
  httpClient.close();
}
{% endprettify %}


## More information

This page showed how to use the major features of the [dart:io][] library.
Besides the APIs discussed in this section, the dart:io library also
provides APIs for [processes,][Process] [sockets,][Socket] and
[web sockets.][WebSocket]
To find more examples of using dart:io, go to the
[dart-samples repo.](https://github.com/dart-lang/dart-samples)
For more information about the Dart VM, see the
[VM overview.](/dart-vm)

For information on other dart:* libraries, see the
[library tour.][library tour]


[library tour]: /guides/libraries/library-tour
[dart:io]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/dart-io-library.html
[Directory]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Directory-class.html
[File]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/File-class.html
[HttpClient]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpClient-class.html
[HttpRequest]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/HttpRequest-class.html
[HttpServer]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpServer-class.html
[IOSink]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/IOSink-class.html
[Process]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Process-class.html
[Socket]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Socket-class.html
[WebSocket]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/WebSocket-class.html
