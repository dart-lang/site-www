// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Automatic client to number_thinker.dart.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

Duration oneSecond = Duration(seconds: 1);
Random myRandomGenerator = Random();
HttpClient client = HttpClient();

Future main() async {
  // Delay successive guesses by oneSecond.
  final guesses = Stream.periodic(oneSecond, (_) => guess());

  // Guess until we get it right
  await for (final guess in guesses) {
    if (await guess) break;
  }
}

Future<bool> guess() {
  final guess = myRandomGenerator.nextInt(10);
  return checkGuess(guess);
}

Future<bool> checkGuess(int guess) async {
  bool isGoodGuess = false;
  HttpClientRequest request =
      await client.get(InternetAddress.loopbackIPv4.host, 4041, '/?q=$guess');
  print('Guess is $guess.');
  HttpClientResponse response = await request.close();
  if (response.statusCode == HttpStatus.ok) {
    var contents = await utf8.decoder.bind(response).join();
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
