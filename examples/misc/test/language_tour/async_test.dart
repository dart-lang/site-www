// ignore_for_file: type_annotate_public_apis
import 'dart:async';

import 'package:test/test.dart';
import 'package:dartlang_examples_util/print_matcher.dart' as m;

void main() {
  test('syncGenerator', () {
    // #docregion sync-generator
    Iterable naturalsTo(n) sync* {
      int k = 0;
      while (k < n) yield k++;
    }
    // #enddocregion sync-generator

    main() {
      print(naturalsTo(3));
    }

    expect(main, m.prints('(0, 1, 2)'));
  });

  test('asyncGenerator', () {
    // #docregion async-generator
    Stream asynchronousNaturalsTo(n) async* {
      int k = 0;
      while (k < n) yield k++;
    }
    // #enddocregion async-generator

    main() async {
      print(await asynchronousNaturalsTo(3).last);
    }

    expect(main, m.prints('2'));
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

    main() {
      print(naturalsDownFrom(3));
    }

    expect(main, m.prints('(3, 2, 1)'));
  });
}
