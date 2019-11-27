import 'package:test/test.dart';

import '../bin/any.dart' as any;
import '../bin/every.dart' as every;
import '../bin/firstwhere.dart' as firstwhere;
import '../bin/iterable_2.dart' as iterable_2;
import '../bin/map.dart' as map;
import '../bin/takewhile.dart' as takewhile;
import '../bin/where.dart' as where;

void main() {
  group('iterables codelab', () {
    test('any_example', () {
      var items = ['Zoo', 'Home'];
      any.any(items, (output) {
        expect(output, 'At least one element contains "Z"');
      });

      items = ['Home'];
      any.any(items, (output) {
        expect(output, 'No element contains "Z"');
      });
    });

    test('every_example', () {
      expect(every.bad(['12345']), true);
      expect(every.bad(['1234']), false);
      expect(every.good(['12345']), true);
      expect(every.good(['1234']), false);
    });

    test('firstWhere_example', () {
      expect(firstwhere.firstWhere(['a', '123456', 'abcdef']), '123456');
    });

    test('iterable_2_example', () {
      expect(iterable_2.value, 2);
    });

    test('map_example', () {
      expect(map.mapInt([1, 2, 3]), [10, 20, 30]);
      expect(map.mapString([1, 2, 3]), ['1', '2', '3']);
    });

    test('takeWhile_example', () {
      expect(
        _listEquals(
          takewhile.takeWhile([1, 2, 3, -1, 4, 5]).toList(),
          [1, 2, 3],
        ),
        true,
      );
    });

    test('where_example', () {
      expect(
        _listEquals(
          where.where([1, 2, 3, 4]).toList(),
          [2, 4],
        ),
        true,
      );
    });
  });
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) return false;
  }
  return true;
}
