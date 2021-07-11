// #docregion
// Defines the String extension method parseInt().
import 'string_apis.dart';

// Also defines parseInt(), but hiding NumberParsing2
// hides that extension method.
import 'string_apis_2.dart' hide NumberParsing2;

// #enddocregion
void main() {
// #docregion
  // Uses the parseInt() defined in 'string_apis.dart'.
  print('42'.parseInt());
// #enddocregion

  // Uses parseHexInt(), defined in 'string_apis_2.dart'.
  print('42'.parseHexInt());

  // Uses the parseDouble() defined in 'string_apis.dart'.
  print('42'.parseDouble());
}
