// ignore_for_file: annotate_overrides, unused_element, strict_raw_type
// NOTE: Declarations in this file are analyzed but not tested.

void futuresTutorial() {
  Future<void> expensiveA() async {}
  Future<void> expensiveB() async {}
  Future<dynamic> expensiveC() async {}
  void doSomethingWith(_) {}
  // #docregion multiple-await
  // Sequential processing using async and await.
  void main() async {
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
}

void streamsTutorial() {
  // #docregion last-positive
  Future<int> lastPositive(Stream<int> stream) =>
      stream.lastWhere((x) => x >= 0);
  // #enddocregion last-positive

  void log(e) {}

  // #docregion map-log-errors
  Stream<S> mapLogErrors<S, T>(
    Stream<T> stream,
    S Function(T event) convert,
  ) async* {
    var streamWithoutErrors = stream.handleError((e) => log(e));
    await for (final event in streamWithoutErrors) {
      yield convert(event);
    }
  }
  // #enddocregion map-log-errors
}

abstract class MyStream<T> extends Stream<T> {
  // #docregion mock-stream-method-implementations
  Future<bool> contains(Object? needle) async {
    await for (final event in this) {
      if (event == needle) return true;
    }
    return false;
  }

  Future forEach(void Function(T element) action) async {
    await for (final event in this) {
      action(event);
    }
  }

  Future<List<T>> toList() async {
    final result = <T>[];
    await forEach(result.add);
    return result;
  }

  Future<String> join([String separator = '']) async =>
      (await toList()).join(separator);
  // #enddocregion mock-stream-method-implementations
}
