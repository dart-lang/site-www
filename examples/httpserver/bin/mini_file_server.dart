// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Serves the index.html in the same directory as this script.
// Use the URL localhost:4044 in your browser.
// For a similar server that uses http_server package
// see basic_file_server.dart.

// #docregion
import 'dart:io';

File targetFile = File('index.html');

Future main() async {
  var server;

  try {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4044);
  } catch (e) {
    print("Couldn't bind to port 4044: $e");
    exit(-1);
  }

  await for (HttpRequest req in server) {
    if (await targetFile.exists()) {
      print("Serving ${targetFile.path}.");
      req.response.headers.contentType = ContentType.html;
      try {
        await targetFile.openRead().pipe(req.response);
      } catch (e) {
        print("Couldn't read file: $e");
        exit(-1);
      }
    } else {
      print("Can't open ${targetFile.path}.");
      req.response.statusCode = HttpStatus.notFound;
      await req.response.close();
    }
  }
}
