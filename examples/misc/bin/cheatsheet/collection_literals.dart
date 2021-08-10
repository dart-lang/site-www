// ignore_for_file: unused_local_variable

void main() {
  // #docregion collection-literals
  final aListOfStrings = ['one', 'two', 'three'];
  final aSetOfStrings = {'one', 'two', 'three'};
  final aMapOfStringsToInts = {
    'one': 1,
    'two': 2,
    'three': 3,
  };
  // #enddocregion collection-literals

  // #docregion collection-literals-2
  final aListOfInts = <int>[];
  final aSetOfInts = <int>{};
  final aMapOfIntToDouble = <int, double>{};
  // #enddocregion collection-literals-2

  // #docregion collection-literals-3
  final aListOfBaseType = <BaseType>[SubType(), SubType()];
  // #enddocregion collection-literals-3
}

class BaseType {}

class SubType extends BaseType {}
