---
title: "Cookbook: Dart by Example"
short-title: Cookbook
permalink: /dart-vm/dart-by-example
description: A cookbook, or set of examples, showing idiomatic Dart code.
---

The following examples are all stand-alone apps, such as servers, that run
from the command line. Most of the examples use the `dart:io` library, which is
used solely for command-line applications running on a stand-alone Dart VM.
<strong>The `dart:io` library does not work in browser-based
applications</strong>.
Many examples also use Pub packages.

<aside class="alert alert-info" markdown="1">
**Note:**
Many server-side APIs provide both asynchronous and synchronous ways to
accomplish a task. For example, to read a file as a string you can use either
the asynchronous `readAsString()` method from the File class, or its synchronous
counterpart, `readAsStringSync()`.
<strong>The examples below use only the asynchronous versions.</strong>
</aside>

See the
[source on Github](https://github.com/dart-lang/dart-samples/tree/master/dart_io_mini_samples).

After looking at the following code examples, refer to
[Write Command-line Apps](/tutorials/dart-vm/cmdline)
for additional information about I/O and command-line apps.


## Files, directories, and symlinks


### Deleting a file, directory, or symlink

Use the FilesSystemEntity `delete()` method to delete a file, directory, or
symlink. This method is inherited by File, Directory, and Link.

{% prettify dart %}
import 'dart:io';

main() async {
  // Create a temporary directory.
  var dir = await Directory.systemTemp.createTemp('my_temp_dir');

  // Confirm it exists.
  print(await dir.exists());

  // Delete the directory.
  await dir.delete();

  // Confirm it no longer exists.
  print(await dir.exists());
}
{% endprettify %}


### Renaming a file, directory, or symlink

Use the FileSystemEntity `rename()` method to change the name of a
file, directory or symlink. This method is inherited by
File, Directory, and Link.

{% prettify dart %}
import 'dart:io';

main() async {
  // Get the system temp directory.
  var systemTempDir = Directory.systemTemp;

  // Create a file.
  var file = await new File('${systemTempDir.path}/foo.txt').create();

  // Prints path ending with `foo.txt`.
  print('The path is ${file.path}');

  // Rename the file.
  await file.rename('${systemTempDir.path}/bar.txt');

  // Prints path ending with `bar.txt`.
  print('The path is ${file.path}');
}
{% endprettify %}


### Finding the type of a filesystem object

Use the `FileSystemEntity.type()` method to get the type of a file system
object. This method is inherited by File, Directory, and Link.

{% prettify dart %}
import 'dart:io';
import 'dart:async'; // Import not needed but added here to explicitly assign type for clarity below.

main() async {
  // List the contents of the system temp directory.
  Stream<FileSystemEntity> entityList =
      Directory.systemTemp.list(recursive: true, followLinks: false);

  await for (FileSystemEntity entity in entityList) {
    // Get the type of the FileSystemEntity, apply the appropiate label, and
    // print the entity path.
    FileSystemEntityType type = await FileSystemEntity.type(entity.path);

    String label;
    switch (type) {
      case FileSystemEntityType.DIRECTORY:
        label = 'D';
        break;
      case FileSystemEntityType.FILE:
        label = 'F';
        break;
      case FileSystemEntityType.LINK:
        label = 'L';
        break;
      default:
        label = 'UNKNOWN';
    }
    print('$label: ${entity.path}');
  }
}
{% endprettify %}


### Getting the parent directory

Use the FileSystemEntity `parent` property to get the parent of a
file, directory, or symlink. This property is inherited by File, Directory,
and Link.

{% prettify dart %}
import 'dart:io';
import 'dart:async'; // Import not needed but added here to explicitly assign type for clarity below.

main() async {
  // List the contents of the system temp directory.
  Stream<FileSystemEntity> entityList =
      Directory.systemTemp.list(recursive: true, followLinks: false);

  await for (FileSystemEntity entity in entityList) print(entity.parent.path);
}
{% endprettify %}


### Creating a file

Use the File `create()` method to create a file.
To create intermediate directories, set the `recursive` argument to
`true` (default is `false`).

{% prettify dart %}
import 'dart:io';

main() async {
  // Get the system temp directory.
  var systemTempDir = Directory.systemTemp;
  // Creates dir/, dir/subdir/, and dir/subdir/file.txt in the system
  // temp directory.
  var file = await new File('${systemTempDir.path}/dir/subdir/file.txt')
      .create(recursive: true);
  print(file.path);
}
{% endprettify %}


### Reading a file as a string

Use the File `readAsString()` method to read a file as a string.

{% prettify dart %}
import 'dart:io';

main() async {
  var contents = await new File('file.txt').readAsString();
  print(contents);
}
{% endprettify %}


### Reading a file as lines

Use the File `readAsLines()` method to read file contents as lines.

{% prettify dart %}
import 'dart:io';

main() async {
  List<String> lines = await new File('file.txt').readAsLines();
  lines.forEach((String line) => print(line));
}
{% endprettify %}


### Reading a file as bytes

Use the File `readAsBytes()` method to read file contents as bytes.

{% prettify dart %}
import 'dart:io';

import 'package:crypto/crypto.dart';

main() async {
  var bytes = await new File('file.txt').readAsBytes();
  // Do something with the bytes. For example, convert to base64.
  String base64 = CryptoUtils.bytesToBase64(bytes);
  print(base64);
}
{% endprettify %}


### Handling errors when reading a file


{% prettify dart %}
import 'dart:io';

main() async {
  final filename = 'non_existent_file.txt';
  try {
    var file = await new File(filename).readAsString();
    print(file);
  } catch (e) {
    print('There was a ${e.runtimeType} error');
    print('Could not read $filename');
  }
}
{% endprettify %}


### Writing a string to a file

Use the File object's `writeAsString()` method to write a string to a
file. After writing the string, the method closes the file.

{% prettify dart %}
import 'dart:io';

main() async {
  final filename = 'file.txt';
  var file = await new File(filename).writeAsString('some content');
  print("Content written to $file");
}
{% endprettify %}


### Writing bytes to a file

Use the File `writeAsBytes()` method to write bytes to a file.

{% prettify dart %}
import 'dart:io';
import 'dart:convert';

main() async {
  final string = 'Dart!';

  // Encode to UTF8.
  var encodedData = UTF8.encode(string);
  var file = await new File('file.txt');
  file.writeAsBytes(encodedData);
  var data = await file.readAsBytes();

  // Decode to a string, and print.
  print(UTF8.decode(data)); // Prints 'Dart!'.
}
{% endprettify %}


### Using a stream to write to a file

Use the File `openWrite()` method to create a new IOSink for a file, to
write to the file a little at a time.
To append to the file, set the `mode` argument to `FileMode.APPEND`
(it defaults to `FileMode.WRITE`).

{% prettify dart %}
import 'dart:io';

main() {
  var file = new File('file.txt');
  var sink = file.openWrite();
  sink.write('FILE ACCESSED ${new DateTime.now()}\n');

  // Close the IOSink to free system resources.
  sink.close();
}
{% endprettify %}


### Creating a directory

Use the Directory `create()` method to create a directory.
To create intermediate directories, set the `recursive` argument to `true`
(default is `false`).

{% prettify dart %}
import 'dart:io';

main() async {
  // Creates dir/ and dir/subdir/.
  var directory = await new Directory('dir/subdir').create(recursive: true);
  print(directory.path);
}
{% endprettify %}


### Creating a temp directory

Use the Directory `createTemp()` method to create a temporary directory.
This method appends random characters to the name of the directory to
produce a unique directory name.

{% prettify dart %}
import 'dart:io';

main() async {
  var directory = await Directory.systemTemp.createTemp('my_temp_dir');
  print(directory.path);
}
{% endprettify %}


### Listing the contents of a directory

Use the `list()` method to list a directory's contents.  The method recurses
into subdirectories if the `recursive` argument is `true` (default is
`false`). It does not follow symlinks if the `followLinks` argument is
`false` (default is `true`).

{% prettify dart %}
import 'dart:io';
import 'dart:async'; // Import not needed but added here to explicitly assign type for clarity below.

main() async {
  // Get the system temp directory.
  var systemTempDir = Directory.systemTemp;

  // List directory contents, recursing into sub-directories, but not following
  // symbolic links.
  Stream<FileSystemEntity> entityList =
      systemTempDir.list(recursive: true, followLinks: false);
  await for (FileSystemEntity entity in entityList) print(entity.path);
}
{% endprettify %}


### Creating a symlink

Use the Link `create()` method to create a symlink.

{% prettify dart %}
import 'dart:io';

main() async {
  // Get the system temp directory.
  var temp = await Directory.systemTemp.createTemp('my_temp_dir');

  // Generate a couple of paths.
  var first = '${temp.path}${Platform.pathSeparator}first';
  var second = '${temp.path}${Platform.pathSeparator}second';

  // Create a symlink.
  Link symLink = await new Link(second).create(first);
  print(symLink);
}
{% endprettify %}


### Checking if a path represents a symlink

Use the FileSystemEntity `isLink()` method to check if path represents
a symlink.

{% prettify dart %}
import 'dart:io';
import 'dart:async'; // Import not needed but added here to explicitly assign type for clarity below.

main() async {
  // Get the system temp directory.
  var systemTempDir = Directory.systemTemp;

  // List the contents of the system temp directory.
  Stream<FileSystemEntity> entityList =
      systemTempDir.list(recursive: true, followLinks: false);
  await for (FileSystemEntity entity in entityList) {
    // Print the path only if it represents a symlink.
    var isLink = await FileSystemEntity.isLink(entity.path);
    if (isLink) print(entity.path);
  }
}
{% endprettify %}


### Getting the target of a symlink

Use the Link `target()` method to get the path that the link points to.

{% prettify dart %}
import 'dart:async';
import 'dart:io';

// Creates temporary directory inside the system temp directory, creates a
// couple of paths in the created directory, and creates a symlink.
Future<Link> createSymLink() async {
  var temp = await Directory.systemTemp.createTemp('my_temp_dir');
  var first = '${temp.path}${Platform.pathSeparator}first';
  var second = '${temp.path}${Platform.pathSeparator}second';
  return new Link(second).create(first);
}

main() async {
  try {
    var link = await createSymLink();
    print(link.path);
    var targetPath = await link.target();
    print(targetPath);
  } catch (e) {
    print(e.message);
  }
}
{% endprettify %}


## HTTP requests and responses


### Making a GET request

Use the http package `get()` function to make a GET request.

{% prettify dart %}
import 'package:http/http.dart' as http;

main() async {
  var url = 'http://httpbin.org/';
  var response = await http.get(url);
  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}");
}
{% endprettify %}


