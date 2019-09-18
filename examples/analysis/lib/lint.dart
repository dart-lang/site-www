// ignore_for_file: unused_element, unused_local_variable
// ignore_for_file: 2, close_sinks, empty_statements

import 'dart:async';

int count = 0;
// #docregion empty_statements
void increment() {
  if (count < 10) ;
  count++;
}
// #enddocregion empty_statements

void controller() {
  // #docregion close_sinks
  var _controller = StreamController<String>();
  // #enddocregion close_sinks
}
