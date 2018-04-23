// ignore_for_file: annotate_overrides, type_annotate_public_apis, unused_element
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

void streamsTutorial() {
  // #docregion lastPositive
  Future<int> lastPositive(Stream<int> stream) =>
      stream.lastWhere((x) => x >= 0);
  // #enddocregion lastPositive

  void log(e) {}

  // #docregion mapLogErrors
  Stream<S> mapLogErrors<S, T>(
    Stream<T> stream,
    S Function(T event) convert,
  ) async* {
    var streamWithoutErrors = stream.handleError((e) => log(e));
    await for (var event in streamWithoutErrors) {
      yield convert(event);
    }
  }
  // #enddocregion mapLogErrors
}

abstract class MyStream<T> extends Stream<T> {
  // #docregion mock-stream-method-implementations
  Future<bool> contains(Object needle) async {
    await for (var event in this) {
      if (event == needle) return true;
    }
    return false;
  }

  Future forEach(void Function(T element) action) async {
    await for (var event in this) {
      action(event);
    }
  }

  Future<List<T>> toList() async {
    final result = <T>[];
    await this.forEach(result.add);
    return result;
  }

  Future<String> join([String separator = ""]) async =>
      (await this.toList()).join(separator);
  // #enddocregion mock-stream-method-implementations
}
