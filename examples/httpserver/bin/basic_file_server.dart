// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A server built using the http_server package that serves the same file for
/// all requests.
/// Visit http://localhost:4046 into your browser.
// #docregion
import 'dart:io';
import 'package:http_server/http_server.dart';

File targetFile = File('web/index.html');

Future main() async {
  VirtualDirectory staticFiles = VirtualDirectory('.');

  var serverRequests =
      await HttpServer.bind(InternetAddress.loopbackIPv4, 4046);
  await for (var request in serverRequests) {
    staticFiles.serveFile(targetFile, request);
  }
}
