// #docregion ignore_for_file
// ignore_for_file: unused_import, unused_local_variable, omit_local_variable_types
// #enddocregion ignore_for_file
// ignore_for_file: stable, dev, invalid_assignment

import 'package:examples_util/ellipsis.dart';

String downcastExample() {
  // #docregion implicit-downcast
  Object o = ellipsis();
  String s = o; // Implicit downcast
  String s2 = s.substring(1);
  // #enddocregion implicit-downcast
  return s2;
}

void assignment0() {
  // #docregion single-line
  int x = ''; // ignore: invalid_assignment
  // #enddocregion single-line
}

void assignment1() {
  // #docregion invalid_assignment
  // ignore: invalid_assignment
  int x = '';
  // #enddocregion invalid_assignment
}

void assignment2() {
  var y = 1;
  // #docregion ignore-more
  // ignore: invalid_assignment, const_initialized_with_non_constant_value
  const x = y;
  // #enddocregion ignore-more
}
