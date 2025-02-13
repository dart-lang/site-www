// #docregion hide-conflicts
// Defines the String extension method parseInt().
import 'string_apis.dart';

// Also defines parseInt(), but hiding NumberParsing2
// hides that extension method.
import 'string_apis_2.dart' hide NumberParsing2;

void main() {
  // Uses the parseInt() defined in 'string_apis.dart'.
  print('42'.parseInt());
  // #enddocregion hide-conflicts

  // Uses parseHexInt(), defined in 'string_apis_2.dart'.
  print('42'.parseHexInt());

  // Uses the parseDouble() defined in 'string_apis.dart'.
  print('42'.parseDouble());
  // #docregion hide-conflicts
}

// #enddocregion hide-conflicts
