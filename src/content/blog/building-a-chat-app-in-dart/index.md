---
title: "Building a Chat App in Dart"
description: "Having thoroughly covered the basics of the “built” packages I’m now ready to up the ante by showing them in action."
publishDate: 2016-12-14
author: "davidmorgan"
image: images/1pRJK2IRC697oavw5OBXkQA.png
category: other
tags:
  - dart
  - dartlang
  - front-end-development
  - programming
  - web-development
---


I wrote this code in a day and a half to use as an example in my [talk at the Dart summit (video)](https://www.youtube.com/watch?v=TMeJxWltoVo). It was designed to show off built_value and source_gen, but it also shows something about Dart: that you can do a *lot* with just the SDK and the core packages from [dart-lang](http://github.com/dart-lang).

<DashImage src="images/1pRJK2IRC697oavw5OBXkQA.png" alt="The built_value chat example in action." caption="The built_value chat example in action." />


## Getting the Code

You could read the code [here](https://github.com/google/built_value.dart/tree/8697b3e858c3af18246a1ac01ba7f582eab5428a/chat_example) but it’ll be more fun if you download and run it. To do that you’ll need [dart](https://www.dartlang.org/install) and [git](https://git-scm.com/downloads) installed. Then:

```
git clone [https://github.com/google/built_value.dart.git](https://github.com/google/built_value.dart.git)
cd built_value.dart
git checkout tags/v0.4.3-article
cd chat_example
pub get

# Run these three in separate terminal windows.
pub serve
dart bin/main.dart
dart tool/watch.dart
```


You can now go to localhost:26199 in Dartium, Chrome or any modern browser. You’ll see something like this:
> Welcome to the built_value chat example. For help, type /help.
> You are connected as anon9531.

It’s not particularly beautiful — but if you connect in a few more tabs, you’ll find it’s a fully functional chat application. It has login, away/status messages, and public and private messages.

If you change the code you’ll find that client changes are picked up immediately on refresh. For server changes, kill then relaunch “dart bin/main.dart”.

## What’s in a Chat App

Our server code is going to need to:

* serve HTML and CSS;

* track user state;

* send and receive messages.

The client is going to need to:

* provide a UI that displays text and accepts input;

* send and receive messages.

Let’s take this piece by piece.

## Serving HTML and CSS

I’m using [package:shelf](https://github.com/dart-lang/shelf#web-server-middleware-for-dart) from dart-lang. For a production service I’d want to pre-build resources to serve, but for now I’ll focus on developing, so HTML and CSS can just go straight to pub serve. Here’s a [Cascade](https://www.dartdocs.org/documentation/shelf/0.6.7%2B2/shelf/Cascade-class.html) that does that:

```
var cascade = new Cascade()
  // Try sending requests to pub serve.
  .add(proxyHandler(Uri.parse(‘[http://localhost:8080’](http://localhost:8080'))))
  // If that didn't work, must be a problem with pub serve.
  .add((_) {
    print(‘Request failed. Check pub serve output for errors.’);
    return new Response.notFound(‘’);
  });
```


And a server:

```
await io.serve(cascade.handler, 'localhost', 26199);
```


We’ll tweak this a bit later on to add message handling.

## Client UI

A chat client doesn’t need much UI, and the SDK is more than up to the job. First, the text field. We need [querySelector](https://api.dartlang.org/stable/1.21.0/dart-html/querySelector.html), [HtmlEscape](https://api.dartlang.org/stable/1.21.0/dart-convert/HtmlEscape-class.html) and [Window](https://api.dartlang.org/stable/1.21.0/dart-html/Window-class.html):

```
void addLocal(String text) {
  querySelector('#text').innerHtml +=
    '<div class="local">${_htmlEscape.convert(text)}</div>';
  window.scrollTo(0, document.body.scrollHeight);
}
```


And second, the input field. Here’s a class which turns text input in a [Stream&lt;String&gt;](https://api.dartlang.org/stable/1.21.0/dart-async/Stream-class.html) for anyone to consume:

```
class Input {
  final StreamController<String> _streamController =
      new StreamController<String>();

  Input() {
    final input = querySelector('#input') as InputElement;

    input.onKeyPress.listen((keyEvent) {
      if (keyEvent.keyCode == KeyCode.ENTER) {
        _streamController.add(input.value);
        input.value = '';
       }
    });
  }

  Stream<String> get keyboardInput => _streamController.stream;
}
```


These sit on top of some minimal [HTML](https://github.com/google/built_value.dart/blob/8697b3e858c3af18246a1ac01ba7f582eab5428a/chat_example/web/index.html) and [CSS](https://github.com/google/built_value.dart/blob/8697b3e858c3af18246a1ac01ba7f582eab5428a/chat_example/web/main.css). Then we need a little bit of code to make sure the input element starts with focus and keeps it:

```
var screen = querySelector('#screen');
var text = querySelector('#text');
var input = querySelector('#input');

input.focus();

for (var element in [screen, text]) {
  element.onClick.listen((e) {
    input.focus();
  });
}
```


And that’s *it*. No need for any kind of framework. Obviously, the UI is very minimal — if I wanted to do more I’d switch to [Angular](http://angulardart.org).

## Client-Server Communication

Chat applications need to be able to send messages from the server to the client, so simple POSTs aren’t enough. I opted to use [WebSocket](https://api.dartlang.org/stable/1.21.0/dart-html/WebSocket-class.html)s, which provide persistent two-way communication channels.

With shelf we can just add this to the start of our Cascade:

```
var cascade = new Cascade()
 .add(webSocketHandler(socketReceiver))
```


Where “socketReceiver” is a function that accepts the newly created [WebSocketChannel](https://www.dartdocs.org/documentation/web_socket_channel/1.0.4/web_socket_channel/WebSocketChannel-class.html)s. “webSocketHandler” will reject plain HTTP requests, so those will continue down the cascade.

Connecting from the client is likewise simple:

```
var socket = new WebSocket('ws://${window.location.host}/ws');
socket.onMessage.listen((message) => <handle message>);
socket.send('Hello server!');
```


Of course we need a wire format; since I wrote this code to show off built_value I’m of course using its [serialization](https://medium.com/@davidmorgan_14314/darts-built-value-for-serialization-f5db9d0f4159#.3nh1y6q6h). Just plain JSON with hand-written conversion would be straightforward — but the whole point of built_value is that you get that for free.

## Web Sockets and SSL

One side note: currently, the example uses non-encrypted connections. Unfortunately non-encrypted web socket connections can sometimes be blocked by badly-behaved proxies. The way to fix this is to switch to encrypting your entire site, i.e. making it “https” instead of “http”. This is a pain to do, but it’s arguably a good idea for [other reasons](https://letsencrypt.org/).

## Object Model

At the heart of the chat example is an object model that’s shared between the server and the client. Because we’re using built_value we can send these classes over the wire. For example, this class is used to send a chat:

```
abstract class Chat implements Command {
  String get text;
  BuiltSet<String> get targets;
}
```


The server login, client logic and client rendering are all built around these object model classes.

## Client Logic

When you type something the client code needs to match and handle possible commands. This is a simple matter of string matching followed by building and sending object model classes as appropriate. [Full code](https://github.com/google/built_value.dart/blob/8697b3e858c3af18246a1ac01ba7f582eab5428a/chat_example/lib/client/client.dart).

For example, if you type something starting with “/away”, it’s converted into a status update:

```
_send(new Status((b) => b
  ..message = command.substring(‘/away ‘.length)
  ..type = StatusType.away));
```


## Client Rendering

All the messages that the server can send implement this interface:

```
abstract class Response {
  String render();
}
```


And so on receiving a message the client simply calls “render” and displays the result. For example, the ShowChat class, which can hold public or private messages:

```
class ShowChat implements Response {
  String get username;
  bool get private;
  String get text;

  @override
  String render() =>
    '$username${private ? "(private)" : ""}: $text';
}
```


Incidentally, this pattern of encapsulating simple rendering logic inside data classes also works well for internationalization.

## Server Logic

In the server we keep the state: the chat log, usernames and passwords, and user statuses. When a message is received, we update the state and send out messages as needed. [Full code](https://github.com/google/built_value.dart/blob/8697b3e858c3af18246a1ac01ba7f582eab5428a/chat_example/lib/server/server.dart).

For example, here “command” is a message received from a client. If it’s a “chat” message, we check whether it’s intended to be private — if it specifies targets — and either send it to everyone or to just the targets, as appropriate.

```
if (command is Chat) {
  _chat(connection, command);
}

...

void _chat(ServerConnection connection, Chat chat) {
  if (chat.targets.isEmpty) {
    _sendToAll(new ShowChat((b) => b
      ..username = connection.username
      ..private = false
      ..text = chat.text));
  } else {
    _sendTo(
      chat.targets,
      new ShowChat((b) => b
        ..username = connection.username
        ..private = true
        ..text = chat.text));
  }
}
```


## That’s All, Folks

And there we have it — a chat server and client in 820 lines of code. For those keeping count, an additional 1120 lines is generated by built_value, and end to end testing took 155 lines.

Wait — end to end testing?

I said it took a day and a half to write; half-way through I got annoyed that every time I added a feature I had to manually test to make sure I hadn’t broken anything else. So I took a step back, refactored for testability, and added test coverage for the major features.

Next week I’ll walk through exactly how the chat example is tested, and just how great it is to test with Dart on both the server and client.

Edit: [next article](https://medium.com/@davidmorgan_14314/end-to-end-testing-in-one-short-second-with-dart-e699c8146fd6#.c7xfxohg4).