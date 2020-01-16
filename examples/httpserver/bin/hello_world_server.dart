// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Replies "Hello, world!" to all requests.
// Use the URL localhost:4040 in your browser.
// #docregion
import 'dart:io';

Future main() async {
  // #docregion bind
  var server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    4040,
  );
  // #enddocregion bind
  print('Listening on localhost:${server.port}');

  // #docregion listen
  await for (HttpRequest request in server) {
    request.response.write('Hello, world!');
    await request.response.close();
  }
  // #enddocregion listen
}
