// ignore_for_file: type_annotate_public_apis
import 'package:test/test.dart';
import 'package:examples/language_tour/util/logging_printer.dart';
import 'package:examples/language_tour/util/print.dart';

void main() {
  final printLog = PrintLog.it;

  setUpAll(() => PrintLog.set$print());
  setUp(() => printLog.clear());

  test('basic', () {
    // #docregion
    // Define a function.
    printNumber(num aNumber) {
      $print('The number is $aNumber.'); // Print to console.
    }

    // This is where the app starts executing.
    main() {
      var number = 42; // Declare and initialize a variable.
      printNumber(number); // Call a function.
    }
    // #enddocregion

    main();
    expect(printLog.toString(), 'The number is 42.');
  });
}
