// ignore_for_file: dead_code, prefer_typing_uninitialized_variables

import 'package:examples_util/ellipsis.dart';

String strictCasts() {
  // #docregion strict-casts
  dynamic o = ellipsis<String>();
  // ignore: stable, beta, dev, invalid_assignment
  String s = o; // Implicit downcast
  String s2 = s.substring(1);
  // #enddocregion strict-casts
  return s2;
}

void strictInference() {
  // #docregion strict-inference
  // ignore: stable, beta, dev, inference_failure_on_uninitialized_variable
  var dynamicValue;
  dynamicValue.add(1);
  dynamicValue.add(2);
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
