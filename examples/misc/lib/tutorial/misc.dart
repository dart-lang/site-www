// ignore_for_file: type_annotate_public_apis, unused_element
// NOTE: Declarations in this file are analyzed but not tested.

import 'dart:async';

typedef Void1 = void Function(dynamic);
typedef Async0 = Future Function();

void futuresTutorial() {
  Async0 expensiveA, expensiveB, expensiveC;
  Void1 doSomethingWith;
  // #docregion multiple-await
  // Sequential processing using async and await.
  main() async {
    await expensiveA();
    await expensiveB();
    doSomethingWith(await expensiveC());
  }
  // #enddocregion multiple-await

  // #docregion chaining
  expensiveA()
      .then((aValue) => expensiveB())
      .then((bValue) => expensiveC())
      .then((cValue) => doSomethingWith(cValue));
  // #enddocregion chaining

  Void1 chooseBestResponse, handleError;
  // #docregion Future-wait
  Future
      .wait([expensiveA(), expensiveB(), expensiveC()])
      .then((List responses) => chooseBestResponse(responses))
      .catchError((e) => handleError(e));
  // #enddocregion Future-wait
}
