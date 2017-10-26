import 'dart:html';

void main() {
  querySelector('#button') // Get an object.
    ..text = 'Confirm' // Use its members.
    ..classes.add('important')
    ..onClick.listen((e) => window.alert('Confirmed!'));
}
