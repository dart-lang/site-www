Future<String> createOrderMessage() async {
  var order = await fetchUserOrder();
  print("Type of 'order' is ${order.runtimeType}");
  return 'Your order is: $order';
}

Future<String> fetchUserOrder() =>
    // Imagine that this function is more complex and slow.
    Future.delayed(const Duration(seconds: 2), () {
      print("Future completes!");
      return 'Large Latte';
    });

// #docregion main-sig
Future<void> main() async {
  // #enddocregion main-sig
  print('Fetching user order...');
  // #docregion print-order
  var msg = await createOrderMessage(); // DO AWAIT
  print("Type of 'msg' is ${msg.runtimeType}");
  print(msg);
  // #enddocregion print-order
}
