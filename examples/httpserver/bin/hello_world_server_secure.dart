// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Replies "Hello, world!" to all requests.
// Use the HTTPS URL https://localhost:4047 in your browser.
// This sample requires Dart version 1.13 or later.
// You might get a warning about a potential security risk, because the
// server certificate is signed by a test authority.  You can add the
// server_authority.pem certificate to your test browser as a trusted
// authority to avoid this message, but that may make that browser less secure.

import 'dart:io';
import 'dart:async';

Future main() async {
  var certificateChain =
      Platform.script.resolve('server_chain.pem').toFilePath();
  var serverKey = Platform.script.resolve('server_key.pem').toFilePath();
  var serverContext = new SecurityContext();
  serverContext.useCertificateChain(certificateChain);
  serverContext.usePrivateKey(serverKey, password: 'dartdart');

  var requests = await HttpServer.bindSecure('localhost', 4047, serverContext);
  print('listening');
  await for (HttpRequest request in requests) {
    request.response
      ..write('Hello, world!')
      ..close();
  }
}
