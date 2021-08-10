import 'package:test/test.dart';

void main() {
  test('collection_literals_inferred', () {
    // #docregion collection-literals-inferred
    final aListOfStrings = ['one', 'two', 'three'];
    final aSetOfStrings = {'one', 'two', 'three'};
    final aMapOfStringsToInts = {
      'one': 1,
      'two': 2,
      'three': 3,
    };
    // #enddocregion collection-literals-inferred

    expect(aListOfStrings, isA<List<String>>());
    expect(aListOfStrings[1], equals('two'));

    expect(aSetOfStrings, isA<Set<String>>());
    expect(aSetOfStrings, contains('two'));

    expect(aMapOfStringsToInts, isA<Map<String, int>>());
    expect(aMapOfStringsToInts['two'], equals(2));
  });

  test('collection_literals_specified', () {
    // #docregion collection-literals-specified
    final aListOfInts = <int>[];
    final aSetOfInts = <int>{};
    final aMapOfIntToDouble = <int, double>{};
    // #enddocregion collection-literals-specified

    expect(aListOfInts, isA<List<int>>());

    expect(aSetOfInts, isA<Set<int>>());

    expect(aMapOfIntToDouble, isA<Map<int, double>>());
  });

  test('collection_literals_subtypes', () {
    // #docregion collection-literals-subtypes
    final aListOfBaseType = <BaseType>[SubType(), SubType()];
    // #enddocregion collection-literals-subtypes

    expect(aListOfBaseType, isA<List<BaseType>>());

    expect(
        aListOfBaseType, containsAllInOrder([isA<SubType>(), isA<SubType>()]));
  });
}

class BaseType {}

class SubType extends BaseType {}
