// Copyright (c) 2015, the Dart project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:convert';

// Input fields
late final InputElement favoriteNumber;
late final InputElement valueOfPi;
late final InputElement horoscope;
late final InputElement favOne;
late final InputElement favTwo;
late final InputElement favThree;
late final RadioButtonInputElement loveChocolate;
late final RadioButtonInputElement noLoveForChocolate;

// Result fields
late final TextAreaElement intAsJson;
late final TextAreaElement doubleAsJson;
late final TextAreaElement stringAsJson;
late final TextAreaElement listAsJson;
late final TextAreaElement boolAsJson;
late final TextAreaElement mapAsJson;

void main() {
  // Set up the input text areas.
  favoriteNumber = querySelector('#favoriteNumber') as InputElement;
  valueOfPi = querySelector('#valueOfPi') as InputElement;
  horoscope = querySelector('#horoscope') as InputElement;
  favOne = querySelector('#favOne') as InputElement;
  favTwo = querySelector('#favTwo') as InputElement;
  favThree = querySelector('#favThree') as InputElement;
  loveChocolate = querySelector('#loveChocolate') as RadioButtonInputElement;
  noLoveForChocolate =
      querySelector('#noLoveForChocolate') as RadioButtonInputElement;

  // Set up the results text areas
  // to display the values as JSON.
  intAsJson = querySelector('#intAsJson') as TextAreaElement;
  doubleAsJson = querySelector('#doubleAsJson') as TextAreaElement;
  boolAsJson = querySelector('#boolAsJson') as TextAreaElement;
  stringAsJson = querySelector('#stringAsJson') as TextAreaElement;
  listAsJson = querySelector('#listAsJson') as TextAreaElement;
  mapAsJson = querySelector('#mapAsJson') as TextAreaElement;

  // Set up the listeners.
  favoriteNumber.onKeyUp.listen(_showJson);
  valueOfPi.onKeyUp.listen(_showJson);
  loveChocolate.onClick.listen(_showJson);
  noLoveForChocolate.onClick.listen(_showJson);
  horoscope.onKeyUp.listen(_showJson);
  favOne.onKeyUp.listen(_showJson);
  favTwo.onKeyUp.listen(_showJson);
  favThree.onKeyUp.listen(_showJson);

  _populateFromJson();
  _showJson();
}

// Pre-fill the form with some default values.
void _populateFromJson() {
  // #docregion jsonDataAsString
  const jsonDataAsString = '''{
    "favoriteNumber": 73,
    "valueOfPi": 3.141592,
    "chocolate": true,
    "horoscope": "Cancer",
    "favoriteThings": ["monkeys", "parrots", "lattes"]
  }''';

  Map<String, dynamic> jsonData =
      json.decode(jsonDataAsString) as Map<String, dynamic>;
  // #enddocregion jsonDataAsString

  favoriteNumber.value = jsonData['favoriteNumber'].toString();
  valueOfPi.value = jsonData['valueOfPi'].toString();
  horoscope.value = jsonData['horoscope'].toString();
  final favoriteThings = List<String>.from(jsonData['favoriteThings'] as List);
  favOne.value = favoriteThings[0];
  favTwo.value = favoriteThings[1];
  favThree.value = favoriteThings[2];

  final chocolateRadioButton =
      jsonData['chocolate'] == false ? noLoveForChocolate : loveChocolate;
  chocolateRadioButton.checked = true;
}

/// Display all values as JSON.
// #docregion showJson
void _showJson([Event? _]) {
  // Grab the data that will be converted to JSON.
  final favNum = int.tryParse(favoriteNumber.value ?? '');
  final pi = double.tryParse(valueOfPi.value ?? '');
  final chocolate = loveChocolate.checked;
  final sign = horoscope.value;
  final favoriteThings = <String>[
    favOne.value ?? '',
    favTwo.value ?? '',
    favThree.value ?? '',
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
