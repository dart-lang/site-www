// ignore_for_file: dead_code
// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:examples_util/ellipsis.dart';

// #docregion strict-casts
void foo(List<String> lines) {
  ellipsis<String>();
}

void bar(String jsonText) {
  // ignore: stable, beta, dev, argument_type_not_assignable
  foo(jsonDecode(jsonText)); // Implicit cast
}
// #enddocregion strict-casts

void strictInference() {
  // #docregion strict-inference
  // ignore: stable, beta, dev, inference_failure_on_collection_literal
  final lines = {}; // Inference failure
  lines['Dart'] = 10000;
  lines['C++'] = 'one thousand';
  lines['Go'] = 2000;
  print('Lines: ${lines.values.reduce((a, b) => a + b)}'); // Runtime error
  // #enddocregion strict-inference
}

void strictRawTypes() {
  // #docregion strict-raw-types
  // ignore: stable, beta, dev, strict_raw_type
  List numbers = [1, 2, 3]; // List with raw type
  for (final n in numbers) {
    print(n.length); // Runtime error
  }
  // #enddocregion strict-raw-types
}
