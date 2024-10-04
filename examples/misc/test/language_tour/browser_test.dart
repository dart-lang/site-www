@Tags(['browser'])
@TestOn('browser')
library;

// #docregion dart-html-import
import 'dart:html';
// #enddocregion dart-html-import
// #docregion package-import
import 'package:test/test.dart';
// #enddocregion package-import

void main() {
  test('cascade-operator', () {
    final div = '<button id="confirm"></button>';
    document.body?.appendHtml(div);

    // #docregion cascade-operator
    querySelector('#confirm') // Get an object.
      ?..text = 'Confirm' // Use its members.
      ..classes.add('important')
      ..onClick.listen((e) => window.alert('Confirmed!'))
      ..scrollIntoView();
    // #enddocregion cascade-operator

    expect(document.querySelector('#confirm')?.text, 'Confirm');
  });

  test('cascade-operator-example-expanded', () {
    final div = '<button id="confirm"></button>';
    document.body?.appendHtml(div);

    // #docregion cascade-operator-example-expanded
    var button = querySelector('#confirm');
    button?.text = 'Confirm';
    button?.classes.add('important');
    button?.onClick.listen((e) => window.alert('Confirmed!'));
    button?.scrollIntoView();
    // #enddocregion cascade-operator-example-expanded

    expect(document.querySelector('#confirm')?.text, 'Confirm');
  });
}
