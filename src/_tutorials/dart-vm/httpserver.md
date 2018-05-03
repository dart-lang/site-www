---
layout: tutorial
title: "Write HTTP Clients & Servers"
description: Communicate over the internet
prevpage:
  url: /tutorials/dart-vm/cmdline
  title: "Write Command-Line Apps"
---
{% capture gh-path -%}
  https://github.com/dart-lang/dart-tutorials-samples/blob/master/httpserver
{%- endcapture -%}

{% include tutorial-banner.html %}

### Communicate over the internet

<div class="mini-toc" markdown="1">
  <h4>What's the point?</h4>

  * Knowledge of Futures and Streams is a prerequisite.
  * The HTTP protocol allows clients and servers to communicate.
  * The dart:io package has classes for writing HTTP programs.
  * Servers listen for requests on a host and port.
  * Clients send requests using an HTTP method request.
  * The http_server package provides higher-level building blocks.
</div>

<aside class="alert alert-info" markdown="1">
  <strong>Prerequisite:</strong> HTTP servers and clients rely heavily on
  [Futures][Future] and [Streams][Stream], which are not explained in this
  tutorial. Refer to
  [Asynchronous Programming: Futures](/tutorials/language/futures) and
  [Asynchronous Programming: Streams](/tutorials/language/streams)
  for information about using these classes.
</aside>

HTTP (Hypertext Transfer Protocol) is a communication protocol used
to send data from one program to another over the internet.
At one end of the data transfer is a server
and at the other end is a client.
The client is often browser-based
(either a user typing in a browser or a script running in a browser),
but might also be a standalone program.

The server _binds_ to a host and port (it
makes an exclusive connection to an IP address and
a port number).
Then the server listens for requests.
Because of Dart's asynchronous nature,
the server can handle many requests at a single time,
as follows:

* Server listens
* Client connects
* Server accepts and receives request (and continues to listen)
* Server can continue to accept other requests
* Server writes response of request or several, possibly interleaved, requests
* Server finally ends (closes) the response(s).

In Dart, the [dart:io][] library contains
the classes and functions you need to write HTTP
clients and servers. In addition, the [http_server][] package
contains some higher-level classes that make it easier to write
clients and servers.

<aside class="alert alert-info" markdown="1">
  <strong>Important:</strong> _Browser-based programs **cannot** use the
  dart:io library._

  The APIs in the dart:io library
  work _only_ with standalone, command-line programs.
  They do not work in the browser.
  To make HTTP requests from a browser-based client
  refer to the [dart:html HttpRequest][] class.
</aside>

This tutorial provides several examples that show how easy
it is to write Dart HTTP servers and clients.
Beginning with the hello world of servers,
you learn how to write the code for a server
from binding and listening to responding to requests.
You also learn about the client side: making different
kinds of requests (GET and POST),
writing browser-based and command-line clients.

## Get the source code

- Get the Dart Tutorials [example code.][dart-tutorials-samples.zip]
- View the `httpserver` directory, which contains the sources you need for this
  tutorial.

## Run the hello world server {#run-hello-world}

_Example file for this section:_
[hello_world_server.dart.]({{gh-path}}/bin/hello_world_server.dart)

Let's begin with a small server that responds to all requests
with the string `Hello, world!`

At the command line, run the `hello_world_server.dart` script:

```terminal
$ cd httpserver/bin
$ dart hello_world_server.dart
listening on localhost, port 4040
```

<i class="material-icons">open_in_browser</i>
**In any browser, visit** [localhost:4040](localhost:4040).
The browser displays `Hello, world!`

![The response from the hello world server.](/tutorials/dart-vm/images/hello_world_response.png)

In this case, the server is a Dart program
and the client is the browser you used.
However, you can write client programs in Dart&mdash;either
a browser-based client script, or a standalone program.

### A quick glance at the code

In the code for the hello world server,
an HTTP server binds to a host and port,
listens for HTTP requests, and writes a response.
Note that the program imports
the [dart:io][] library, which contains the HTTP-related
classes both for server-side programs and for
client-side programs (but not for web apps).

<?code-excerpt "httpserver/bin/hello_world_server.dart" replace="/.*?dart:io.*/[!$&!]/g"?>
{% prettify dart %}
[!import 'dart:io';!]
import 'dart:async';

