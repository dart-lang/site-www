import 'dart:html';
import 'package:dartpad_picker/dartpad_picker.dart';

void main() {
  var dartPadHost = querySelector('#dartpad-host');
  var select = querySelector('#dartpad-select');

  var snippets = [
    Snippet('Hello World', helloWorld),
    Snippet('Fibbonacci', fibbonacci),
  ];
  DartPadPicker(dartPadHost, select, snippets);
}

// Snippets

var helloWorld = r'''
main() => print("Hello, World!");
'''
    .trim();

var fibbonacci = r'''
// Copyright 2015 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

void main() {
  var i = 20;
  print('fibonacci($i) = ${fibonacci(i)}');
}

/// Computes the nth Fibonacci number.
int fibonacci(int n) {
  return n < 2 ? n : (fibonacci(n - 1) + fibonacci(n - 2));
}
'''
    .trim();
