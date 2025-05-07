// ignore_for_file: avoid_init_to_null, invalid_null_aware_operator
import 'package:test/test.dart';

void main() {
  // #docregion code_sample
  String? presentKey = 'Apple';
  String? absentKey = null;
  
  int? presentValue = 3;
  int? absentValue = null;
  
  var itemsA = {presentKey: absentValue}; // {Apple: null}
  var itemsB = {presentKey: ?absentValue}; // {}
  
  var itemsC = {absentKey: presentValue}; // {null: 3}
  var itemsD = {?absentKey: presentValue}; // {}
  
  var itemsE = {absentKey: absentValue}; // {null: null}
  var itemsF = {?absentKey: ?absentValue}; // {}
  // #enddocregion code_sample

  print(itemsA);
  print(itemsB);
  print(itemsC);
  print(itemsD);
  print(itemsE);
  print(itemsF);
  expect(itemsA, equals({'Apple': null}));
  expect(itemsB, equals({}));
  expect(itemsC, equals({null: 3}));
  expect(itemsD, equals({}));
  expect(itemsE, equals({null: null}));
  expect(itemsF, equals({}));
}
