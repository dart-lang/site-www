import 'package:web/web.dart' as web;

void alarm([String? text]) {
  web.window.alert(text ?? message);
}

String get message => 'Hello world from the web!';
