import 'dart:async';

// NOTE: This implementation is FLAWED!
// It starts before it has subscribers, and it doesn't implement pause.
Stream<int> timedCounter(Duration interval, [int maxCount]) {
  StreamController<int> controller = new StreamController<int>();
  int counter = 0;
  void tick(Timer timer) {
    counter++;
    controller.add(counter); // Ask stream to send counter values as event.
    if (maxCount != null && counter >= maxCount) {
      timer.cancel();
      controller.close(); // Ask stream to shut down and tell listeners.
    }
  }

  new Timer.periodic(interval, tick); // BAD: Starts before it has subscribers.
  return controller.stream;
}

main() {
  // showBasicUsage();
  showPreSubscribeProblem();
  // showPauseProblem();
}

showBasicUsage() {
  Stream<int> counterStream = timedCounter(const Duration(seconds: 1), 15);
  counterStream.listen(print); // Print an integer every second, 15 times.
}

showPreSubscribeProblem() {
  var counterStream = timedCounter(const Duration(seconds: 1), 15);

  // After 5 seconds, add a listener.
  new Timer(const Duration(seconds: 5), () => counterStream.listen(print));
}

showPauseProblem() {
  Stream<int> counterStream = timedCounter(const Duration(seconds: 1), 15);
  StreamSubscription<int> subscription;
  subscription = counterStream.listen((int counter) {
    print(counter); // Print an integer every second.
    if (counter == 5) {
      // After 5 ticks, pause for five seconds, then resume.
      subscription.pause();
      new Timer(const Duration(seconds: 5), subscription.resume);
    }
  });
}
