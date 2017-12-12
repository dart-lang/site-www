// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Automatic client to number_thinker.dart.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

Duration oneSecond = const Duration(seconds: 1);
Random myRandomGenerator = new Random();
HttpClient client = new HttpClient();

Future main() async {
  // Delay successive guesses by oneSecond.
  final guesses = new Stream.periodic(oneSecond, (_) => guess());

  // Guess until we get it right
  await for (final guess in guesses) {
    if (await guess) break;
  }
}

Future<bool> guess() {
  final guess = myRandomGenerator.nextInt(10);
  return checkGuess(guess);
}

Future checkGuess(int guess) async {
  bool isGoodGuess = false;
  HttpClientRequest request =
      await client.get(InternetAddress.LOOPBACK_IP_V4.host, 4041, '/?q=$guess');
  print('Guess is $guess.');
  HttpClientResponse response = await request.close();
  if (response.statusCode == HttpStatus.OK) {
    var contents = await response.transform(UTF8.decoder).join();
    if (contents.startsWith('true')) {
      isGoodGuess = true;
      client.close();
      print('Good guess, yay!');
    } else {
      print('Bad guess, trying again.');
    }
  }
  return isGoodGuess;
}
