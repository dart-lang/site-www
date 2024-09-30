// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'dart:html';

void main() {
  final myObject = SomeObject();

  // #docregion no-cascade
  myObject.someMethod();
  // #enddocregion no-cascade

  // #docregion uses-cascade
  myObject..someMethod();
  // #enddocregion uses-cascade

  // #docregion query-without-cascades
  var button = querySelector('#confirm');
  button?.text = 'Confirm';
  button?.classes.add('important');
  button?.onClick.listen((e) => window.alert('Confirmed!'));
  button?.scrollIntoView();
  // #enddocregion query-without-cascades

  // #docregion query-with-cascades
  querySelector('#confirm')
    ?..text = 'Confirm'
    ..classes.add('important')
    ..onClick.listen((e) => window.alert('Confirmed!'))
    ..scrollIntoView();
  // #enddocregion query-with-cascades
}

class SomeObject {
  void someMethod() {}
}
