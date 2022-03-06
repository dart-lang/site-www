// Copyright (c) 2012, the Dart project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:html';

final UListElement wordList = querySelector('#wordList') as UListElement;

void main() {
  querySelector('#getWords')!.onClick.listen(makeRequest);
}

// #docregion makeRequest
Future<void> makeRequest(Event _) async {
  const path = 'https://dart.dev/f/portmanteaux.json';
  try {
    // Make the GET request
    final jsonString = await HttpRequest.getString(path);
    // The request succeeded. Process the JSON.
    processResponse(jsonString);
  } catch (e) {
    // The GET request failed. Handle the error.
    // #enddocregion makeRequest
    print("Couldn't open $path");
    wordList.children.add(LIElement()..text = 'Request failed.');
    // #docregion makeRequest
  }
}

void processResponse(String jsonString) {
  for (final portmanteau in json.decode(jsonString) as List<dynamic>) {
    wordList.children.add(LIElement()..text = portmanteau as String);
  }
}