Future main() async {
  var server = await HttpServer.bind(
    InternetAddress.LOOPBACK_IP_V4,
    4040,
  );
  print('Listening on localhost:${server.port}');

  await for (HttpRequest request in server) {
    request.response
      ..write('Hello, world!')
      ..close();
  }
}
{% endprettify %}
<div class="prettify-filename">hello_world_server.dart</div>

The next few sections cover server-side binding,
making a client-side GET request,
listening, and responding.

## Binding a server to a host and port {#binding}

_Example for this section:_
[hello_world_server.dart.]({{gh-path}}/bin/hello_world_server.dart)

The first statement in `main()` uses `HttpServer.bind()` to create an
[HttpServer][] object and bind it to a host and port.

<?code-excerpt "httpserver/bin/hello_world_server.dart (bind)"?>
{% prettify dart %}
var server = await HttpServer.bind(
  InternetAddress.LOOPBACK_IP_V4,
  4040,
);
{% endprettify %}
<div class="prettify-filename">hello_world_server.dart</div>

The code uses `await` to call the `bind` method asynchronously.

### Hostname
The first parameter of `bind()` specifies the hostname.
You can specify a particular hostname or IP address as a String.
Alternatively, you can specify the host using these predefined values
provided by the [InternetAddress][] class:

| Value | Use case |
|---|---|
| LOOPBACK_IP_V4<br/>_or_<br/>LOOPBACK_IP_V6 | The server listens for client activity on the loopback address, which is effectively localhost. Uses either version 4 or 6 of the IP protocol. These are used primarily for testing. We recommend that you use these values instead of `localhost` or `127.0.0.1`. |
| ANY_IP_V4<br/>_or_<br/>ANY_IP_V6 | The server listens for client activity on the specified port on any IP address. Uses either version 4 or 6 of the IP protocol. |
{: .table}

By default, when using a V6 internet address,
a V4 listener is used as well.

### Port

The second parameter to `bind()` is an integer
that specifies the port.
The port uniquely identifies a service on the host computer.
Port numbers below 1024 are reserved (except for 0)
for standard services.
For example, FTP data transfer typically runs on port 20,
quote of the day on port 17, and HTTP on port 80.
Your program should use port numbers from 1024 and higher.
If the port is already in use,
the connection for your server will be refused.

### Listening for requests

The server begins listening for HTTP requests using `await for`.
For each request received, the code sends a "Hello, world!" response.

<?code-excerpt "httpserver/bin/hello_world_server.dart (listen)"?>
{% prettify dart %}
await for (HttpRequest request in server) {
  request.response
    ..write('Hello, world!')
    ..close();
}
{% endprettify %}
<div class="prettify-filename">hello_world_server.dart</div>

