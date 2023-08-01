import 'package:examples_util/ellipsis.dart';
import 'package:futures_examples/util.dart';

// #docregion with-error
void withErrorMain() {
  asyncErrorFunction()
      // Future completes with an error:
      .then((_) => print("Won't reach here"))
      // Future completes with the same error:
      .whenComplete(() => print('Reaches here'))
      // Future completes with the same error:
      .then((_) => print("Won't reach here"))
      // Error is handled here:
      .catchError(handleError);
}
// #enddocregion with-error

// #docregion with-object
void withObjectMain() {
  asyncErrorFunction()
      // Future completes with an error:
      .then((_) => ellipsis())
      .catchError((e) {
    handleError(e);
    printErrorMessage();
    return someObject; // Future completes with someObject
  }).whenComplete(() => print('Done!')); // Future completes with someObject
}
// #enddocregion with-object

// #docregion when-complete-error
void whenCompleteError() {
  asyncErrorFunction()
      // Future completes with a value:
      .catchError(handleError)
      // Future completes with an error:
      .whenComplete(() => throw Exception('New error'))
      // Error is handled:
      .catchError(handleError);
}
// #enddocregion when-complete-error

final Never someObject = ellipsis();
