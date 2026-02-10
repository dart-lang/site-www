---
title: "Announcing official gRPC support for Dart"
description: "gRPC is a high performance, open source RPC framework. It offers simple service definitions, is built on http/2, and has support for…"
publishDate: 2018-03-23
author: mit-mit
category: announcements
tags:
  - programming
  - dart
  - flutter
  - grpc
  - announcements
layout: blog
---


<DashImage src="images/1tWFciSm58uLmvp8i_t3WaQ.png" />


gRPC is a high performance, open source RPC framework. It offers simple service definitions, is built on http/2, and has support for bi-directional streaming and fully integrated pluggable authentication. The gRPC framework supports a [wide range of languages](https://grpc.io/docs/), and we are happy to announce that support for the Dart language is now available in beta!Dart gRPC support works with the Dart SDK, version 1.24.3 or higher, and currently supports the [Flutter](https://flutter.io/) and [VM/Server](https://www.dartlang.org/dart-vm) platforms.

## Creating a server and writing gRPC service definitions

gRPC services typically describe their endpoints and data serialization using [Protocol Buffers](https://github.com/dart-lang/protobuf) v3. Here is a small example service definition which defines a service ‘Greeter’ with a single rpc message ‘SayHello’ (the number ‘1’ in the two messages specifies the unique ID of the [message field](https://developers.google.com/protocol-buffers/docs/overview)):


Once you have defined the service, you can automatically generate the skeleton of the server:

```
protoc --dart_out=grpc:generated -Iprotos protos/greeter.proto
```


This will produce a GreeterServiceBase class in the `generated` diretory, which you then subclass to add the actual service implementation:


## Calling the server with a gRPC client

When we generated the service stub above, the `protoc` compiler also generated a client library:


With that, calling into the service from the client tier is simple:


When run, this will print the following output:

```
Greeter client received: Hello, Michael!
```


## Next steps

To get started with gRPC in Dart, please take a look at our new [Dart gRPC QuickStart](https://grpc.io/docs/quickstart/dart.html), which walks you through running and extending the Greeter example. Next, check out the [Dart gRPC tutorial](https://grpc.io/docs/tutorials/basic/dart.html).

Should you encounter any problems, please [file an issue](https://github.com/grpc/grpc-dart/issues/new). We would also gladly hear your feedback on any changes or additions you like to see; for example, we have heard several requests for supporting the [gRPC-Web protocol](https://github.com/grpc/grpc-dart/issues/43). One concrete way of offering quick feedback is to ‘cast a vote’ on an issue by pressing the GitHub thumbs-up 👍 button on the top-most comment of an issue.

We look forward to seeing what you might build with gRPC for Dart!