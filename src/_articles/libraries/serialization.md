---
title: "Serialization in Dart"
description: "Choose the serialization strategy that's right for your project."
written: 2015-02-09
updated: 2017-03-15
category: libraries
obsolete: true
---

<aside class="alert alert-info" markdown="1">
**Note:** This article is a bit outdated. Its general information and approach
are still useful, but it doesn't cover new software such as the
[built_value package](https://pub.dartlang.org/packages/built_value).
For more up-to-date information and discussion of Dart serialization
solutions, see the unofficial repo
[matanlurey/dart_serialize_proposals](https://github.com/matanlurey/dart_serialize_proposal).
</aside>

_Written by Nicolas Garnier<br>
February 2015 (note added March 2017)_

Being able to serialize and deserialize objects is a common task in web apps.
Here are a few typical cases of using serialization:

* Communication with an external system, API, or web service
* Storing objects in a database
* Sending objects between a Dart web client and a Dart server

This article provides an overview of
serialization strategies for Dart programs.
You will learn how to evaluate, choose, and implement
a serialization solution that best fits your app.


## Overview

After looking at many serialization options for Dart,
we reviewed three solutions in depth:

[dartson](https://pub.dartlang.org/packages/dartson)
: Simple JSON for simple objects.

[serialization](https://pub.dartlang.org/packages/serialization)
: A custom format for complex Dart objects.

[protobuf](https://pub.dartlang.org/packages/protobuf)
: Google's [protocol buffer](https://developers.google.com/protocol-buffers/)
  format.

As the following table shows,
dartson is the easiest of the three to install and use.
Unless you need to use protocol buffers or exchange complex Dart objects,
try dartson first.

|                         | dartson  | serialization | protobuf |
|-------------------------|----------|---------------|----------|
|Easy to install          | &#x2713; | &#x2713;      |
|Easy to use              | &#x2713; |               |
|Stable data format       | &#x2713; |               | &#x2713;
|Works with non-Dart languages | &#x2713; |          | &#x2713;
|Supports complex objects |          | &#x2713;      |
|Works well with dart2js  | &#x2713; | &#x2713;      | &#x2713;
{: .table}

Other compelling options are likely to exist on
[pub.dartlang.org](https://pub.dartlang.org/),
so we encourage you to look around.
We focused on these solutions because they
are all dart2js-friendly—they
don't rely on mirrors,
although some also provide a mirror-based implementation.

### Why do mirrors matter?

As a rule, avoid mirrors in code that runs in the browser.
When dart2js compiles Dart code to JavaScript,
the dynamic nature of mirrors interferes with tree shaking,
and can dramatically increase the size of the generated JavaScript.

For example, simple testing with a sample project shows
a generated code size of 133KB for
the mirrors version of dartson (with @MirrorsUsed annotations),
compared to 56KB for the static, non-mirrors version.


### What is simple JSON? {#simple-json}

We use _simple JSON_ throughout this article to refer to
the default object JSON serialization representation used in JavaScript.
When using JSON in JavaScript, objects are serialized by default to
a map of their properties with certain special cases.
(For example, JavaScript Dates are serialized to ISO8601 strings,
by default.)

We are calling this _simple JSON_, and not just _JSON_,
to differentiate it from other JSON-based serialization formats.
For example, protobuf has a JSON-based representation
that isn't simple JSON.

Simple JSON serialization is becoming a de facto standard,
and is available in libraries for many programming languages.


### What does your project need?

Here are some criteria that can affect
your choice of a serialization solution,
along with examples of how they could apply to your project.

Object complexity:

* Simple:
  All of the objects to be serialized are
  [data transfer objects](http://en.wikipedia.org/wiki/Data_transfer_object)
  (DTOs)
  with a [default constructor](/guides/language/language-tour#default-constructors).
* Complex:
  Some or all of the objects to be serialized have cycles,
  can't be created with no-argument constructors,
  or have special setter methods.

Serialization format:

* Predefined:
  You must use a specific serialization data format, like
  [simple JSON](#simple-json) or
  [protocol buffers](https://developers.google.com/protocol-buffers/).
* Open:
  You are free to use your own serialization format because
  you control both the emitting (serializing) and
  receiving (deserializing) systems.

Cross-language support:

* Required:
  The code that serializes or deserializes the objects
  might not be written in Dart.
* Not required:
  Serialization and deserialization always happen in Dart code.

Browser support:

* Required: You need to serialize or deserialize in the browser (when Dart is
  compiled to JavaScript), so small generated JavaScript code size is
  important.
* Not required: Your app runs only in the Dart VM. (It's a server or
  command-line tool.)

Data format stability:

* Required: You need a stable, well-defined data format that won't change
  over time.
* Not required: The data is serialized for transient operations only.

Identifying your criteria is important because
no serialization library or data format works in every scenario.
Some criteria are even mutually exclusive—for example,
simple JSON cannot represent objects with circular dependencies.


## Reviews

Once you know what your project needs,
you're ready to find a solution that matches those needs.
This section reviews three solutions:

* [dartson](#dartson-review)
* [serialization](#serialization-review)
* [protobuf](#protobuf-review)


### dartson {#dartson-review}

Recommended use cases:

* Communication with a web service using simple JSON as the data format
* Communication between between a web client and a server written in
  different languages

<aside class="alert alert-info" markdown="1">
**Note:**
Dartson is a community project started by
[Eric Schneller](https://github.com/eredo).
</aside>

Dartson allows serializing to and deserializing from
[simple JSON](#simple-json).
Several Dart packages offer simple JSON serialization,
but a significant advantage of dartson is that
it doesn't require mirrors.
Instead, it provides a
[pub transformer](/tools/pub/assets-and-transformers)
that generates static serialization rules.

You can provide custom serialization rules
using _type transformers_—dartson-specific
classes not to be confused with pub transformers.
For example, the dartson package supplies a DateTime type transformer,
implemented in
[transformers/date_time.dart](https://github.com/eredo/dartson/blob/master/lib/transformers/date_time.dart).
You can create your own serialization rules by subclassing
[TypeTransformer](https://www.dartdocs.org/documentation/dartson/latest/dartson.type_transformer/TypeTransformer-class.html).

During development,
you can use dartson's mirrors-based implementation
to avoid waiting for builds.
When you're ready to deploy,
building with the pub transformer replaces the mirrors-based implementation
with statically generated rules.

Pros:

* Produces and reads simple JSON.
* Compiles to smaller JavaScript code than other options.
* Allows you to use mirrors during development
  (no need to wait for the build).
* Has good cross-language support:
  Lots of simple JSON
  libraries are available in other programming languages.

Cons:

* Must know the class that the object is being serialized into.
* Must use only public classes.
* Except for basic types
  (numbers, booleans, strings, lists, and maps),
  must either annotate each serializable class as `@Entity` or
  provide a type transformer.
* Can't always infer the type of objects when deserializing.
  For example, if a field declared as `List<Person>` is actually
  a `List<Superhero>`, then you lose the type information about Superhero.
* Can't serialize some complex objects.
  For example, you can't serialize objects with cycles
  (objects that point to themselves, directly or indirectly),
  objects with fields defined using abstract classes
  (abstract classes can't be instantiated),
  and objects that declare constructors.

If you are looking for alternatives to
[dartson](#dartson-review)
that work with simple JSON,
here are a few. All require mirrors,
and thus should be used only with the Dart VM:

* [json_object](https://pub.dartlang.org/packages/json_object)
* [exportable](https://pub.dartlang.org/packages/exportable)
* [jsonx](https://pub.dartlang.org/packages/jsonx)

For more information about dartson, see these resources:

* Step-by-step how-to: [dartson example](#dartson-example)
* Source code: <https://github.com/eredo/dartson>
* Homepage: <https://pub.dartlang.org/packages/dartson>


### serialization {#serialization-review}

Recommended use case:

* Sending objects between a Dart client and a Dart server
  that are built and deployed together

<aside class="alert alert-info" markdown="1">
**Note:**
The serialization package is a community contribution from Google, but
it's not part of the Dart SDK.
</aside>

The serialization package offers a powerful
serialization and deserialization mechanism with the goal of
allowing (de)serialization of complex arbitrary objects
(with some limitations).
This package handles the following cases transparently:

* Object graphs with relationships, including cycles
* Inheritance
* Final fields
* Objects with declared constructors
* Private fields with getter/setter pairs
* Not knowing ahead of time which classes the serialized data uses

By default, the serialization package uses a custom representation.
However, the serialization package is pluggable to some extent, so
you can customize the serialization format.
For example, the serialization package can serialize to simple JSON
(but not deserialize).
It's best used with its default format, however,
which makes it a Dart-only option.

Because the serialized format can change from one build to another—depending
on the objects you're serializing and whether you're using mirrors—this
package is best used for transient data,
in clients and servers that are always built and deployed together.

Pros:

* Can serialize most Dart objects.
* Pluggable, so you can define custom output formats.
* Supports simple JSON
  (but not for deserialization).

Cons:

* Dart-only technology.
* Works best with its own data format.
* Unstable data format,
  which makes this package
  suitable for transient operations only,
  and only when both sides are built together.

For more information about the serialization package, see these resources:

* Step-by-step how-to: [serialization example](#serialization-example)
* Source code: <https://github.com/google/serialization.dart>
* Homepage: <https://pub.dartlang.org/packages/serialization>


### protobuf {#protobuf-review}

Recommended use cases:

* Persisting objects to a database
* Communication with a web service that expects
  protocol buffers as the data format
* Communication between a web client and a server written in
  different languages

<aside class="alert alert-info" markdown="1">
**Note:**
The protobuf package is a community contribution from Google, but
it's not part of the Dart SDK.
</aside>

[Protocol buffers](https://developers.google.com/protocol-buffers/)
(_protobufs_)
are a language-neutral way
to serialize structured data.
[Third-party add-ons](https://github.com/google/protobuf/wiki/Third-Party-Add-ons)
provide provide protocol buffer support for many programming languages,
including Dart.

Protocol buffers have a very compact binary format, as well as
a JSON-based human-readable format.
The data structure is defined in `.proto` files,
which a compiler (_protoc_)
uses to generate serialization rules and DTOs.

To use protocol buffers in Dart code, you must generate
a data transfer Dart class using protoc and
the [Dart plugin](https://github.com/dart-lang/dart-protoc-plugin).
If you're interacting with a system that provides data as protocol buffers,
that system should provide the `.proto` file.

One downside of protocol buffers is that they aren't very flexible.
You're limited to using a fixed set of [scalar value
types](https://developers.google.com/protocol-buffers/docs/proto#scalar),
plus whatever custom, generated classes are specified by the `.proto` file.
For example, you can't use
Dart's DateTime class directly in your serializable objects
because only new classes generated by protoc can be serialized.

Pros:

* Supports the protocol buffer serialization format,
  which is compact and supported by Google APIs such as
  [Google Cloud Datastore](https://cloud.google.com/datastore/docs/concepts/overview).
* Very good cross-language support.
* Well-defined, stable, backward-compatible format.

Cons:

* Must know the class to serialize into.
* Can't serialize into predefined Dart classes;
  DTOs are entirely generated by the protoc compiler.

For more information about using protocol buffers, see these resources:

* Step-by-step how-to: [protobuf example](#protobuf-example)
* Protocol buffer documentation:
  <https://developers.google.com/protocol-buffers/>
* protobuf package: <https://pub.dartlang.org/packages/protobuf>
* Dart plugin for protoc: <https://github.com/dart-lang/dart-protoc-plugin>


## Examples {#examples}

This section shows how to quickly get started with
the reviewed libraries,
featuring code from examples in
[this GitHub repo](https://github.com/nicolasgarnier/dart-serialization-samples).

The examples serialize and deserialize Person objects.
When defined in Dart code, the Person class looks like this:

{% prettify dart %}
class Person {
  int id;
  String name;
  DateTime dateOfBirth;
  List<Person> children;
}
{% endprettify %}

Dart code might create Person objects like this:

{% prettify dart %}
Person jerome = new Person()
  ..id = 228
  ..name = "Jerome Dole"
  ..dateOfBirth = new DateTime(2013, 1, 19);

Person sarah = new Person()
  ..id = 201
  ..name = "Sarah Dole"
  ..dateOfBirth = new DateTime(2011, 4, 9);

Person bob = new Person()
  ..id = 123
  ..name = "Bob Dole"
  ..dateOfBirth = new DateTime(1980, 3, 16)
  ..children = (new List()..add(jerome)..add(sarah));
{% endprettify %}

The `bob` object,
when serialized using simple JSON,
looks something like this:

{% prettify yaml %}
{
    "id": 123,
    "name": "Bob Dole",
    "dateOfBirth": "1980-03-16T00:00:00Z",
    "children": [{
        "id": 228,
        "name": "Jerome Dole",
        "dateOfBirth": "2013-01-19T00:00:00Z"
    },
    {
        "id": 201,
        "name": "Sarah Dole",
        "dateOfBirth": "2011-04-09T00:00:00Z"
    }]
}
{% endprettify %}


### dartson {#dartson-example}

<ol markdown="1">
<li markdown="1">
  Edit the project's `pubspec.yaml`,
  adding a dependency on the dartson package and its pub transformer:

{% prettify yaml %}
...
dependencies:
  dartson: ">=0.2.0 <0.3.0"
transformers:
- dartson
{% endprettify %}
</li>

<li markdown="1">
  Annotate your serializable classes with `@Entity()`. For example:

{% prettify dart %}
@Entity()
class Person {
  ...
}
{% endprettify %}
</li>

<li markdown="1">
  Import `dartson.dart` and the libraries for any type transformers
  that you need.

{% prettify dart %}
import 'package:dartson/dartson.dart';
import 'package:dartson/transformers/date_time.dart';
{% endprettify %}
</li>

<li markdown="1">
  Create an instance of
  [Dartson](https://www.dartdocs.org/documentation/dartson/latest/index.html),
  and add any type transformers you need:

{% prettify dart %}
var dson = new Dartson.JSON();
dson.addTransformer(new DateTimeParser(), DateTime);
{% endprettify %}
</li>

<li markdown="1">
  Serialize objects using Dartson's `encode()` method.

  For example, the following code serializes the `bob` Person object,
  along with the two Person objects that are children of `bob`:

{% prettify dart %}
String personString = dson.encode(bob);
print("Serialized Person: $personString");
{% endprettify %}

  Here's the output of that print:

{% prettify sh %}
Serialized Person: {"id":123,"name":"Bob Dole","dateOfBirth":"1980-03-16T00:00:00Z","children":[{"id":228,"name":"Jerome Dole","dateOfBirth":"2013-01-19T00:00:00Z"},{"id":201,"name":"Sarah Dole","dateOfBirth":"2011-04-09T00:00:00Z"}]}
{% endprettify %}
</li>

<li markdown="1">
  Deserialize objects using Dartson's `decode()` method:

{% prettify dart %}
Person deserializedPerson = dson.decode(personString, new Person());
{% endprettify %}
</li>
</ol>


### serialization {#serialization-example}

This package is still changing. See the
[serialization package page](https://pub.dartlang.org/packages/serialization)
for the latest details.


### protobuf {#protobuf-example}

<ol markdown="1">
<li markdown="1">
  Install the protocol compiler, **protoc**.

  You can find instructions in the protocol buffer
  [download page](https://developers.google.com/protocol-buffers/docs/downloads).
  Or, on a Mac:

  `brew install protobuf`
</li>

<li markdown="1">
  Install the Dart protobuf plugin:

  * Go to the
    [dart-lang/dart-protoc-plugin repo](https://github.com/dart-lang/dart-protoc-plugin),
    and clone it or download its ZIP file.
  * In the top directory of your copy of dart-protoc-plugin, run:
    `pub install && make build-plugin`.
  * Add `out/protoc-gen-dart` to your PATH.
</li>
<br>
<li markdown="1">
  Write a `.proto` file or use an existing one
  provided by the API you are communicating with.

  The `.proto` file describes the data types.
  For example, here is a simple `.proto` file for Person objects:

{% prettify dart %}
message Person {
    required int32 id = 1;
    required string name = 2;
    required uint64 date_of_birth = 3;
    repeated Person children = 4;
}
{% endprettify %}

Note that the Person object can't use DateTime.
Instead, the `.proto` file uses a 64-bit integer for the field.
The Dart code for creating a Person object looks like this:

{% prettify dart %}
Person bob = new Person()
  ..id = 123
  ..name = "Bob Dole"
  ..dateOfBirth = new Int64(new DateTime(1980, 3, 16).millisecondsSinceEpoch)
  ..children.add(jerome)
  ..children.add(sarah);
{% endprettify %}
</li>

<li markdown="1">
  In your project's `pubspec.yaml` file,
  add protobuf as a dependency:

{% prettify yaml %}
dependencies:
  protobuf: ">=0.3.4 <0.4.0"
{% endprettify %}
</li>

<li markdown="1">
  Compile your `.proto` file:

{% prettify sh %}
protoc --dart_out=. person.proto
{% endprettify %}

  This generates a Dart file containing
  serialization and deserialization rules.
</li>

<li markdown="1">
  Import the newly created file in your code.

{% prettify dart %}
import 'person.pb.dart'; // This is the file generated by protoc.
{% endprettify %}
</li>

<li markdown="1">
  Serialize objects using one of the generated write methods,
  which you can find in the
  [GeneratedMessage class API docs](https://www.dartdocs.org/documentation/protobuf/latest/protobuf/GeneratedMessage-class.html).

{% prettify dart %}
Uint8List personBuffer = bob.writeToBuffer();
String personJson = bob.writeToJson();
{% endprettify %}
</li>

<li markdown="1">
  Deserialize objects using one of the generated constructors.
  These constructors are named like the
  [GeneratedMessage](https://www.dartdocs.org/documentation/protobuf/latest/protobuf/GeneratedMessage-class.html) constructors.

{% prettify dart %}
Person deserializedPerson1 = new Person.fromBuffer(personBuffer);
Person deserializedPerson2 = new Person.fromJson(personJson);
{% endprettify %}
</li>
</ol>


## Size comparisons

The serialization solution you choose affects not only the size
of serialized objects,
but also the size of the JavaScript generated (for web apps
that serialize or deserialize).
The tables in this section show size measurements
for the example apps described in the [Examples](#examples) section
(source code is [on
GitHub](https://github.com/nicolasgarnier/dart-serialization-samples)).

The following table matters only if you're writing code for web apps.
It shows the size of the example app,
after dart2js compiles the app into JavaScript.

| Serialization technique               | Generated JavaScript code size |
|---------------------------------------|----------------------------------:|
| **dartson** using a pub transformer                              |  56 KB |
| **dartson** using mirrors                                        | 133 KB |
| **protobuf** using the binary formatter                          | 100 KB |
| **protobuf** using the JSON-based formatter                      |  81 KB |
| **serialization** using a pub transformer                        |  74 KB |
| **serialization** using mirrors and @MirrorsUsed() annotation    | 154 KB |
| **serialization** using mirrors without @MirrorsUsed() annotation| 785 KB |
{: .table .table-striped}

The next table shows the size of the serialized Person object (`bob`)
that the examples create using each solution.

| Serialization technique             | Serialized object size | GZipped size |
|-------------------------------------|-----------------------:|-------------:|
| **dartson**\*                       | 227 bytes              | 163 bytes    |
| **protobuf** (binary format)        |  68 bytes              | n/a          |
| **protobuf** (JSON-based format)    | 138 bytes              | 120 bytes    |
| **serialization** with transformer  | 405 bytes              | 199 bytes    |
| **serialization** with mirrors\*\*  | 948 bytes              | 302 bytes    |
{: .table .table-striped}

\* Unoptimized. You can decrease the output size
by choosing shorter names for fields—for example,
"dob" instead of "dateOfBirth".

\*\* The mirror-based implementation of the serialization package
produces different output than the pub-transformer-based implementation.


## Summary

Serialization sounds simple at first,
but no solution fits every situation.
Factors in choosing a solution include
the complexity of serialized objects,
the serialization format,
the stability of that format,
the need for cross-language support,
and the desire to generate small JavaScript.

This article covered three solutions,
recommending dartson as a starting point.
To find more solutions,
[search pub.dartlang.org for serialization](https://pub.dartlang.org/search?q=serialization).
