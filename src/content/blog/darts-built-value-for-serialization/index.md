---
title: "Dart’s built_value for Serialization"
description: "Last week I introduced built_value for immutable object models. We saw how to define object models in built_value; they’re immutable, easy…"
publishDate: 2016-12-07
author: "davidmorgan"
category: other
tags:
  - programming
  - dart
  - dartlang
  - immutability
  - json
---


Last week I introduced [built_value for immutable object models](https://medium.com/@davidmorgan_14314/darts-built-value-for-immutable-object-models-83e2497922d4). We saw how to define object models in built_value; they’re immutable, easy to work with, and, if you like that sort of thing, a lot of fun.

This article covers the rest of the built_value package. The biggest item is that, as you may have guessed from the title, they’re also serializable.

Here’s what built_value serialization looks like to use:

```
// Value type defined using built_value.
abstract class Login implements Built<Login, LoginBuilder> {
  // Add serialization support by defining this static getter.
  static Serializer<Login> get serializer => _$loginSerializer;

  ...
}

// Once per app, define a top level "Serializer" to gather together
// all the generated serializers.
Serializers serializers = _$serializers;

// Use it!
var login = new Login((b) => b
  ..username = 'johnsmith'
  ..password = '123456');

print(JSON.encode(serializers.serialize(login)));
-->
["Login", "username", "johnsmith", "password", "123456"]
```


Notice the “JSON.encode”? The serializer doesn’t actually go as far as serializing to a String; rather it converts to primitives that Dart’s built-in JSON serialization knows how to handle. So if you want to, you can use something other than JSON.

You probably think of serialization as something that should “just work”, but there are a few subtle trade-offs involved. Let’s dig into built_value’s serialization.

## Polymorphism

The single most important aspect of built_value’s serialization is that it supports polymorphism. Specifically, you can have fields of *abstract* types, and

* any serializable implementation of that abstract type can be serialized;

* enough information will be written on the wire to deserialize to the correct types.

The simplest example is that it can serialize a list of Object:

```
serializers.serialize(new BuiltList<Object>([1, 'two', 3]));
-->
['list', ['int', 1, 'string', 'two', 'int', 3]]
```


Extra information is added on the wire only as required to disambiguate when deserializing. So if you have a field of type “BuiltList&lt;int&gt;”, it will be serialized like “[1, 2, 3]” and not like “[‘int’, 1, ‘int’, 2, ‘int’, 3]”.

The bottom line is that you can define your object model however you like, and built_value will serialize it. If you want to see this in more detail, the [map serializer test](https://github.com/google/built_value.dart/blob/master/built_value/test/built_map_serializer_test.dart) explores all the possibilities.

## Multiple Implementations

Another problem all serialization mechanisms have to face is somehow defining the *universe* of serializable types. Here built_json does something a little unusual by allowing *multiple implementations* of one “type”.

This works because types are defined on the wire by their *class name only*. No attempt is made to disambiguate between different classes called “Login”, for example; it’s assumed that both sender and receiver have a compatible serializer for a class called “Login” available.

This adds useful flexibility. If you’re using Dart on the server and the client, for example, you have a *choice* for each class in the object model:

* You can use the same class on the client and server.

* Or, you can use different classes. The implementations must have the same name and compatible fields.

For example, you could have a “Login” class for the client that deals with rendering and parsing; and a separate “Login” class for the server that deals with authentication and databases. Of course, the server-only implementation is free to use packages like “dart:io”, and the client-only implementation packages like “dart:html”.

## Multiple Languages

Because built_value serialization identifies types by the class name alone, the serialized data maps well onto any object oriented language. Support for Java is planned via [AutoValue](https://github.com/google/auto/tree/master/value).

## Multiple Versions

Serialized built_value data is backwards/forwards compatible in a very simple way: it relies on class names and field names. Class name changes and required field name changes are breaking.

Nullable fields are more flexible: on serialization, they will only be written if non-null; on deserialization, they will default to null if not found. So, nullable fields can be added, removing or renamed and this is not a breaking change.

Unrecognized fields are simply ignored.

## No Mirrors

Finally, and crucial for performance, is that built_value doesn’t use mirrors in any shape or form. All analysis is done at codegen time, leaving you with minimal, performant serialization code.

That was serialization with built_value. You can just sit down and write an object model and it is straight away serializable for use in RPCs or for long term storage.

## EnumClass

Finally, built_value comes with one more feature: EnumClass. Dart enums [aren’t classes](https://www.dartlang.org/guides/language/language-tour#enumerated-types), but a powerful object model needs enums that behave like classes. The obvious pattern is to create a class with “static const” fields, and EnumClass makes this a little easier to do. It provides:

* Generated code for “values” and “valueOf”.

* Serialization via built_value serializers.

* An extra bonus for Angular or Angular2 users: the codegen can optionally produce a mixin to help you use the enum from templates.

All of these features can be seen in the [example](https://github.com/google/built_value.dart/blob/master/example/lib/enums.dart).

That’s it for this week! Having covered the basics of built_value I’m ready to dive into the chat example in detail next week. Stay tuned!

Edit: [next article](https://medium.com/@davidmorgan_14314/building-a-chat-app-in-dart-815fcd0e5a31#.ncnhb2fh0).