### Making a POST request

Use the http package `post()` function to make a POST request.

{% prettify dart %}
import 'package:http/http.dart' as http;

main() async {
  var url = 'http://httpbin.org/post';
  var response = await http.post(url, body: 'name=doodle&color=blue');
  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}");
}
{% endprettify %}


### Adding custom headers to a request

Use the `headers` argument to the function used to make an HTTP request.
The example below adds a 'User-Agent' header to a `get` request.

{% prettify dart %}
import 'dart:convert';
import 'package:http/http.dart' as http;

main() async {
  var url = 'https://api.github.com/users/dart-lang/repos';
  var response =
      await http.get(url, headers: {'User-Agent': 'Dart/1.0 (My Dart client)'});

  List<String> repos = JSON.decode(response.body);
  var heading = 'Repository | Star count  | Fork count';
  print(heading);
  print(new List.filled(heading.length, '=').join());
  for (var repo in repos) {
    print("${repo['name']} | "
        "${repo['stargazers_count']} | "
        "${repo['forks_count']}");
  }
}
{% endprettify %}


### Making multiple requests to the same server

Use the `Client` class in the http Pub package for making multiple requests
to the same server. Using `Client` keeps a persistent connection open
to the server and is better than making multiple single requests.

{% prettify dart %}
import 'package:http/http.dart' as http;

