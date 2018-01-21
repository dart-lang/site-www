// ignore_for_file: type_annotate_public_apis
import 'dart:async';

import 'package:test/test.dart';

void main() {
  test('syncGenerator', () {
    // #docregion sync-generator
    Iterable naturalsTo(n) sync* {
      int k = 0;
      while (k < n) yield k++;
    }
    // #enddocregion sync-generator

    expect(naturalsTo(3), [0, 1, 2]);
  });

  test('asyncGenerator', () async {
    // #docregion async-generator
    Stream asynchronousNaturalsTo(n) async* {
      int k = 0;
      while (k < n) yield k++;
    }
    // #enddocregion async-generator

    expect(await asynchronousNaturalsTo(3).toList(), [0, 1, 2]);
  });

  test('recursiveGenerator', () {
    // #docregion recursive-generator
    Iterable naturalsDownFrom(n) sync* {
      if (n > 0) {
        yield n;
        yield* naturalsDownFrom(n - 1);
      }
    }
    // #enddocregion recursive-generator

    expect(naturalsDownFrom(3), [3, 2, 1]);
  });
}
