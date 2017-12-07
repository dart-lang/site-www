// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Automatic client to number_thinker.dart.

import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:async';

Duration oneSecond = const Duration(seconds: 1);

Future main() async {
  final guesser = new NumberGuesser(new Random());
  final guesses = new Stream.periodic(oneSecond, (_) => guesser.guess());

  // Guess until we get it right
  await for (final guess in guesses) {
    if (await guess) break;
  }
}

class NumberGuesser {
  static const int maxInt = 10;

  Random _intGenerator;
  final HttpClient _client = new HttpClient();

  NumberGuesser(this._intGenerator);

  Future<bool> guess() => tryGuess(_intGenerator.nextInt(maxInt));

  Future<bool> tryGuess(int guess) async {
    bool goodGuess = false;
    HttpClientRequest request = await _client.get(
      InternetAddress.LOOPBACK_IP_V4.host,
      4041,
      '/?q=$guess',
    );
    print('Guess is $guess.');
    HttpClientResponse response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var contents = await response.transform(UTF8.decoder).join();
      // print('Response from number server: $contents');
      if (contents.startsWith('true')) {
        print('Guessed right, yay!');
        goodGuess = true;
        _client.close();
      } else {
        print('Bad guess, trying again.');
      }
    }
    return goodGuess;
  }
}
