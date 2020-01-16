@Tags(['browser'])
@TestOn('browser')
// #docregion dart-html-import
import 'dart:html';
// #enddocregion dart-html-import
// #docregion package-import
import 'package:test/test.dart';
// #enddocregion package-import

void main() {
  test('simple-web-main-function', () {
    final div = '<div id="sample_text_id"></div>';
    document.body.appendHtml(div);
    void reverseText(MouseEvent e) {}

    // #docregion simple-web-main-function
    void main() {
      querySelector('#sample_text_id')
        ..text = 'Click me!'
        ..onClick.listen(reverseText);
    }
    // #enddocregion simple-web-main-function

    main();
    expect(document.querySelector('#sample_text_id').text, 'Click me!');
  });

  test('cascade-operator', () {
    final div = '<button id="confirm"></button>';
    document.body.appendHtml(div);

    // #docregion cascade-operator
    querySelector('#confirm') // Get an object.
      ..text = 'Confirm' // Use its members.
      ..classes.add('important')
      ..onClick.listen((e) => window.alert('Confirmed!'));
    // #enddocregion cascade-operator

    expect(document.querySelector('#confirm').text, 'Confirm');
  });

  test('cascade-operator-example-expanded', () {
    final div = '<button id="confirm"></button>';
    document.body.appendHtml(div);

    // #docregion cascade-operator-example-expanded
    var button = querySelector('#confirm');
    button.text = 'Confirm';
    button.classes.add('important');
    button.onClick.listen((e) => window.alert('Confirmed!'));
    // #enddocregion cascade-operator-example-expanded

    expect(document.querySelector('#confirm').text, 'Confirm');
  });
}
