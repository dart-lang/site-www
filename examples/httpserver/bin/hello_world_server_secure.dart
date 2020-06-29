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

// #docregion
import 'dart:io';

String certificateChain = 'server_chain.pem';
String serverKey = 'server_key.pem';

Future main() async {
  var serverContext = SecurityContext(); /*1*/
  serverContext.useCertificateChain(certificateChain); /*2*/
  serverContext.usePrivateKey(serverKey, password: 'dartdart'); /*3*/

  var server = await HttpServer.bindSecure(
    'localhost',
    4047,
    serverContext, /*4*/
  );
  print('Listening on localhost:${server.port}');
  await for (HttpRequest request in server) {
    request.response.write('Hello, world!');
    await request.response.close();
  }
}
