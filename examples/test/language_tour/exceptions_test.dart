// ignore_for_file: assignment_to_final, unused_local_variable
import 'package:test/test.dart';
import 'package:examples/language_tour/util/logging_printer.dart';
import 'package:examples/language_tour/util/print.dart';

void main() {
  final printLog = PrintLog.it;

  setUpAll(() => PrintLog.set$print());
  setUp(() => printLog.clear());

  test('rethrow', () {
    // #docregion rethrow
    final foo = '';

    void misbehave() {
      try {
        foo = "You can't change a final variable's value.";
      } catch (e) {
        $print(
            'misbehave() partially handled ${e.runtimeType}.');
        rethrow; // Allow callers to see the exception.
      }
    }

    void main() {
      try {
        misbehave();
      } catch (e) {
        $print(
            'main() finished handling ${e.runtimeType}.');
      }
    }
    // #enddocregion rethrow

    main();
    expect(
        printLog
            .toString()
            .contains('misbehave() partially handled'),
        isTrue);
    expect(
        printLog
            .toString()
            .contains('main() finished handling'),
        isTrue);
  });
}
