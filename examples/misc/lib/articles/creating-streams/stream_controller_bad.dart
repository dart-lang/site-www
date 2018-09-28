import 'dart:async';

// #docregion flawed-stream
// NOTE: This implementation is FLAWED!
// It starts before it has subscribers, and it doesn't implement pause.
Stream<int> timedCounter(Duration interval, [int maxCount]) {
  StreamController<int> controller = StreamController<int>();
  int counter = 0;
  void tick(Timer timer) {
    counter++;
    controller.add(counter); // Ask stream to send counter values as event.
    if (maxCount != null && counter >= maxCount) {
      timer.cancel();
      controller.close(); // Ask stream to shut down and tell listeners.
    }
  }

  Timer.periodic(interval, tick); // BAD: Starts before it has subscribers.
  return controller.stream;
}
// #enddocregion flawed-stream

void main() {
//   showBasicUsage();
//   showPreSubscribeProblem();
  showPauseProblem();
}

void showBasicUsage() {
  // #docregion using-stream
  Stream<int> counterStream = timedCounter(const Duration(seconds: 1), 15);
  counterStream.listen(print); // Print an integer every second, 15 times.
  // #enddocregion using-stream
}

void showPreSubscribeProblem() async {
  // #docregion pre-subscribe-problem
  var counterStream = timedCounter(const Duration(seconds: 1), 15);
  await Future.delayed(const Duration(seconds: 5));

  // After 5 seconds, add a listener.
  await for (int n in counterStream) {
    print(n); // Print an integer every second, 15 times.
  }
  // #enddocregion pre-subscribe-problem
}

void showPauseProblem() {
  // #docregion pause-problem
  Stream<int> counterStream = timedCounter(const Duration(seconds: 1), 15);
  StreamSubscription<int> subscription;
  subscription = counterStream.listen((int counter) {
    print(counter); // Print an integer every second.
    if (counter == 5) {
      // After 5 ticks, pause for five seconds, then resume.
      subscription.pause(Future.delayed(const Duration(seconds: 5)));
    }
  });
  // #enddocregion pause-problem
  subscription.cancel();
}
