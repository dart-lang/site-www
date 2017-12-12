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

String _host = InternetAddress.LOOPBACK_IP_V4.host;
String path = 'file.txt';

Map jsonData = {
  'name': 'Han Solo',
  'job': 'reluctant hero',
  'BFF': 'Chewbacca',
  'ship': 'Millennium Falcon',
  'weakness': 'smuggling debts'
};

Future main() async {
  HttpClientRequest request =
      await new HttpClient().post(_host, 4049, path) /*1*/
        ..headers.contentType = ContentType.JSON /*2*/
        ..write(JSON.encode(jsonData)); /*3*/
  HttpClientResponse response = await request.close(); /*4*/
  await response.transform(UTF8.decoder /*5*/).forEach(print);
}
