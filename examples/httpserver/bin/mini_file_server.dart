// Copyright (c) 2014, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A server built using dart:io that serves the same file for all requests.
/// Visit http://localhost:4044 into your browser.
// #docregion
import 'dart:io';

File targetFile = File('web/index.html');

Future main() async {
  Stream<HttpRequest> server;

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
        await req.response.addStream(targetFile.openRead());
      } catch (e) {
        print("Couldn't read file: $e");
        exit(-1);
      }
    } else {
      print("Can't open ${targetFile.path}.");
      req.response.statusCode = HttpStatus.notFound;
    }
    await req.response.close();
  }
}