You'll learn more about what the [HttpRequest][] object contains
and how to write the response in the section
[Listening for and handling requests](#httprequest-object).
But first, let's look at one way a client generates a request.

## Using HTML forms to make GET requests {#using-forms-to-make-get-requests}

_Example files for this section:_
[number_thinker.dart]({{gh-path}}/bin/number_thinker.dart) and
[make_a_guess.html.]({{gh-path}}/web/make_a_guess.html)

This section features a command-line server that
randomly chooses a number between 0 and 9.
The client is a basic HTML web-page, `make_a_guess.html`,
that you can use to guess the number.

<hr>
**Try it!**

1. **Run the number thinker server**

   At the command line, run the `number_thinker.dart` server.
   You should see something similar to the following:

   ```terminal
   $ cd httpserver/bin
   $ dart number_thinker.dart
   I'm thinking of a number: 6
   ```

2. **Launch the web server**

   Run `pub serve` from the top directory of the app.

3. **Open the HTML page**

   In a browser, go to
   [localhost:8080/make_a_guess.html](localhost:8080/make_a_guess.html).

4. **Make a guess**

   Choose a number and press the **Guess** button.

   ![The user makes a guess using a pull-down menu.](/tutorials/dart-vm/images/guessing.png)

<hr>

No Dart code is involved in the client.
The client request is made from the browser
to the Dart server through an HTML form
within make_a_guess.html,
which provides an automatic way to formulate and send client HTTP requests.
The form contains the pull-down list and the button.
The form also specifies the URL, which includes the port number,
and the kind of request (the _request method_).
It might also include elements that build a query string.

Here's the form HTML from `make_a_guess.html`:

<?code-excerpt "httpserver/web/make_a_guess.html (form)" replace="/(action|method|name|type)=(.).*?\2/[!$&!]/g"?>
{% prettify html %}
<form [!action="http://localhost:4041"!] [!method="GET"!]>
  <select [!name="q"!]>
    <option value="0">0</option>
    <option value="1">1</option>
    <option value="2">2</option>
    <!-- ··· -->
    <option value="9">9</option>
  </select>
  <input [!type="submit"!] value="Guess">
</form>
{% endprettify %}
<div class="prettify-filename">make_a_guess.html</div>

Here's how the form works:

- The form's `action` attribute is assigned the
  URL to send the request to.
- The form's `method` attribute defines
  the kind of request, here a `GET`. Other common
  kinds of request include POST, PUT, and DELETE.
- Any element within the form that has a `name`, like the `<select>` element,
  becomes a parameter in the query string.
- When pressed, the submit button (`<input type="submit"...>`) formulates
  the request based on the content of the form and sends it.

### A RESTful GET request

REST (REpresentational State Transfer) is a set of principles
for designing Web services.
Well-behaved HTTP clients and servers observe the REST principles
defined for GET requests.

A GET request:

* only retrieves data
* doesn't change the state of the server
* has length limits
* can send query strings in the URL of the request

The client in this example makes a REST-compliant GET request.

## Listening for and handling requests {#httprequest-object}

_Example files for this section:_
[number_thinker.dart]({{gh-path}}/bin/number_thinker.dart) and
[make_a_guess.html.]({{gh-path}}/web/make_a_guess.html)

Now that you've seen the browser-based client for this example,
let's take a look at the Dart code for the number thinker server,
starting with `main()`.

Once again the server binds to a host and port.
Here, the top-level `handleRequest()` method is called for each
request received. Because HttpServer implements [Stream,][Stream]
you can use `await for` to process the requests.

<?code-excerpt "httpserver/bin/number_thinker.dart (main)" replace="/handleRequest/[!$&!]/g"?>
{% prettify dart %}
import 'dart:async';
import 'dart:io';
import 'dart:math' show Random;

Random intGenerator = new Random();
int myNumber = intGenerator.nextInt(10);

Future main() async {
  print("I'm thinking of a number: $myNumber");

  HttpServer server = await HttpServer.bind(
    InternetAddress.LOOPBACK_IP_V4,
    4041,
  );
  await for (var request in server) {
    [!handleRequest!](request);
  }
}
{% endprettify %}
<div class="prettify-filename">number_thinker.dart</div>

When a `GET` request arrives, the `handleRequest()` method calls
`handleGet()` to process the request.

<?code-excerpt "httpserver/bin/number_thinker.dart (handleRequest)" replace="/handleGet/[!$&!]/g"?>
{% prettify dart %}
void handleRequest(HttpRequest request) {
  try {
    if (request.method == 'GET') {
      [!handleGet!](request);
    } else {
      // ···
    }
  } catch (e) {
    print('Exception in handleRequest: $e');
  }
  print('Request handled.');
}
{% endprettify %}
<div class="prettify-filename">number_thinker.dart</div>

An [HttpRequest][] object has many properties that provide
information about the request.
The following table lists some useful properties:

| Property | Information |
|---|---|
| `method` | One of `'GET'`, `'POST'`, `'PUT'`, and so on. |
| `uri` | A  [Uri][] object: scheme, host, port, query string, and other information about the requested resource. |
| `response` | An [HttpResponse][] object: where the server writes its response. |
| `headers` | An [HttpHeaders][] object: the headers for the request, including [ContentType,][ContentType] content length, date, and so on. |
{: .table}

### Using the method property

The code below from the number thinker example uses the HttpRequest `method`
property to determine what kind of request has been received.
This server handles only GET requests.

<?code-excerpt "httpserver/bin/number_thinker.dart (request-method)" replace="/handleGet/[!$&!]/g"?>
{% prettify dart %}
if (request.method == 'GET') {
  [!handleGet!](request);
} else {
  request.response
    ..statusCode = HttpStatus.METHOD_NOT_ALLOWED
    ..write('Unsupported request: ${request.method}.')
    ..close();
}
{% endprettify %}
<div class="prettify-filename">number_thinker.dart</div>

### Using the uri property

Typing a URL into a browser generates a GET request,
which simply requests data from the specified resource.
It can send a minimal amount of data along with the request
through a query string attached to the URI.

<?code-excerpt "httpserver/bin/number_thinker.dart (uri)" replace="/request.uri/[!$&!]/g"?>
{% prettify dart %}
void handleGet(HttpRequest request) {
  final guess = [!request.uri!].queryParameters['q'];
  // ···
}
{% endprettify %}
<div class="prettify-filename">number_thinker.dart</div>

Use the `uri` property from the HttpRequest object to get a [Uri][] object
that contains the information about the URL typed by the user.
The `queryParameters` property of the Uri object is a Map containing
the components of the query string.
Refer to the desired parameter by name.
This example uses `q` to identify the guessed number.

### Setting the status code for the response

The server should set the status code to indicate the success or
failure of the request. Earlier you saw the number thinker set
the status code to `METHOD_NOT_ALLOWED` to reject non-GET requests.
Later in the code,
to indicate that the request was successful and the response is complete,
the number thinker server sets the HttpResponse status code to `HttpStatus.OK`.

<?code-excerpt "httpserver/bin/number_thinker.dart (statusCode)" replace="/response.statusCode.*?;/[!$&!]/g"?>
{% prettify dart %}
void handleGet(HttpRequest request) {
  final guess = request.uri.queryParameters['q'];
  final response = request.response;
  [!response.statusCode = HttpStatus.OK;!]
  // ···
}
{% endprettify %}
<div class="prettify-filename">number_thinker.dart</div>

`HttpStatus.OK` and `HttpStatus.METHOD_NOT_ALLOWED` are
two of many predefined status codes in the [HttpStatus][] class.
Another useful predefined status code is
`HttpStatus.NOT_FOUND` (your classic 404).

In addition to `statusCode`,
the HttpResponse object has other useful properties:

| Property | Information |
|---|---|
| `contentLength` | The length of the response; -1 means the length is not known in advance. |
| `cookies` | A List of [Cookies][Cookie] to set in the client. |
| `encoding` | The [Encoding][] used when writing strings, like JSON and UTF-8. |
| `headers` | The response headers, an [HttpHeaders][] object. |
{: .table}

### Writing the response to the HttpResponse object

Every HttpRequest object has a corresponding HttpResponse object.
The server sends data back to the client through the response object.

Use one of the HttpResponse write methods
(`write()`, `writeln()`, `writeAll()`, or `writeCharCodes()`)
to write the response data to the HttpResponse object.
Or connect the HttpResponse object to a stream via `addStream`
and write to the stream.
Close the object when the response is complete.
Closing the HttpResponse object
sends the data back to the client.

<?code-excerpt "httpserver/bin/number_thinker.dart (write)" replace="/\.\..*/[!$&!]/g"?>
{% prettify dart %}
void handleGet(HttpRequest request) {
  // ···
  if (guess == myNumber.toString()) {
    response
      [!..writeln('true')!]
      [!..writeln("I'm thinking of another number.")!]
      [!..close();!]
    // ···
  }
}
{% endprettify %}
<div class="prettify-filename">number_thinker.dart</div>

## Making a POST request from a standalone client {#making-post}

_Example files for this section:_
[basic_writer_server.dart]({{gh-path}}/bin/basic_writer_server.dart) and
[basic_writer_client.dart.]({{gh-path}}/bin/basic_writer_client.dart)

In the hello world and number thinker examples,
the browser generated simple GET requests.
For more complex GET requests and other kinds of requests, such
as POST, PUT, or DELETE,
you need to write a client program, of which there are two kinds:

* A standalone client program, which uses the [HttpClient][]
  class from `dart:io`.

* A browser-based client, which uses API from [dart:html.][dart:html]
  This tutorial does not cover browser-based clients.
  To look at code for a browser-based client and
  related server, see
  [note_client.dart,]({{gh-path}}/web/note_client.dart)
  [note_server.dart,]({{gh-path}}/bin/note_server.dart)
  and [note_taker.html.]({{gh-path}}/web/note_taker.html)

  Let's look at a standalone client, `basic_writer_client.dart`,
  and its server `basic_writer_server.dart`.
  The client makes a POST request
  to save JSON data to a server-side file.
  The server accepts the request and saves the file.

<hr>
**Try it!**

Run the server and client on the command line.

1. First, run the server:

   ```terminal
   $ cd httpserver/bin
   $ dart basic_writer_server.dart
   ```

2. In a new terminal, run the client:

   ```terminal
   $ cd httpserver/bin
   $ dart basic_writer_client.dart
   Wrote data for Han Solo.
   ```

Look at the JSON data that the server wrote to `file.txt`:

   ```json
   {"name":"Han Solo","job":"reluctant hero","BFF":"Chewbacca","ship":"Millennium Falcon","weakness":"smuggling debts"}
   ```

<hr>

The client creates an HttpClient object and uses the
`post()` method to make the request.
Making a request involves two Futures:

* The `post()` method establishes a network
connection to the server and completes with the first Future,
which returns an HttpClientRequest object.

* The client composes the request object and closes it.
The `close()` method sends the request to the server
and returns the second Future, which completes with
an HttpClientResponse object.

<?code-excerpt "httpserver/bin/basic_writer_client.dart" replace="/\/\*.\*\/|post|headers|write|close|utf8.\w+/[!$&!]/g"?>
{% prettify dart %}
import 'dart:async';
import 'dart:io';
import 'dart:convert';

String _host = InternetAddress.LOOPBACK_IP_V4.host;
String path = 'file.txt';

Map jsonData = {
  'name': 'Han Solo',
  'job': 'reluctant hero',
  'BFF': 'Chewbacca',
  'ship': 'Millennium Falcon',
  'weakness': 'smuggling debts'
};

Future main() async {
  HttpClientRequest request =
      await new HttpClient().[!post!](_host, 4049, path) [!/*1*/!]
        ..[!headers!].contentType = ContentType.JSON [!/*2*/!]
        ..[!write!](jsonEncode(jsonData)); [!/*3*/!]
  HttpClientResponse response = await request.[!close!](); [!/*4*/!]
  await response.transform([!utf8.decoder!] [!/*5*/!]).forEach(print);
}
{% endprettify %}
<div class="prettify-filename">basic_writer_client.dart</div>

{:.code-notes}
1. The `post()` method requires the host, port, and the path to the requested
   resource. In addition to `post()`, the [HttpClient][] class provides
   functions for making other kinds of requests, including `postUrl()`,
   `get()`, and `open()`.

2. An [HttpClientRequest][] object has an [HttpHeaders][] object, which
   contains the request headers. For some headers, like `contentType`,
   HttpHeaders has a property specific to that header. For other headers, use
   the `set()` method to put the header in the HttpHeaders object.

3. The client writes data to the request object using `write()`. The encoding,
   JSON in this example, matches the type specified in the [ContentType][]
   header.

4. The `close()` method sends the request to the server and, when complete,
   returns an [HttpClientResponse][] object.

5. The UTF-8 response from the server is decoded. Use a transformer defined in
   the [dart:convert][] library to convert the data into regular Dart string
   format.

### A RESTful POST request

Similar to GET requests, REST provides guidelines for POST requests.

A POST request:

* creates a resource (in this example, a file)
* uses a URI that has a structure similiar to file and directory pathnames;
for example, the URI has no query string
* transfers data as JSON or XML
* has no state and does not change the state of the server
* has no length limits

The client in this example makes REST-compliant POST requests.

To see client code that makes REST-compliant GET requests,
look at [number_guesser.dart.]({{gh-path}}/bin/number_guesser.dart)
It's a standalone client for the number thinker server
that makes periodic guesses until it guesses correctly.

## Handling a POST request in a server {#handling-post}

_Example files for this section:_
[basic_writer_server.dart]({{gh-path}}/bin/basic_writer_server.dart) and
[basic_writer_client.dart.]({{gh-path}}/bin/basic_writer_client.dart)

An HttpRequest object is a stream of byte lists (`Stream<List<int>>`).
To get the data sent from the client,
listen for data on the HttpRequest object.

If the request from the client contains a large amount of
data, the data might arrive in multiple chunks. You can use the
join() method in Stream to concatenate the string values of those chunks.

![The flow of control in a server processing requests.](/tutorials/dart-vm/images/flowchart.png)

The `basic_writer_server.dart` file implements
a server that follows this pattern.

<?code-excerpt "httpserver/bin/basic_writer_server.dart" replace="/\/\*\d\*\/|contentType.*? == \S+|(content|data) = [^;]*|req\.uri[^ ]*/[!$&!]/g"?>
{% prettify dart %}
import 'dart:async';
import 'dart:io';
import 'dart:convert';

String _host = InternetAddress.LOOPBACK_IP_V4.host;

Future main() async {
  var server = await HttpServer.bind(_host, 4049);
  await for (var req in server) {
    ContentType contentType = req.headers.contentType;
    HttpResponse response = req.response;

    if (req.method == 'POST' &&
        [!contentType?.mimeType == 'application/json'!] [!/*1*/!]) {
      try {
        String content =
            await req.transform(utf8.decoder).join(); [!/*2*/!]
        var [!data = jsonDecode(content) as Map!]; [!/*3*/!]
        var fileName = [!req.uri.pathSegments.last;!] [!/*4*/!]
        await new File(fileName)
            .writeAsString(content, mode: FileMode.WRITE);
        req.response
          ..statusCode = HttpStatus.OK
          ..write('Wrote data for ${data['name']}.');
      } catch (e) {
        response
          ..statusCode = HttpStatus.INTERNAL_SERVER_ERROR
          ..write("Exception during file I/O: $e.");
      }
    } else {
      response
        ..statusCode = HttpStatus.METHOD_NOT_ALLOWED
        ..write("Unsupported request: ${req.method}.");
    }
    response.close();
  }
}
{% endprettify %}
<div class="prettify-filename">basic_writer_server.dart</div>

{:.code-notes}
1. The request has an HttpHeaders object. Recall that the client set the
   `contentType` header to JSON (application/json). This server rejects
   requests that are not JSON-encoded.

2. A POST request has no limit on the amount of data it can send and the data
   might be sent in multiple chunks. Furthermore, JSON is UTF-8, and UTF-8
   characters can be encoded over multiple bytes. The join() method puts the
   chunks together.

3. The data sent by the client is JSON formatted. The server decodes it using
   the JSON codec available in the [dart:convert][] library.

4. The URL for the request is
   [localhost:4049/file.txt](localhost:4049/file.txt). The code
   `req.uri.pathSegments.last` extracts the file name from the URI:
   `file.txt`.

#### A note about CORS headers

If you want to serve clients that are running on a different origin
(a different host or port), you need to add CORS headers.
The following code,
take from note_server.dart,
allows POST and OPTIONS requests from any origin.
Use CORS headers with caution,
because they can open your network up to security risks.

<?code-excerpt "httpserver/bin/note_server.dart (addCorsHeaders)"?>
{% prettify dart %}
void addCorsHeaders(HttpResponse response) {
  response.headers.add('Access-Control-Allow-Origin', '*');
  response.headers
      .add('Access-Control-Allow-Methods', 'POST, OPTIONS');
  response.headers.add('Access-Control-Allow-Headers',
      'Origin, X-Requested-With, Content-Type, Accept');
}
{% endprettify %}
<div class="prettify-filename">note_server.dart</div>

For more information, refer to Wikipedia's article
[Cross-origin resource sharing](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing).

## Using the http_server package {#using-http-server-package}

_Example files for this section:_
[mini_file_server.dart]({{gh-path}}/bin/mini_file_server.dart) and
[static_file_server.dart.]({{gh-path}}/bin/static_file_server.dart)

For some higher-level building blocks,
we recommend that you try the
[http_server](https://pub.dartlang.org/packages/http_server)
pub package,
which contains a set of classes that,
together with the HttpServer class in the `dart:io` library,
make it easier to implement HTTP servers.

In this section, we compare a server written
using API only from dart:io to a server
with the same functionality
written using dart:io together with http_server.

You can find the first server in `mini_file_server.dart`.
It responds to all requests by returning the contents of the
`index.html` file in the same directory as its source.

**Try it!**

1. Run the server on the command line:

   ```terminal
   $ cd httpserver/bin
   $ dart mini_file_server.dart
   ```

2. Type [localhost:4044](localhost:4044) into the browser.
   The server displays an HTML file:

   ![The index.html file served by mini_file_server.dart.](/tutorials/dart-vm/images/index_file.png)

Here's the code for mini file server:

<?code-excerpt "httpserver/bin/mini_file_server.dart"?>
{% prettify dart %}
import 'dart:async';
import 'dart:io';

File targetFile = new File('index.html');

Future main() async {
  var server;

  try {
    server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4044);
  } catch (e) {
    print("Couldn't bind to port 4044: $e");
    exit(-1);
  }

  await for (HttpRequest req in server) {
    if (await targetFile.exists()) {
      print("Serving ${targetFile.path}.");
      req.response.headers.contentType = ContentType.HTML;
      try {
        await targetFile.openRead().pipe(req.response);
      } catch (e) {
        print("Couldn't read file: $e");
        exit(-1);
      }
    } else {
      print("Can't open ${targetFile.path}.");
      req.response
        ..statusCode = HttpStatus.NOT_FOUND
        ..close();
    }
  }
}
{% endprettify %}
<div class="prettify-filename">mini_file_server.dart</div>

This code determines whether the file exists,
and if it does, opens the file and pipes the contents
to the HttpResponse object.

The second server, whose code you can find in
[basic_file_server.dart,]({{gh-path}}/bin/basic_file_server.dart)
uses the [http_server][] package.

**Try it!**

1. Run the server on the command line:

   ```terminal
   $ cd httpserver/bin
   $ dart basic_file_server.dart
   ```

2. Type [localhost:4046](localhost:4046) into the browser.
   The server displays the same index.html file as the previous:

   ![The index.html file served by basic_file_server.dart.](/tutorials/dart-vm/images/index_file_4046.png)

In this server, the code for handling the request is much shorter,
because the [VirtualDirectory][] class handles the details of serving the file.

<?code-excerpt "httpserver/bin/basic_file_server.dart" replace="/staticFiles\..*/[!$&!]/g"?>
{% prettify dart %}
import 'dart:async';
import 'dart:io';
import 'package:http_server/http_server.dart';

File targetFile = new File('index.html');

Future main() async {
  VirtualDirectory staticFiles = new VirtualDirectory('.');

  var serverRequests =
      await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4046);
  await for (var request in serverRequests) {
    [!staticFiles.serveFile(targetFile, request);!]
  }
}
{% endprettify %}
<div class="prettify-filename">basic_file_server.dart</div>

