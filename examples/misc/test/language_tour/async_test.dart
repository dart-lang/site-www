// ignore_for_file: type_annotate_public_apis, curly_braces_in_flow_control_structures
import 'package:test/test.dart';

void main() {
  test('syncGenerator', () {
    // #docregion sync-generator
    Iterable<int> naturalsTo(int n) sync* {
      int k = 0;
      while (k < n) yield k++;
    }
    // #enddocregion sync-generator

    expect(naturalsTo(3), [0, 1, 2]);
  });

  test('asyncGenerator', () async {
    // #docregion async-generator
    Stream<int> asynchronousNaturalsTo(int n) async* {
      int k = 0;
      while (k < n) yield k++;
    }
    // #enddocregion async-generator

    expect(await asynchronousNaturalsTo(3).toList(), [0, 1, 2]);
  });

  test('recursiveGenerator', () {
    // #docregion recursive-generator
    Iterable<int> naturalsDownFrom(int n) sync* {
      if (n > 0) {
        yield n;
        yield* naturalsDownFrom(n - 1);
      }
    }
    // #enddocregion recursive-generator

    expect(naturalsDownFrom(3), [3, 2, 1]);
  });
}
