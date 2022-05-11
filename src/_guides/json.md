---
title: Using JSON
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

* [package:json_serializable]({{site.pub-pkg}}/json_serializable)<br>
  An easy-to-use code generation package.
  When you add some metadata annotations
  and use the builder provided by this package,
  the Dart build system generates serialization and deserialization code for you.

* [package:built_value]({{site.pub-pkg}}/built_value)<br>
  A powerful, opinionated alternative to json_serializable.


## Flutter resources

[JSON and serialization]({{site.flutter-docs}}/development/data-and-backend/json)
: Shows how Flutter apps can serialize and deserialize both
  with dart:convert and with json_serializable.


## Web app resources

[Using HTTP resources with HttpRequest](/guides/libraries/library-tour#using-http-resources-with-httprequest)
: Demonstrates how to use HttpRequest to exchange data with a web server.
  Part of the [dart:html library tour.](/guides/libraries/library-tour#darthtml)


{% comment %}
## VM resources

[Write HTTP servers](/tutorials/server/httpserver)
: Walks through how to implement command-line clients and servers
  that exchange JSON data.

## Other tools and resources
{% endcomment %}
