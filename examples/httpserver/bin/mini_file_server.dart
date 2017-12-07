// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Serves the index.html in the same directory as this script.
// Use the URL localhost:4044 in your browser.
// For a similar server that uses http_server package
// see basic_file_server.dart.

import 'dart:io';
import 'dart:async';

Future main() async {
  var server;

  try {
    server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4044);
  } catch (e) {
    print("Couldn't bind to port 4044: $e");
    exit(-1);
  }

  await for (HttpRequest req in server) {
    var file = new File('index.html');
    if (await file.exists()) {
      print("Serving index.html.");
      req.response.headers.contentType = ContentType.HTML;
      try {
        await file.openRead().pipe(req.response);
      } catch (e) {
        print("Couldn't read file: $e");
        exit(-1);
      }
    } else {
      print("Can't open index.html.");
      req.response
        ..statusCode = HttpStatus.NOT_FOUND
        ..close();
    }
  }
}
