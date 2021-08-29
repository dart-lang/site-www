// ignore_for_file: dead_code

import 'package:examples_util/ellipsis.dart';
import 'package:futures_examples/util.dart';

// #docregion bad
void mainBad() {
  Future<Object> future = funcThatThrows();

  // BAD: Too late to handle funcThatThrows() exception.
  Future.delayed(const Duration(milliseconds: 500), () {
    future.then(ellipsis()).catchError(ellipsis());
  });
}
// #enddocregion bad

// #docregion good
void mainGood() {
  Future.delayed(const Duration(milliseconds: 500), () {
    funcThatThrows().then(ellipsis()).catchError(ellipsis()); // We get here.
  });
}
// #enddocregion good