Here, the requested resource, index.html, is served by
the `serveFile()` method in the VirtualDirectory class.
You don't need to write code to open a file and pipe its contents
to the request.

Another file server, `static_file_server.dart`,
also uses the http_server package.
This server serves any file from the server's directory
or subdirectory.

Run `static_file_server.dart`,
and test it with the URL localhost:4048/file.txt.
Change `file.txt` to other filenames within the directory.

Here is the code for `static_file_server.dart`.

<?code-excerpt "httpserver/bin/static_file_server.dart" replace="/\/\*\d\*\//[!$&!]/g"?>
{% prettify dart %}
import 'dart:async';
import 'dart:io';
import 'package:http_server/http_server.dart';
import 'package:path/path.dart';

Future main() async {
  var pathToBuild = join(dirname(Platform.script.toFilePath()));

  var staticFiles = new VirtualDirectory(pathToBuild);
  staticFiles.allowDirectoryListing = true; [!/*1*/!]
  staticFiles.directoryHandler = (dir, request) [!/*2*/!] {
    var indexUri = new Uri.file(dir.path).resolve('index.html');
    staticFiles.serveFile(new File(indexUri.toFilePath()), request); [!/*3*/!]
  };

  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4048);
  print('Listening on port 4048');
  await server.forEach(staticFiles.serveRequest); [!/*4*/!]
}
{% endprettify %}
<div class="prettify-filename">static_file_server.dart</div>

