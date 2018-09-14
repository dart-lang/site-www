---
title: JSON Support
description: Dart solutions for reading and writing JSON.
---

Most mobile and web apps use JSON for tasks such as
exchanging data with a web server.
This page discusses Dart support for JSON _serialization_ and _deserialization_:
converting Dart objects to and from JSON.


## Libraries

The following libraries and packages are useful across Dart platforms:

* [dart:convert](/guides/libraries/library-tour#dartconvert---decoding-and-encoding-json-utf-8-and-more)<br>
  Converters for both JSON and UTF-8
  (the character encoding that JSON requires).

* [package:json_serializable](https://pub.dartlang.org/packages/json_serializable)<br>
  An easy-to-use code generation package.
  When you add some metadata annotations
  and use the builder provided by this package,
  the Dart build system generates serialization and deserialization code for you.

* [package:built_value](https://pub.dartlang.org/packages/built_value)<br>
  A powerful, opinionated alternative to json_serializable.


## Flutter resources

[JSON and serialization](https://flutter.io/json/)
: Shows how Flutter apps can serialize and deserialize both
  with dart:convert and with json_serializable.


## Web app resources

[AngularDart Tutorial, part 6: HTTP]({{site.webdev}}/angular/tutorial/toh-pt6)
: Illustrates how a Dart web app can interact with a
  RESTful backend using JSON data.

[Using HTTP resources with HttpRequest]({{site.webdev}}/guides/html-library-tour#using-http-resources-with-httprequest)
: Demonstrates how to use HttpRequest to exchange data with a web server.
  Part of the [HTML library tour.]({{site.webdev}}/guides/html-library-tour)


## VM resources

[Write HTTP Clients & Servers](/tutorials/dart-vm/httpserver)
: Walks through how to implement command-line clients and servers
  that exchange JSON data.


{% comment %}
## Other tools and resources
{% endcomment %}
