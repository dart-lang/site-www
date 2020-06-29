// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Server to basic_writer_client.dart.
// Receives JSON encoded data in a POST request and writes it to
// the file specified in the URI.

// #docregion
import 'dart:io';
import 'dart:convert';

String _host = InternetAddress.loopbackIPv4.host;

Future main() async {
  var server = await HttpServer.bind(_host, 4049);
  await for (var req in server) {
    ContentType contentType = req.headers.contentType;
    HttpResponse response = req.response;

    if (req.method == 'POST' &&
        contentType?.mimeType == 'application/json' /*1*/) {
      try {
        String content =
            await utf8.decoder.bind(req).join(); /*2*/
        var data = jsonDecode(content) as Map; /*3*/
        var fileName = req.uri.pathSegments.last; /*4*/
        await File(fileName)
            .writeAsString(content, mode: FileMode.write);
        req.response
          ..statusCode = HttpStatus.ok
          ..write('Wrote data for ${data['name']}.');
      } catch (e) {
        response
          ..statusCode = HttpStatus.internalServerError
          ..write('Exception during file I/O: $e.');
      }
    } else {
      response
        ..statusCode = HttpStatus.methodNotAllowed
        ..write('Unsupported request: ${req.method}.');
    }
    await response.close();
  }
}
