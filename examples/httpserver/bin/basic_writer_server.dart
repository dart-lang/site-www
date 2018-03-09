// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Server to basic_writer_client.dart.
// Receives JSON encoded data in a POST request and writes it to
// the file specified in the URI.

// #docregion
import 'dart:async';
import 'dart:io';
import 'dart:convert';

String _host = InternetAddress.LOOPBACK_IP_V4.host;

Future main() async {
  var server = await HttpServer.bind(_host, 4049);
  await for (var req in server) {
    ContentType contentType = req.headers.contentType;
    HttpResponse response = req.response;

    if (req.method == 'POST' &&
        contentType?.mimeType == 'application/json' /*1*/) {
      try {
        String content =
            await req.transform(utf8.decoder).join(); /*2*/
        var json = JSON.decode(content) as Map; /*3*/
        var fileName = req.uri.pathSegments.last; /*4*/
        await new File(fileName)
            .writeAsString(content, mode: FileMode.WRITE);
        req.response
          ..statusCode = HttpStatus.OK
          ..write('Wrote data for ${json['name']}.');
      } catch (e) {
        response
          ..statusCode = HttpStatus.INTERNAL_SERVER_ERROR
          ..write("Exception during file I/O: $e.");
      }
    } else {
      response
        ..statusCode = HttpStatus.METHOD_NOT_ALLOWED
        ..write("Unsupported request: ${req.method}.");
    }
    response.close();
  }
}
