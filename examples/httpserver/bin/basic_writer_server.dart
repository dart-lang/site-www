// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Server to basic_writer_client.dart.
// Receives JSON encoded data in a POST request and writes it to
// the file specified in the URI.

import 'dart:io';
import 'dart:async';
import 'dart:convert';

Future main() async {
  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4049);
  await for (var req in server) {
    ContentType contentType = req.headers.contentType;

    if (req.method == 'POST' &&
        contentType != null &&
        contentType.mimeType == 'application/json') {
      try {
        var jsonString = await req.transform(UTF8.decoder).join();

        // Write to a file, get the file name from the URI.
        var filename = req.uri.pathSegments.last;
        await new File(filename)
            .writeAsString(jsonString, mode: FileMode.WRITE);
        Map jsonData = JSON.decode(jsonString);
        req.response
          ..statusCode = HttpStatus.OK
          ..write('Wrote data for ${jsonData['name']}.')
          ..close();
      } catch (e) {
        req.response
          ..statusCode = HttpStatus.INTERNAL_SERVER_ERROR
          ..write("Exception during file I/O: $e.")
          ..close();
      }
    } else {
      req.response
        ..statusCode = HttpStatus.METHOD_NOT_ALLOWED
        ..write("Unsupported request: ${req.method}.")
        ..close();
    }
  }
}
