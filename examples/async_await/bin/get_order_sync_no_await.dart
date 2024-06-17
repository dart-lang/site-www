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

Future<void> main() async {
  print('Fetching user order...');
  var msg = createOrderMessage(); // DO NOT AWAIT
  print("Type of 'msg' is ${msg.runtimeType}");
  print(msg);
}
