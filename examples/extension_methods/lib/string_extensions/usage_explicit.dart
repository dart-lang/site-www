// #docregion conflicts-explicit
// Both libraries define extensions on String that contain parseInt(),
// and the extensions have different names.
import 'string_apis.dart'; // Contains NumberParsing extension.
import 'string_apis_2.dart'; // Contains NumberParsing2 extension.

// #enddocregion conflicts-explicit
void main() {
// #docregion conflicts-explicit
// print('42'.parseInt()); // Doesn't work.
  print(NumberParsing('42').parseInt());
  print(NumberParsing2('42').parseInt());
// #enddocregion conflicts-explicit
  print('42'.parseDouble());
}
