// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'package:web/web.dart' as web;

void main() {
  final myObject = SomeObject();

  // #docregion no-cascade
  myObject.someMethod();
  // #enddocregion no-cascade

  // #docregion uses-cascade
  myObject..someMethod();
  // #enddocregion uses-cascade

  // #docregion query-without-cascades
  final button = web.document.querySelector('#confirm');
  button?.textContent = 'Confirm';
  button?.classList.add('important');
  button?.onClick.listen((e) => web.window.alert('Confirmed!'));
  button?.scrollIntoView();
  // #enddocregion query-without-cascades

  // #docregion query-with-cascades
  web.document.querySelector('#confirm')
    ?..textContent = 'Confirm'
    ..classList.add('important')
    ..onClick.listen((e) => web.window.alert('Confirmed!'))
    ..scrollIntoView();
  // #enddocregion query-with-cascades
}

class SomeObject {
  void someMethod() {}
}
