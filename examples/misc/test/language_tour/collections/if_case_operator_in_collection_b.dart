import 'package:test/test.dart';

void main() {
  // #docregion code_sample
  var orderDetails = ['Apples', 12, ''];
  var summary = [
    'Product: ${orderDetails[0]}',
    if (orderDetails case [_, int qty, _]) 'Quantity: $qty',
    if (orderDetails case [_, _, ''])
      'Delivery: Not Started'
    else
      'Delivery: In Progress',
  ]; // [Product: Apples, Quantity: 12, Delivery: Not Started]
  // #enddocregion code_sample

  print(summary);
  expect(
    summary,
    equals(['Product: Apples', 'Quantity: 12', 'Delivery: Not Started']),
  );
}
