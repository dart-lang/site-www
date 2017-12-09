// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Client to basic_writer_server.dart.
// Makes a POST request containing JSON-encoded data
// to the server and prints the response.

// #docregion
import 'dart:async';
import 'dart:io';
import 'dart:convert' show UTF8, JSON;

Future main() async {
  Map jsonData = {
    'name': 'Han Solo',
    'job': 'reluctant hero',
    'BFF': 'Chewbacca',
    'ship': 'Millennium Falcon',
    'weakness': 'smuggling debts'
  };

  var request = await new HttpClient()
      .post(InternetAddress.LOOPBACK_IP_V4.host, 4049, 'file.txt'); /*1*/
  request.headers.contentType = ContentType.JSON; /*2*/
  request.write(JSON.encode(jsonData)); /*3*/
  HttpClientResponse response = await request.close(); /*4*/
  await for (var contents in response.transform(UTF8.decoder /*5*/)) {
    print(contents);
  }
}