printResponseBody(response) {
  print(response.body.length);
  if (response.body.length > 100) {
    print(response.body.substring(0, 100));
  } else {
    print(response.body);
  }
  print('...\n');
}

main() async {
  var url = 'http://www.google.com/';
  var client = new http.Client();
  try {
    var response = await client.get('$url/search');
    printResponseBody(response);
    response = await client.get('$url/doodles');
    printResponseBody(response);
  } finally {
    client.close();
  }
}
{% endprettify %}


### Handling errors when making a request

An HTTP request may return a response, or it may generate an error.

{% prettify dart %}
import 'package:http/http.dart' as http;

handleSuccess(http.Response response) {
  print('something went right!');
  print(response.body);
}

handleFailure(error) {
  print('Something went wrong.');
  print(error.message);
}

main() async {
  try {
    var response = await http.get("http://some_bogus_website.org");
    handleSuccess(response);
  } catch (e) {
    handleFailure(e);
  }
}
{% endprettify %}


### Getting redirection history

Use the `HttpClient` class in the 'dart:io' library to make a request, and
use the Response `redirects` property to get a list of the redirects.

{% prettify dart %}
import "dart:io" show HttpClient, RedirectInfo;

main() async {
  var client = new HttpClient();
  var request = await client.getUrl(Uri.parse('http://google.com'));
  var response = await request.close();
  List<RedirectInfo> redirects = response.redirects;
  redirects.forEach((redirect) {
    print(redirect.location); // Prints 'http://www.google.com'.
  });
}
{% endprettify %}


