Future<void> printOrderMessage() async {
  print('Awaiting user order...');
  var order = await fetchUserOrder();
  print('Your order is: $order');
}

Future<String> fetchUserOrder() {
  // Imagine that this function is more complex and slow.
  return Future.delayed(const Duration(seconds: 4), () => 'Large Latte');
}

// #docregion awaiting
const bool doAwait = true;
// #enddocregion awaiting

void main() async {
  countSeconds(4);
  if (doAwait) {
    await printOrderMessage();
  } else {
    printOrderMessage();
  }
  print("Exiting main()");
}

// You can ignore this function - it's here to visualize delay time in this example.
void countSeconds(int s) {
  for (var i = 1; i <= s; i++) {
    Future.delayed(Duration(seconds: i), () => print(i));
  }
}
