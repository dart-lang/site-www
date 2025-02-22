@Tags(['browser'])
@TestOn('browser')
library;

// #docregion dart-js-interop-import
import 'dart:js_interop';
// #enddocregion dart-js-interop-import
// #docregion package-import
import 'package:test/test.dart';
// #enddocregion package-import
import 'package:web/web.dart';

void main() {
  test('cascade-operator', () {
    final div = '<button id="confirm"></button>';
    document.body?.insertAdjacentHTML('beforeend', div.toJS);

    // #docregion cascade-operator
    document.querySelector('#confirm') // Get an object.
      ?..textContent =
          'Confirm' // Use its members.
      ..classList.add('important')
      ..onClick.listen((e) => window.alert('Confirmed!'))
      ..scrollIntoView();
    // #enddocregion cascade-operator

    expect(document.querySelector('#confirm')?.textContent, 'Confirm');
  });

  test('cascade-operator-example-expanded', () {
    final div = '<button id="confirm"></button>';
    document.body?.insertAdjacentHTML('beforeend', div.toJS);

    // #docregion cascade-operator-example-expanded
    final button = document.querySelector('#confirm');
    button?.textContent = 'Confirm';
    button?.classList.add('important');
    button?.onClick.listen((e) => window.alert('Confirmed!'));
    button?.scrollIntoView();
    // #enddocregion cascade-operator-example-expanded

    expect(document.querySelector('#confirm')?.textContent, 'Confirm');
  });
}