{:.code-notes}
1. Allows clients to request files within the server's directory.

2. An anonymous function that handles requests for the directory itself, that
   is, the URL contains no filename. The function redirects these requests to
   `index.html`.

3. The `serveFile` method serves a file. In this example, it serves
   `index.html` for directory requests.

4. The `serveRequest` method provided by the VirtualDirectory class handles
   requests that specify a file.

## Using https with bindSecure() {#using-https}

_Example for this section:_
[hello_world_server_secure.dart.]({{gh-path}}/bin/hello_world_server_secure.dart)

You might have noticed that the HttpServer class defines a
method called `bindSecure()`, which provides a secure connection
using HTTPS (Hyper Text Transfer Protocol with Secure Sockets Layer).
To use the bindSecure() method, you need a certificate,
which is provided by a Certificate Authority (CA).
For more information about certificates refer to
[What is SSL and what are Certificates?](http://www.tldp.org/HOWTO/SSL-Certificates-HOWTO/x64.html)

For illustrative purposes only,
the following server, `hello_world_server_secure.dart`,
calls `bindSecure()` using
a certificate created by the Dart team for testing.
You **must** provide your own certificates for your servers.

<?code-excerpt "httpserver/bin/hello_world_server_secure.dart" replace="/\S.*\/\*\d\*\//[!$&!]/g"?>
{% prettify dart %}
import 'dart:async';
import 'dart:io';

String certificateChain = 'server_chain.pem';
String serverKey = 'server_key.pem';

Future main() async {
  [!var serverContext = new SecurityContext(); /*1*/!]
  [!serverContext.useCertificateChain(certificateChain); /*2*/!]
  [!serverContext.usePrivateKey(serverKey, password: 'dartdart'); /*3*/!]

  var server = await HttpServer.bindSecure(
    'localhost',
    4047,
    [!serverContext, /*4*/!]
  );
  print('Listening on localhost:${server.port}');
  await for (HttpRequest request in server) {
    request.response
      ..write('Hello, world!')
      ..close();
  }
}
{% endprettify %}
<div class="prettify-filename">hello_world_server_secure.dart</div>

{:.code-notes}
1. Optional settings for a secure network connection are specified in a
   SecurityContext object. There is a default object,
   SecurityContext.defaultContext, that includes trusted root certificates for
   well-known certificate authorities.

2. A file containing the chain of certificates from the server certificate up
   to the root of the signing authority, in [PEM format.][]

3. A file containing the (encrypted) server certificate private key, in
   [PEM format.][]

4. The context argument is required on servers, optional for clients. If it is
   omitted, then the default context with built-in trusted roots is used.

[PEM format.]: http://how2ssl.com/articles/working_with_pem_files

## Other resources

Visit these API docs
for further details about the classes and libraries discussed in this tutorial.

| Dart class | Purpose |
|---|---|
| [HttpServer][] | An HTTP server |
| [HttpClient][] | An HTTP client|
| [HttpRequest][] | A server-side request object |
| [HttpResponse][] | A server-side response object |
| [HttpClientRequest][] | A client-side request object |
| [HttpClientResponse][] | A client-side response object |
| [HttpHeaders][] | The headers for a request |
| [HttpStatus][] | The status of the response |
| [InternetAddress][] | An internet address |
| [SecurityContext][] | Contains certificates, keys, and trust information for a secure connection |
| [http_server][] package | A package with higher-level HTTP classes |
{: .table}

## What next?

* If you haven't yet tried the server-side codelab,
  try [writing a server app](https://dart-lang.github.io/server/codelab/).
* [Servers with Dart](https://dart-lang.github.io/server/)
  links to resources for writing standalone Dart applications,
  including servers.

[ContentType]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/ContentType-class.html
[Cookie]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Cookie-class.html
[dart-tutorials-samples.zip]: https://github.com/dart-lang/dart-tutorials-samples/archive/master.zip
[dart:convert]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/dart-convert-library.html
[dart:html]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/dart-html-library.html
[dart:io]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/dart-io-library.html
[Encoding]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/Encoding-class.html
[Future]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future-class.html
[http_server]: https://pub.dartlang.org/packages/http_server
[HttpClient]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpClient-class.html
[HttpClientRequest]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpClientRequest-class.html
[HttpClientResponse]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpClientResponse-class.html
[HttpHeaders]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpHeaders-class.html
[dart:html HttpRequest]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/HttpRequest-class.html
[HttpRequest]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpRequest-class.html
[HttpResponse]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpResponse-class.html
[HttpServer]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpServer-class.html
[HttpStatus]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpStatus-class.html
[InternetAddress]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/InternetAddress-class.html
[SecurityContext]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/SecurityContext-class.html
[Stream]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Stream-class.html
[Uri]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Uri-class.html
[VirtualDirectory]: https://www.dartdocs.org/documentation/http_server/latest/http_server/VirtualDirectory-class.html
