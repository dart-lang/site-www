// ignore_for_file: unused_element, type_annotate_public_apis
// #docplaster
import 'package:test/test.dart';
import 'package:examples/language_tour/util/logging_printer.dart';

void main() {
  final printLog = PrintLog.it;

  setUpAll(() => PrintLog.set$print());
  setUp(() => printLog.clear());

  test('xxxxx', () {
    // #docregion xxxx
    11111;
    // #enddocregion xxxx
  });
}

/// No tests below this point. Excerpts only illustrate declarations.
void miscDeclAnalyzedButNotTested() {
  {
    // #docregion xxxx
    11111;
    // #enddocregion xxxx
  }
}
