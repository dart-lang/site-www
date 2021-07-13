Future<String> createOrderMessage() async {
  var order = await fetchUserOrder();
  return 'Your order is: $order';
}

Future<String> fetchUserOrder() =>
    // Imagine that this function is more complex and slow.
    Future.delayed(
      const Duration(seconds: 2),
      () => 'Large Latte',
    );

// #docregion main-sig
Future<void> main() async {
  // #enddocregion main-sig
  print('Fetching user order...');
  // #docregion print-order
  print(await createOrderMessage());
  // #enddocregion print-order
}
