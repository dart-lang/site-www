Future<void> printOrderMessage() async {
  print('Awaiting user order...');
  // #docregion swap-stmts
  var order = await fetchUserOrder();
  // print('Awaiting user order...');
  // #enddocregion swap-stmts
  print('Your order is: $order');
}

Future<String> fetchUserOrder() {
  // Imagine that this function is more complex and slow.
  return Future.delayed(const Duration(seconds: 4), () => 'Large Latte');
}

void main() async {
  countSeconds(4);
  await printOrderMessage();
}

// You can ignore this function - it's here to visualize delay time in this example.
void countSeconds(int s) {
  for (var i = 1; i <= s; i++) {
    Future.delayed(Duration(seconds: i), () => print(i));
  }
}
