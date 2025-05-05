import 'package:test/test.dart';

void main() {
  // #docregion code_sample
  String? itemX = 'Apple';
  String? itemY = null;
  
  int? quantityX = 3;
  int? quantityY = null;
  
  var inventoryA = {itemX: quantityY}; // {Apple: null}
  var inventoryB = {itemX: ?quantityY}; // {}
  
  var inventoryC = {itemY: quantityX}; // {null: 3}
  var inventoryD = {?itemY: quantityX}; // {}
  
  var inventoryE = {itemY: quantityY}; // {null: null}
  var inventoryF = {?itemY: ?quantityY}; // {}
  // #enddocregion code_sample

  print(inventoryA);
  print(inventoryB);
  print(inventoryC);
  print(inventoryD);
  print(inventoryE);
  print(inventoryF);
  expect(inventoryA, equals({'Apple': null}));
  expect(inventoryB, equals({}));
  expect(inventoryC, equals({null: 3}));
  expect(inventoryD, equals({}));
  expect(inventoryE, equals({null: null}));
  expect(inventoryF, equals({}));
}
