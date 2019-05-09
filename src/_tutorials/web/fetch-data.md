---
title: Fetch data dynamically
description: Use HttpRequest to fetch data from a file or a server.
---
<!--?code-excerpt path-base="examples/fetch_data"?-->

<div class="mini-toc" markdown="1">
  <h4>What's the point?</h4>

  * Data on the web is often formatted in JSON.
  * JSON is text based and human readable.
  * The dart:convert library provides support for JSON.
  * Use HttpRequest to dynamically load data.
</div>

Web apps often use
[JSON](http://www.json.org/)
(JavaScript Object Notation)
to pass data between clients and servers.
Data can be _serialized_ into a JSON string,
which is then passed between a client and server,
and revived as an object at its destination.
This tutorial shows you how to use functions in the
[dart:convert][]{: target="_blank" rel="noopener"}
library to produce and consume JSON data.
Because JSON data is typically loaded dynamically,
this tutorial also shows how a web app
can use an HTTP request to get data from an HTTP server.
For web apps,
HTTP requests are served by the browser in which the app is running,
and thus are subject to the browser's security restrictions.

## About JSON

The JSON data format is easy for humans
to write and read because it is lightweight and text based.
With JSON, various data types
and simple data structures such as lists and maps
can be serialized and represented by strings.

**Try it!**
The following app, `its_all_about_you`,
displays the JSON string for data of various types.
Click run ( {% asset red-run.png %} ) to start the app.
Then change the values of the input elements,
and check out the JSON format for each data type.
You might prefer to
[open the app in DartPad]({{site.custom.dartpad.direct-link}}/1d42e4eadb75bcc1ffbc079e299b862e){: target="_blank" rel="noopener"}
to have more space for the app's code and UI.

{% comment %}
https://gist.github.com/chalin/1d42e4eadb75bcc1ffbc079e299b862e

<!--?code-excerpt "web/main.dart" indent-by="0"?-->
{% prettify %}
// Copyright (c) 2015, the Dart project authors.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:convert';

// Input fields
InputElement favoriteNumber;
InputElement valueOfPi;
InputElement horoscope;
InputElement favOne;
InputElement favTwo;
InputElement favThree;
RadioButtonInputElement loveChocolate;
RadioButtonInputElement noLoveForChocolate;

// Result fields
TextAreaElement intAsJson;
TextAreaElement doubleAsJson;
TextAreaElement stringAsJson;
TextAreaElement listAsJson;
TextAreaElement boolAsJson;
TextAreaElement mapAsJson;

void main() {
  // Set up the input text areas.
  favoriteNumber = querySelector('#favoriteNumber');
  valueOfPi = querySelector('#valueOfPi');
  horoscope = querySelector('#horoscope');
  favOne = querySelector('#favOne');
  favTwo = querySelector('#favTwo');
  favThree = querySelector('#favThree');
  loveChocolate = querySelector('#loveChocolate');
  noLoveForChocolate = querySelector('#noLoveForChocolate');

  // Set up the results text areas
  // to display the values as JSON.
  intAsJson = querySelector('#intAsJson');
  doubleAsJson = querySelector('#doubleAsJson');
  boolAsJson = querySelector('#boolAsJson');
  stringAsJson = querySelector('#stringAsJson');
  listAsJson = querySelector('#listAsJson');
  mapAsJson = querySelector('#mapAsJson');

  // Set up the listeners.
  favoriteNumber.onKeyUp.listen(showJson);
  valueOfPi.onKeyUp.listen(showJson);
  loveChocolate.onClick.listen(showJson);
  noLoveForChocolate.onClick.listen(showJson);
  horoscope.onKeyUp.listen(showJson);
  favOne.onKeyUp.listen(showJson);
  favTwo.onKeyUp.listen(showJson);
  favThree.onKeyUp.listen(showJson);

  _populateFromJson();
  showJson(null);
}

// Pre-fill the form with some default values.
void _populateFromJson() {
  final jsonDataAsString = '''{
    "favoriteNumber": 73,
    "valueOfPi": 3.141592,
    "chocolate": true,
    "horoscope": "Cancer",
    "favoriteThings": ["monkeys", "parrots", "lattes"]
  }''';

  Map jsonData = json.decode(jsonDataAsString);

  favoriteNumber.value = jsonData['favoriteNumber'].toString();
  valueOfPi.value = jsonData['valueOfPi'].toString();
  horoscope.value = jsonData['horoscope'].toString();
  favOne.value = jsonData['favoriteThings'][0];
  favTwo.value = jsonData['favoriteThings'][1];
  favThree.value = jsonData['favoriteThings'][2];

  final chocolateRadioButton =
      jsonData['chocolate'] == false ? noLoveForChocolate : loveChocolate;
  chocolateRadioButton.checked = true;
}

// TODO(chalin): I'm currently minimizing changes, but make showJson private.
/// Display all values as JSON.
void showJson(Event _) {
  // Grab the data that will be converted to JSON.
  final favNum = int.tryParse(favoriteNumber.value);
  final pi = double.tryParse(valueOfPi.value);
  final chocolate = loveChocolate.checked;
  final sign = horoscope.value;
  final favoriteThings = <String>[
    favOne.value,
    favTwo.value,
    favThree.value,
  ];

  final formData = {
    'favoriteNumber': favNum,
    'valueOfPi': pi,
    'chocolate': chocolate,
    'horoscope': sign,
    'favoriteThings': favoriteThings
  };

  // Convert to JSON and display results.
  intAsJson.text = json.encode(favNum);
  doubleAsJson.text = json.encode(pi);
  boolAsJson.text = json.encode(chocolate);
  stringAsJson.text = json.encode(sign);
  listAsJson.text = json.encode(favoriteThings);
  mapAsJson.text = json.encode(formData);
}
{% endprettify %}
{% endcomment %}

<iframe
src="{{site.custom.dartpad.embed-html-prefix}}?id=1d42e4eadb75bcc1ffbc079e299b862e&horizontalRatio=50&verticalRatio=90"
    width="100%"
    height="600px"
    style="border: 1px solid #ccc;">
</iframe>

The `dart:convert` library contains two convenient functions
for working with JSON strings:

| dart:convert function | Description |
|---|---|
| [json.decode()][]{:target="_blank" rel="noopener"} | Builds Dart objects from a string containing JSON data. |
| [json.encode()][]{:target="_blank" rel="noopener"} |  Serializes a Dart object into a JSON string. |
{: .table}

To use these functions,
you need to import dart:convert into your Dart code:

<!--?code-excerpt "web/main.dart" retain="dart:convert"?-->
{% prettify dart %}
  import 'dart:convert';
{% endprettify %}

The `json.encode()` and `json.decode()` functions can handle these Dart types
automatically:

* `num`
* `String`
* `bool`
* `Null`
* `List`
* `Map`

## Serializing data into JSON

Use the [json.encode()][] function to serialize an object that supports JSON.
The `showJson()` function, from the example,
converts all of the data to JSON strings.

<!--?code-excerpt "web/main.dart (showJson)" indent-by="0" remove="FIXME" replace="/(\n\s+)(.*? json.encode.*?;)/$1[!$2!]/g"?-->
{% prettify dart %}
void showJson(Event _) {
  // Grab the data that will be converted to JSON.
  final favNum = int.tryParse(favoriteNumber.value);
  final pi = double.tryParse(valueOfPi.value);
  final chocolate = loveChocolate.checked;
  final sign = horoscope.value;
  final favoriteThings = <String>[
    favOne.value,
    favTwo.value,
    favThree.value,
  ];

  final formData = {
    'favoriteNumber': favNum,
    'valueOfPi': pi,
    'chocolate': chocolate,
    'horoscope': sign,
    'favoriteThings': favoriteThings
  };

  // Convert to JSON and display results.
  [!intAsJson.text = json.encode(favNum);!]
  [!doubleAsJson.text = json.encode(pi);!]
  [!boolAsJson.text = json.encode(chocolate);!]
  [!stringAsJson.text = json.encode(sign);!]
  [!listAsJson.text = json.encode(favoriteThings);!]
  [!mapAsJson.text = json.encode(formData);!]
}
{% endprettify %}

Shown below is the JSON string that results from the code
using the original values from the app:

<img class="scale-img-max" src="images/jsonstring.png"
     alt="The JSON string for the its_all_about_you app">

- **Numeric** and boolean values
  appear as they would if they were literal values in code,
  without quotes or other delineating marks.
- A **boolean** value is either `true` or `false`.
- The **null** value is represented as `null`.
- **Strings** are contained within _double_ quotes.
- A **list** is delineated with square brackets;
  its items are comma-separated.
  The list in this example contains strings.
- A **map** is delineated with curly brackets;
  it contains comma-separated key/value pairs,
  where the key appears first, followed by a colon,
  followed by the value.
  In this example,
  the keys in the map are strings.
  The values in the map vary in type but they are all JSON-parsable.

## Parsing JSON data

Use the [json.decode()][] function from the [dart:convert][] library to
create Dart objects from a JSON string.
The example initially populates the values in the form
from this JSON string:

<!--?code-excerpt "web/main.dart (jsonDataAsString)" indent-by="0" ?-->
{% prettify dart %}
final jsonDataAsString = '''{
  "favoriteNumber": 73,
  "valueOfPi": 3.141592,
  "chocolate": true,
  "horoscope": "Cancer",
  "favoriteThings": ["monkeys", "parrots", "lattes"]
}''';

Map jsonData = json.decode(jsonDataAsString);
{% endprettify %}

This code calls [json.decode()][] with a properly formatted JSON
string.

<aside class="alert alert-warning" markdown="1">
  **Note:** Dart strings can use either single or double
  quotes to denote strings. **JSON requires double quotes**.
</aside>

In this example, the full JSON string is hard coded into the Dart code,
but it could be created by the form itself
or read from a static file or fetched from a server.
An example later in this page shows how to dynamically fetch
JSON data from a file that is co-located with the code for the app.

The `json.decode()` function reads the string and
builds Dart objects from it.
In this example,
the `json.decode()` function creates a `Map` object based on
the information in the JSON string.
The `Map` contains objects of various types
including an integer, a double, a boolean value, a regular string,
and a list.
All of the keys in the map are strings.

## About URIs and HTTP requests {#about-uris}

To make an HTTP GET request from within a web app,
you need to provide a URI (Uniform Resource Identifier) for the resource.
A URI is a character string
that uniquely names a resource.
A URL (Uniform Resource Locator) is a specific kind of URI
that also provides the location of a resource.
URLs for resources on the World Wide Web
contain three pieces of information:

* The protocol used for communication
* The hostname of the server
* The path to the resource

For example, the URL for this page breaks down as follows:

<img class="scale-img-max" src="images/uri-details.png"
     alt="The tutorial URL">

This URL specifies the HTTP protocol.
When you enter an HTTP address into a web browser,
the browser sends an HTTP GET request to a web server,
and the web server sends an HTTP response that contains the
contents of the page (or an error message).

<img class="scale-img-max" src="images/client-server.png"
     alt="Basic HTTP communication between client and server">

Most HTTP requests in a web browser are simple GET requests
asking for the contents of a page.
However, the HTTP protocol allows for other types of requests,
such as POST for sending data from the client.

A Dart web app running inside of a browser can make HTTP requests.
These HTTP requests are handled by the browser in which the app is running.
Even though the browser itself can make HTTP requests anywhere on the web,
a Dart web app running inside the browser can make only *limited*
HTTP requests because of security restrictions.
Practically speaking,
because of these limitations,
HTTP requests from web apps are primarily useful for
retrieving information in files specific to
and co-located with the app.

<aside class="alert alert-info" markdown="1">
  **Security note:**
  Browsers place tight security restrictions on HTTP requests
  made by embedded apps.
  Specifically, any resources requested by a web app
  must be served from the same origin.
  That is, the resources must be from the same protocol, host, and port
  as the app itself.
  This means that your web app cannot request
  just any resource from the web with HTTP requests through the browser,
  even if that request is seemingly harmless (like a GET.)

  Some servers do allow cross-origin requests
  through a mechanism called
  CORS (Cross-origin resource sharing),
  which uses headers in an HTTP request
  to ask for and receive permission.
  CORS is server specific.
</aside>

The SDK provides these useful classes for
formulating URIs and making HTTP requests:

| Dart code | Library | Description |
|---|---|
| [Uri][] | [dart:core][] | Uniform resource identifier |
| [HttpRequest][HttpRequest] |  [dart:html][] | Client-side HTTP request object. For use in web apps. |
| [HttpRequest][HttpRequest@io] |  [dart:io][] | Server-side HTTP request object. Does not work in web apps. |
{: .table}

## Using getString() to load a file {#using-getString-function}

One useful HTTP request your web app *can* make is a GET request
for a data file served from the same origin as the app.
The example below reads a data file called `portmanteaux.json`
that contains a JSON-formatted list of words.
When you click the button,
the app makes a GET request of the server
and loads the file.

<aside class="alert alert-info" markdown="1">
  **Implementation note:**
  The original portmanteaux example loaded the co-located file `portmanteaux.json`.
  When we moved the example into [**DartPad**]({{site.custom.dartpad.direct-link}}),
  we couldn't co-locate the JSON file because DartPad
  supports at most 3 files: one Dart file, one HTML file,
  and one CSS file.
  A workaround was to move `portmanteaux.json` to dartlang.org and
  configure dartlang.org's CORS headers to allow read-only access
  from everywhere.
</aside>

**Try it!** Click run ( {% asset red-run.png %} )
and then click the **Get portmanteaux** button.

{% comment %} https://gist.github.com/chalin/6b76bce8d46986e624f4e82925c48287 {% endcomment %}
<iframe
src="{{site.custom.dartpad.embed-html-prefix}}?id=6b76bce8d46986e624f4e82925c48287&horizontalRatio=68&verticalRatio=80"
    width="100%"
    height="500px"
    style="border: 1px solid #ccc;">
</iframe>

This program uses a convenience method, [getString()][], provided by the
[HttpRequest][] class to request the file from the server.

<!--?code-excerpt "web/portmanteaux/main.dart (makeRequest)" indent-by="0" remove="FIXME" replace="/\/\/ \w.*/[!$&!]/g"?-->
{% prettify dart %}
Future<void> makeRequest(Event _) async {
  const path = 'https://www.dartlang.org/f/portmanteaux.json';
  try {
    [!// Make the GET request!]
    final jsonString = await HttpRequest.getString(path);
    [!// The request succeeded. Process the JSON.!]
    processResponse(jsonString);
  } catch (e) {
    [!// The GET request failed. Handle the error.!]
    // ···
  }
}

void processResponse(String jsonString) {
  for (final portmanteau in json.decode(jsonString)) {
    wordList.children.add(LIElement()..text = portmanteau);
  }
}
{% endprettify %}

The `getString()` method uses a Future object to handle the request.
A [Future][] is a way to perform potentially time-consuming operations,
such as HTTP requests, asynchronously.
If you haven't encountered Futures yet,
you can learn more about them in
[Asynchronous Programming: Futures](/tutorials/language/futures).
Until then, you can use the code above as a guide
and provide your own code for the body of the `processResponse()` function
and your own code to handle the error.

<aside class="alert alert-info" markdown="1">
  **Note:**
  The examples in this section use the `async` and `await` keywords.
  If you are not familiar with these keywords, see
  [Asynchrony support](/guides/language/language-tour#asynchrony)
  in the [language tour](/guides/language/language-tour).
</aside>

## Using an HttpRequest object to load a file {#making-a-get-request}

The `getString()` method is good for an HTTP GET request that returns
a string loaded from a resource.
For other cases,
you need to create an [HttpRequest][] object,
configure its header and other information,
and use the [send()][] method to make the request.

This section rewrites the portmanteaux code to explicitly construct
an HttpRequest object.

{% comment %} https://gist.github.com/chalin/c387e454cb751ab0632c68ccbbf94d12 {% endcomment %}
<iframe
src="{{site.custom.dartpad.embed-html-prefix}}?id=c387e454cb751ab0632c68ccbbf94d12&horizontalRatio=68&verticalRatio=80"
    width="100%"
    height="500px"
    style="border: 1px solid #ccc;">
</iframe>

### Setting up the HttpRequest object

The mouse-click handler for the button
creates an HttpRequest object,
configures it with a URI and callback function,
and then sends the request.
Let's take a look at the Dart code:

<!--?code-excerpt "web/portmanteaux2/main.dart (makeRequest)" indent-by="0" remove="FIXME" replace="/\/\/ \w.*/[!$&!]/g"?-->
{% prettify dart %}
Future<void> makeRequest(Event _) async {
  const path = 'https://dart.dev/f/portmanteaux.json';
  final httpRequest = HttpRequest();
  httpRequest
    ..open('GET', path)
    ..onLoadEnd.listen((e) => requestComplete(httpRequest))
    ..send('');
}
{% endprettify %}

<img class="scale-img-max" src="images/portmanteaux-code.png"
     alt="Making an HTTP GET request">

### Sending the request

The [send()][] method sends the request to the server.

{% prettify dart %}
httpRequest.send('');
{% endprettify %}

Because the request in this example is a simple GET request,
the code can send an empty string.
For other types of requests,
such as POST requests,
this string can contain relevant data.
You can also configure the HttpRequest object
by setting various header parameters using the [setRequestHeader()][] method.

### Handling the response

To handle the HTTP response,
you need to set up a callback function
before calling `send()`.
Our example sets up a one-line callback function
for [onLoadEnd][] events
that in turn calls `requestComplete()`.
This callback function is called when the request completes,
either successfully or unsuccessfully.

<img class="scale-img-max" src="images/set-callback.png"
     alt="Set up a callback function for request completion">

The `requestComplete()` function
checks the status code for the request.

<!--?code-excerpt "web/portmanteaux2/main.dart (requestComplete)" indent-by="0" replace="/request\.\w+(?=\))/[!$&!]/g"?-->
{% prettify dart %}
void requestComplete(HttpRequest request) {
  switch ([!request.status!]) {
    case 200:
      processResponse([!request.responseText!]);
      return;
    default:
      // The GET request failed. Handle the error.
      // ···
  }
}
{% endprettify %}

If the status code is 200,
the file was found and loaded successfully.
The content of the requested file (`portmanteaux.json`) is
returned in the [responseText][] property of an HttpRequest object.

### Populating the UI from JSON

The data file in the portmanteaux example,
`portmanteaux.json`,
contains the following JSON-formatted list of strings:

<!--?code-excerpt "web/portmanteaux.json" indent-by="0"?-->
{% prettify json %}
[
  "portmanteau", "fantabulous", "spork", "smog",
  "spanglish", "gerrymander", "turducken", "stagflation",
  "bromance", "freeware", "oxbridge", "palimony", "netiquette",
  "brunch", "blog", "chortle", "Hassenpfeffer", "Schnitzelbank"
]
{% endprettify %}

Upon request, the server reads the file
and sends it as a single string
to the client program.

Using [json.decode()][],
the app easily converts the JSON-formatted list of words
to a Dart list of strings,
creates a new [LIElement][] for each one,
and adds it to the `<ul>` element on the page.

<!--?code-excerpt "web/portmanteaux2/main.dart (processResponse)" indent-by="0" replace="/json\.\w+/[!$&!]/g"?-->
{% prettify dart %}
void processResponse(String jsonString) {
  for (final portmanteau in [!json.decode!](jsonString)) {
    wordList.children.add(LIElement()..text = portmanteau);
  }
}
{% endprettify %}

## Other resources

* [Using JSON](/guides/json)
* [Asynchronous programming: futures](/tutorials/language/futures)

[dart:convert]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/dart-convert-library.html
[dart:core]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/dart-core-library.html
[dart:html]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/dart-html-library.html
[dart:io]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/dart-io-library.html
[Future]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future-class.html
[getString()]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/HttpRequest/getString.html
[HttpRequest]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/HttpRequest-class.html
[HttpRequest@io]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpRequest-class.html
[json.decode()]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/JsonCodec/decode.html
[json.encode()]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/JsonCodec/encode.html
[LIElement]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/LIElement-class.html
[onLoadEnd]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/HttpRequestEventTarget/onLoadEnd.html
[responseText]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/HttpRequest/responseText.html
[send()]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/HttpRequest/send.html
[setRequestHeader()]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/HttpRequest/setRequestHeader.html
[Uri]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Uri-class.html
