import 'dart:async';

Stream<int> timedCounter(Duration interval, [int maxCount]) {
  StreamController<int> controller;
  Timer timer;
  int counter = 0;

  void tick(_) {
    counter++;
    controller.add(counter); // Ask stream to send counter values as event.
    if (maxCount != null && counter >= maxCount) {
      timer.cancel();
      controller.close(); // Ask stream to shut down and tell listeners.
    }
  }

  void startTimer() {
    timer = new Timer.periodic(interval, tick);
  }

  void stopTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  controller = new StreamController<int>(
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
      onCancel: stopTimer);

  return controller.stream;
}

main() {
  showBasicUsage();
  // useMap();
  // useWhere();
  // useExpand();
  // useTake();
  // demoPause();
}

showBasicUsage() {
  Stream<int> counterStream = timedCounter(const Duration(seconds: 1), 15);
  counterStream.listen(print); // Print an integer every second, 15 times.
}

demoPause() {
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

void useMap() {
  Stream<int> counterStream2 = timedCounter(const Duration(seconds: 1), 15)
      .map((int x) => x * 2); // Double the integer in each event.
  counterStream2.listen(print);
}

void useWhere() {
  Stream<int> counterStream2 = timedCounter(const Duration(seconds: 1), 15)
      .where((int x) => x.isEven); // Retain only even integer events.
  counterStream2.listen(print);
}

void useExpand() {
  Stream<int> counterStream2 = timedCounter(const Duration(seconds: 1), 15)
      .expand((var x) => [x, x]); // Duplicate each event.
  counterStream2.listen(print);
}

void useTake() {
  Stream<int> counterStream2 = timedCounter(const Duration(seconds: 1), 15)
      .take(5); // Stop after the first five events.
  counterStream2.listen(print);
}