### Getting the response body as a string

Read the response body using the `read()` function defined in the http Pub
package.

{% prettify dart %}
import 'package:http/http.dart' as http;

main() async {
  print(await http.read("http://www.google.com/"));
}
{% endprettify %}


### Getting the response content in binary format

Use the `bodyBytes` field on the Response object to get the response
in bytes.

{% prettify dart %}
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

main() async {
  var url = "https://www.dartlang.org/logos/dart-logo.png";
  var response = await http.get(url);
  List<int> bytes = response.bodyBytes;
  // Do something with the bytes. For example, convert to base64.
  String base64 = CryptoUtils.bytesToBase64(bytes);
  print(base64);
}
{% endprettify %}


### Getting the response headers

Use the `headers` field of the Response object to get a headers Map.
The map keys are the header fields, and the map values are the values of
those fields.

{% prettify dart %}
import 'package:http/http.dart' as http;

main() async {
  var url = 'http://httpbin.org/';
  var response = await http.get(url);

  // Get the headers map.
  print(response.headers.keys);

  // Get header values.
  print(
      "access-control-allow-origin' = ${response.headers['access-control-allow-origin']}");
  print("content-type = ${response.headers['content-type']}");
  print("date = ${response.headers['date']}");
  print("content-length = ${response.headers['content-length']}");
  print("connection = ${response.headers['connection']}");
}
{% endprettify %}


## HTTP server


### Implementing a 'Hello world' HTTP server

Use `HttpServer.bind()` method to bind to a port.
The await for listens for connections.
Respond to an `HttpRequest` using the `response` property.

{% prettify dart %}
import 'dart:io';

main() async {
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  print("Serving at ${server.address}:${server.port}");
  await for (HttpRequest request in server) {
    request.response
      ..headers.contentType = new ContentType("text", "plain", charset: "utf-8")
      ..write('Hello, world')
      ..close();
  }
}
{% endprettify %}


### Routing requests based on URL patterns

Use the `route` Pub package, and associate callbacks with URL patterns.

{% prettify dart %}
import 'dart:io';
import 'package:route/server.dart';
import 'package:route/url_pattern.dart';

// Pattern for all posts (plural).
final postsUrl = new UrlPattern(r'/posts\/?');

// Pattern for a single post('/post/24', for example).
final postUrl = new UrlPattern(r'/post/(\d+)\/?');

// Callback for all posts (plural).
servePosts(req) {
  req.response.write("All blog posts");
  req.response.close();
}

// Callback for a single post('/post/24', for example).
servePost(req) {
  var postId = postUrl.parse(req.uri.path)[0];
  req.response.write('Blog post $postId');
  req.response.close();
}

// Callback to handle illegal urls.
serveNotFound(req) {
  req.response.statusCode = HttpStatus.NOT_FOUND;
  req.response.write('Not found');
  req.response.close();
}

main() async {
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  var router = new Router(server)
    // Associate callbacks with URLs.
    ..serve(postsUrl, method: 'GET').listen(servePosts)
    ..serve(postUrl, method: 'GET').listen(servePost)
    ..defaultStream.listen(serveNotFound);
}
{% endprettify %}


## Sockets


### Using serversockets server

