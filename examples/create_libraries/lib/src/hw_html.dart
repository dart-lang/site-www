import 'dart:html';

void alarm([String? text]) {
  window.alert(text ?? message);
}

String get message => 'Hello World from JavaScript!';
