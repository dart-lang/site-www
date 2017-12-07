// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Use the client program, number_guesser.dart to automatically make guesses.
// Or, you can manually guess the number using the URL localhost:4045/?q=#,
// where # is your guess.
// Or, you can use the make_a_guess.html UI.

import 'dart:io';
import 'dart:async';
import 'dart:math' show Random;

int myNumber = new Random().nextInt(10);

Future main() async {
  print("I'm thinking of a number: $myNumber");

  HttpServer requestServer =
      await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4041);
  await for (var request in requestServer) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) {
  try {
    if (request.method == 'GET') {
      handleGet(request);
    } else {
      request.response
        ..statusCode = HttpStatus.METHOD_NOT_ALLOWED
        ..write('Unsupported request: ${request.method}.')
        ..close();
    }
  } catch (e) {
    print('Exception in handleRequest: $e');
  }
  print('Request handled.');
}

void handleGet(HttpRequest request) {
  var guess = request.uri.queryParameters['q'];
  request.response.statusCode = HttpStatus.OK;
  if (guess == myNumber.toString()) {
    request.response
      ..writeln('true')
      ..writeln("I'm thinking of another number.")
      ..close();
    myNumber = new Random().nextInt(10);
    print("I'm thinking of another number: $myNumber");
  } else {
    request.response
      ..writeln('false')
      ..close();
  }
}
