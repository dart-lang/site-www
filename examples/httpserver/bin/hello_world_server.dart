// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Replies "Hello, world!" to all requests.
// Use the URL localhost:4040 in your browser.

import 'dart:io';
import 'dart:async';

Future main() async {
  var requestServer =
      await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4040);
  print('listening on localhost, port ${requestServer.port}');

  try {
    await for (HttpRequest request in requestServer) {
      request.response
        ..write('Hello, world!')
        ..close();
    }
  } catch (e) {
    print(e.toString);
  }
}