Use `ServerSocket.bind()` to bind to an address and a port.  Get the socket
from the ServerSocket and listen to it for the data.

{% prettify dart %}
import 'dart:io';
import 'dart:convert';

main() async {
  var serverSocket = await ServerSocket.bind('127.0.0.1', 4041);
  print('connected');
  await for (var socket in serverSocket)
    socket.transform(UTF8.decoder).listen(print);
}
{% endprettify %}


### Using serversockets client

Create a new socket connection using `Socket.connect()`. Send data over the
socket using the Socket `write()` method.

{% prettify dart %}
import 'dart:io';

main() async {
  var socket = await Socket.connect('127.0.0.1', 4041);
  print(socket.runtimeType);
  socket.write('Hello, World!');
}
{% endprettify %}


## Websockets


### Using websockets server

Upgrade a regular HTTP request to a WebSocket request using
`WebSocketTransformer.upgrade()`.

{% prettify dart %}
import 'dart:io';

handleMsg(msg) {
  print('Message received: $msg');
}

main() async {
  try {
    var server = await HttpServer.bind('127.0.0.1', 4040);
    await for (HttpRequest req in server) {
      if (req.uri.path == '/ws') {
        // Upgrade an HttpRequest to a WebSocket connection.
        var socket = await WebSocketTransformer.upgrade(req);
        socket.listen(handleMsg);
      }
    }
  } catch (e) {
    print(e);
  }
}
{% endprettify %}


### Using websockets client

Make a WebSocket connection using `WebSocket.connect()`, and send data
over that connection using the WebSocket `add()` method.

{% prettify dart %}
import 'dart:io';

main() async {
  var socket = await WebSocket.connect('ws://127.0.0.1:4040/ws');
  socket.add('Hello, World!');
}
{% endprettify %}


## OS and hardware information


### Getting environment variables

Use `Platform.environment` to get the environment for the current process.

{% prettify dart %}
import 'dart:io' show Platform;

main() {
  Map<String, String> envVars = Platform.environment;
  print(envVars['PATH']);
}
{% endprettify %}


### Identifying the operating system

Use `Platform.operatingSystem` to get the operating system as a String.
Or, use the `isMacOS`, `isAndroid`, `isLinux`, and `isWindows` static
getters defined in `Platform`.

{% prettify dart %}
import 'dart:io' show Platform, stdout;

main() {
  // Get the operating system as a string.
  String os = Platform.operatingSystem;

  // Or, use predicate getters for checking the operating system.
  stdout.write("You are using ");
  if (Platform.isMacOS) {
    stdout.writeln('a Mac');
  } else if (Platform.isAndroid) {
    stdout.writeln('an Android device');
  } else if (Platform.isIOS) {
    stdout.writeln('an iOS device');
  } else if (Platform.isLinux) {
    stdout.writeln('Linux');
  } else if (Platform.isWindows) {
    stdout.writeln('Windows');
  } else {
    stdout.writeln('something other than MacOS, Android, Linux, or Windows');
  }
}
{% endprettify %}


### Getting information about the script being run

Use `Platform.script` to get the absolute URI of the script being run in
the current isolate.

{% prettify dart %}
import 'dart:io' show Platform;

main() {
  // Get the URI of the script being run.
  var uri = Platform.script;
  print(uri); // Prints something like '/Users/shailentuli/workspace/...'.

  // Convert the URI to a path.
  var path = uri.toFilePath();
  print(
      path); // Prints something like 'file:///Users/shailentuli/workspace/...'.
}
{% endprettify %}


## Interacting with processes


### Running a process

Use `Process.run()` to run a process. The results of the process are
returned asynchronously using a ProcessResult object.

{% prettify dart %}
import 'dart:io';

main() async {
  // List all files in the current directory in UNIX-like operating systems.
  var results = await Process.run('ls', ['-l']);
  print(results.stdout);
}
{% endprettify %}


### Obtaining the exit code when running a process

Use `Process.start()` to start a process to run an executable. This function
returns a new process that you can use to interact with the original
process. You can use this returned process to obtain the exit code from
executing the original process.

{% prettify dart %}
import 'dart:io';

main() async {
  var process = await Process.start('ls', ['-l']);
  // Get the exit code from the new process.
  var exitCode = await process.exitCode;
  print('exit code: $exitCode');
}
{% endprettify %}


