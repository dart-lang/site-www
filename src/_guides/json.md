---
title: "Support for JSON"
description: "Dart solutions for reading and writing JSON."
---

Most mobile and web apps use JSON for tasks such as
exchanging data with a web server.
This page discusses Dart support for JSON _serialization_ and _deserialization_:
converting Dart objects _to_ and _from_ JSON.


## Generally useful libraries

The following libraries and packages are useful across Dart platforms:

* [dart:convert](/guides/libraries/library-tour#dartconvert---decoding-and-encoding-json-utf-8-and-more)<br>
  Converters for both JSON and UTF-8
  (the character encoding that JSON requires).

* [package:json_serializable](https://pub.dartlang.org/packages/json_serializable)<br>
  Easy-to-use support for using the Dart build system to generate code that
  serializes and deserializes Dart objects.

* [package:built_value](https://pub.dartlang.org/packages/built_value)<br>
  A powerful, opinionated alternative to json_serializable.


## Flutter resources

[JSON and serialization](https://flutter.io/json/)
: Shows how Flutter apps can serialize and deserialize both
manually (with dart:convert) and automatically (with json_serializable).


## Web app resources

[Using HTTP resources with HttpRequest](https://webdev-dartlang-org-dev.firebaseapp.com/guides/html-library-tour#using-http-resources-with-httprequest)
: Shows how to use HttpRequest to exchange data with a web server.
  Part of the [HTML library tour.](https://webdev-dartlang-org-dev.firebaseapp.com/guides/html-library-tour)

[AngularDart Tutorial, part 6: HTTP](https://webdev-dartlang-org-dev.firebaseapp.com/angular/tutorial/toh-pt6)
: Illustrates how a Dart web app can interact with a
  RESTful backend using JSON data.


## VM resources

[Write HTTP Clients & Servers](/tutorials/dart-vm/httpserver)
: Demonstrates how to implement command-line clients and servers
  that exchange JSON data.


{% comment %}
## Other tools and resources
{% endcomment %}
