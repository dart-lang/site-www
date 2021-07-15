// This example shows how *not* to write asynchronous Dart code.

// #docregion no-warning
String createOrderMessage() {
  var order = fetchUserOrder();
  return 'Your order is: $order';
}

Future<String> fetchUserOrder() =>
    // Imagine that this function is more complex and slow.
    Future.delayed(
      const Duration(seconds: 2),
      () => 'Large Latte',
    );

// #docregion main-sig
void main() {
  // #enddocregion main-sig
  print('Fetching user order...');
  print(createOrderMessage());
}