## Working with paths


### Joining paths

Use the path Pub package, and use `join()` to create a new path from
existing paths. Using `join()` ensures that the current platform's directory
separator is used in the path.

{% prettify dart %}
import 'package:path/path.dart' as path;

main() {
  var newPath = path.join('/Users/shailen', 'dart/projects');
  print(newPath); // Prints '/Users.shailen/dart/projects'.
}
{% endprettify %}


### Parsing a path into components

Use the `split()` function in the `path` Pub package to split a path into
its components.

{% prettify dart %}
import 'package:path/path.dart' as path;

main() {
  print(path.split('/Users/shailen')); // Prints ['/', 'Users', 'shailen'].

  // Windows example.
  print(path
      .split(r'C:\tempdir\tmp.txt')); // Prints [r'C:\', 'tempdir', 'tmp.txt'])
}
{% endprettify %}


### Calculating relative paths

Use the `relative()` function in the `path` Pub package to calculate
relative paths.  This function calculates the relative path from the current
directory by default. To calculate the relative path from another path,
specify that path using the `from` argument.

{% prettify dart %}
import 'dart:io' show Directory;
import 'package:path/path.dart' as path;

main() {
  // The path from the current directory to the system temp directory.
  print(path.relative(Directory.systemTemp.path));

  // You can work with relative paths.
  var path1 = 'docs/book.html';
  var path2 = 'articles/list';
  print(path.relative(path1, from: path2)); // Prints '../../docs/book.html'.
  print(path.relative(path2, from: path1)); // Prints '../../articles/list'.

  // Or you can work with absolute paths.
  var samples = 'http://www.dartlang.org/samples';
  var docs = 'http://www.dartlang.org/docs';
  print(path.relative(samples, from: docs)); // Prints '../samples'.
}
{% endprettify %}


### Converting between a URI and a path

Use the `toUri()` and `fromUri()` functions in the `path` Pub package when
converting between a URI and a path.

{% prettify dart %}
import 'package:path/path.dart' as path;

main() {
  var uri = path.toUri('http://dartlang.org/samples');
  print(path.fromUri(uri)); // Prints 'http:/dartlang.org/samples'.
}
{% endprettify %}


### Getting information about a file path

Use the `basename()`, `dirname()`, `basenameWithoutExtension()`, and
`extension()` methods defined in the `path` Pub package when working with
a file path.

{% prettify dart %}
import 'package:path/path.dart' as path;

import 'dart:io';

main() async {
  // Create dir/ and dir/file.txt in the system temp directory.
  var file = await new File('${Directory.systemTemp.path}/dir/myFile.txt')
      .create(recursive: true);

  print(path.basename(file.path)); // Prints 'file.txt'.
  print(path.dirname(file.path)); // Prints path ending with 'dir'.
  print(path.basenameWithoutExtension(file.path)); // Prints 'myFile'.
  print(path.extension(file.path)); // Prints '.txt'.
}
{% endprettify %}


### Getting the path separator for the current platform

Use `Platform.pathSeparator` to get the separator used by the operating
system to separate components in file. Or, use the `separator` getter
in the `path` Pub package.

{% prettify dart %}
import 'dart:io' show Platform;
import 'package:path/path.dart' as path;

main() {
  // Prints  '\' on Windows and '/' on other platforms.
  print(Platform.pathSeparator);

  // This does the same.
  print(path.separator);
}
{% endprettify %}


##  Other resources


Read the [dart:io library API docs]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/dart-io-library.html).

Here are links to the commonly used classes and packages in these examples:

* Using files, directories, and symlinks

  * [FileSystemEntity class]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/FileSystemEntity-class.html)
  * [File class]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/File-class.html)
  * [Directory class]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Directory-class.html)
  * [Link class (for symlinks)]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Link-class.html)

* HTTP server

  * [HttpServer class]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpServer-class.html)
  * [http_server Pub package](https://pub.dartlang.org/packages/http_server)

* OS and hardware information

  * [Platform class]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Platform-class.html)

* Interacting with processes

  * [Process class]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Process-class.html)

* Working with paths

  * [path Pub package](https://pub.dartlang.org/packages/path)

