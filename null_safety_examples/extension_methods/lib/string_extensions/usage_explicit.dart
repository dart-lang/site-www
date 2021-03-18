// #docregion
// Both libraries define extensions on String that contain parseInt(),
// and the extensions have different names.
import 'string_apis.dart'; // Contains NumberParsing extension.
import 'string_apis_2.dart'; // Contains NumberParsing2 extension.

// #enddocregion
void main() {
// #docregion
// print('42'.parseInt()); // Doesn't work.
  print(NumberParsing('42').parseInt());
  print(NumberParsing2('42').parseInt());
// #enddocregion
  print('42'.parseDouble());
}
