// ignore_for_file: unused_local_variable, duplicate_ignore

import 'dart:async';

int count = 0;
// #docregion empty_statements
void increment() {
  //!, beta, dev,  empty_statements
  if (count < 10) ;
  count++;
}
// #enddocregion empty_statements

void controller() {
  // #docregion close_sinks
  //!, beta, dev, close_sinks
  var controller = StreamController<String>();
  // #enddocregion close_sinks
}
