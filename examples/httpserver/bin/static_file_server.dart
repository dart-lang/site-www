// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A static file server, serving files from the web directory.
/// Launch from the package root directory.
/// Visit http://localhost:4048 into your browser.
// #docregion
import 'dart:io';
import 'package:http_server/http_server.dart';

Future main() async {
  var staticFiles = VirtualDirectory('web');
  staticFiles.allowDirectoryListing = true; /*1*/
  staticFiles.directoryHandler = (dir, request) /*2*/ {
    var indexUri = Uri.file(dir.path).resolve('index.html');
    staticFiles.serveFile(File(indexUri.toFilePath()), request); /*3*/
  };

  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4048);
  print('Listening on port 4048');
  await server.forEach(staticFiles.serveRequest); /*4*/
}
