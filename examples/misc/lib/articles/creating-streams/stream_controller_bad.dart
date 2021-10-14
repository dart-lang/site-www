// ignore_for_file: cancel_subscriptions
import 'dart:async';

// #docregion flawed-stream
// NOTE: This implementation is FLAWED!
// It starts before it has subscribers, and it doesn't implement pause.
Stream<int> timedCounter(Duration interval, [int? maxCount]) {
  var controller = StreamController<int>();
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
//   listenAfterDelay();
  listenWithPause();
}

void showBasicUsage() {
  // #docregion using-stream
  var counterStream = timedCounter(const Duration(seconds: 1), 15);
  counterStream.listen(print); // Print an integer every second, 15 times.
  // #enddocregion using-stream
}

// #docregion pre-subscribe-problem
void listenAfterDelay() async {
  var counterStream = timedCounter(const Duration(seconds: 1), 15);
  await Future.delayed(const Duration(seconds: 5));

  // After 5 seconds, add a listener.
  await for (final n in counterStream) {
    print(n); // Print an integer every second, 15 times.
  }
}
// #enddocregion pre-subscribe-problem

// #docregion pause-problem
void listenWithPause() {
  var counterStream = timedCounter(const Duration(seconds: 1), 15);
  late StreamSubscription<int> subscription;

  subscription = counterStream.listen((int counter) {
    print(counter); // Print an integer every second.
    if (counter == 5) {
      // After 5 ticks, pause for five seconds, then resume.
      subscription.pause(Future.delayed(const Duration(seconds: 5)));
    }
  });
}
// #enddocregion pause-problem
