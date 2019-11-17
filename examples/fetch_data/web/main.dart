// Copyright (c) 2015, the Dart project authors.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:convert';

// Input fields
InputElement favoriteNumber;
InputElement valueOfPi;
InputElement horoscope;
InputElement favOne;
InputElement favTwo;
InputElement favThree;
RadioButtonInputElement loveChocolate;
RadioButtonInputElement noLoveForChocolate;

// Result fields
TextAreaElement intAsJson;
TextAreaElement doubleAsJson;
TextAreaElement stringAsJson;
TextAreaElement listAsJson;
TextAreaElement boolAsJson;
TextAreaElement mapAsJson;

void main() {
  // Set up the input text areas.
  favoriteNumber = querySelector('#favoriteNumber');
  valueOfPi = querySelector('#valueOfPi');
  horoscope = querySelector('#horoscope');
  favOne = querySelector('#favOne');
  favTwo = querySelector('#favTwo');
  favThree = querySelector('#favThree');
  loveChocolate = querySelector('#loveChocolate');
  noLoveForChocolate = querySelector('#noLoveForChocolate');

  // Set up the results text areas
  // to display the values as JSON.
  intAsJson = querySelector('#intAsJson');
  doubleAsJson = querySelector('#doubleAsJson');
  boolAsJson = querySelector('#boolAsJson');
  stringAsJson = querySelector('#stringAsJson');
  listAsJson = querySelector('#listAsJson');
  mapAsJson = querySelector('#mapAsJson');

  // Set up the listeners.
  favoriteNumber.onKeyUp.listen(showJson);
  valueOfPi.onKeyUp.listen(showJson);
  loveChocolate.onClick.listen(showJson);
  noLoveForChocolate.onClick.listen(showJson);
  horoscope.onKeyUp.listen(showJson);
  favOne.onKeyUp.listen(showJson);
  favTwo.onKeyUp.listen(showJson);
  favThree.onKeyUp.listen(showJson);

  _populateFromJson();
  showJson(null);
}

// Pre-fill the form with some default values.
void _populateFromJson() {
  // #docregion jsonDataAsString
  final jsonDataAsString = '''{
    "favoriteNumber": 73,
    "valueOfPi": 3.141592,
    "chocolate": true,
    "horoscope": "Cancer",
    "favoriteThings": ["monkeys", "parrots", "lattes"]
  }''';

  Map jsonData = json.decode(jsonDataAsString);
  // #enddocregion jsonDataAsString

  favoriteNumber.value = jsonData['favoriteNumber'].toString();
  valueOfPi.value = jsonData['valueOfPi'].toString();
  horoscope.value = jsonData['horoscope'].toString();
  favOne.value = jsonData['favoriteThings'][0];
  favTwo.value = jsonData['favoriteThings'][1];
  favThree.value = jsonData['favoriteThings'][2];

  final chocolateRadioButton =
      jsonData['chocolate'] == false ? noLoveForChocolate : loveChocolate;
  chocolateRadioButton.checked = true;
}

// TODO(chalin): I'm currently minimizing changes, but make showJson private.
/// Display all values as JSON.
// #docregion showJson
void showJson(Event _) {
  // Grab the data that will be converted to JSON.
  final favNum = int.tryParse(favoriteNumber.value);
  final pi = double.tryParse(valueOfPi.value);
  final chocolate = loveChocolate.checked;
  final sign = horoscope.value;
  final favoriteThings = <String>[
    favOne.value,
    favTwo.value,
    favThree.value,
  ];

  final formData = {
    'favoriteNumber': favNum,
    'valueOfPi': pi,
    'chocolate': chocolate,
    'horoscope': sign,
    'favoriteThings': favoriteThings
  };

  // Convert to JSON and display results.
  intAsJson.text = json.encode(favNum);
  doubleAsJson.text = json.encode(pi);
  boolAsJson.text = json.encode(chocolate);
  stringAsJson.text = json.encode(sign);
  listAsJson.text = json.encode(favoriteThings);
  mapAsJson.text = json.encode(formData);
}
