// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Automatic client to number_thinker.dart.

import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:async';

Random myRandomGenerator = new Random();
HttpClient client;

void main() {
  client = new HttpClient();
  new Timer.periodic(new Duration(seconds: 2), makeGuess);
}

Future makeGuess(_) async {
  var aRandomNumber = myRandomGenerator.nextInt(10);

  HttpClientRequest request = await client.get(
      InternetAddress.LOOPBACK_IP_V4.host, 4041, '/?q=$aRandomNumber');
  print('Guess is $aRandomNumber.');
  HttpClientResponse response = await request.close();
  if (response.statusCode == HttpStatus.OK) {
    var contents = await response.transform(UTF8.decoder).join();
    if (contents.startsWith('true')) {
      client.close();
      print('yay');
      exit(0);
    } else {
      print('boo');
    }
  }
}
