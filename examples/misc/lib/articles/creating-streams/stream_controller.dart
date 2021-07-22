import 'dart:async';
import 'dart:convert';
import 'dart:io';

// #docregion async-generator
Stream<int> timedCounterGenerator(Duration interval, [int? maxCount]) async* {
  int i = 0;
  while (true) {
    await Future.delayed(interval);
    yield i++;
    if (i == maxCount) break;
  }
}
// #enddocregion async-generator

// #docregion stream-from-futures
Stream<T> streamFromFutures<T>(Iterable<Future<T>> futures) async* {
  for (var future in futures) {
    var result = await future;
    yield result;
  }
}
// #enddocregion stream-from-futures

// #docregion better-stream
Stream<int> timedCounter(Duration interval, [int? maxCount]) {
  late StreamController<int> controller;
  Timer? timer;
  int counter = 0;

  void tick(_) {
    counter++;
    controller.add(counter); // Ask stream to send counter values as event.
    if (counter == maxCount) {
      timer?.cancel();
      controller.close(); // Ask stream to shut down and tell listeners.
    }
  }

  void startTimer() {
    timer = Timer.periodic(interval, tick);
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  controller = StreamController<int>(
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
      onCancel: stopTimer);

  return controller.stream;
}
// #enddocregion better-stream

void main() {
//  showBasicUsage();
//  useMap();
//  useWhere();
//  useTransform();
//  useExpand();
//  useGenerator();
  useStreamFromFutureGenerator();
  // useTake();
  // demoPause();
}

void showBasicUsage() {
  // #docregion basic-usage
  var counterStream =
      Stream<int>.periodic(const Duration(seconds: 1), (x) => x).take(15);
  // #enddocregion basic-usage

  // #docregion basic-for-each
  counterStream.forEach(print); // Print an integer every second, 15 times.
  // #enddocregion basic-for-each
}

void demoPause() {
  var counterStream =
      Stream<int>.periodic(const Duration(seconds: 1), (x) => x).take(15);
  late StreamSubscription<int> subscription;

  subscription = counterStream.listen((int counter) {
    print(counter); // Print an integer every second.
    if (counter == 5) {
      // After 5 ticks, pause for five seconds, then resume.
      subscription.pause();
      Timer(const Duration(seconds: 5), subscription.resume);
    }
  });
  subscription.cancel();
}

void useMap() {
  var counterStream =
      Stream<int>.periodic(const Duration(seconds: 1), (x) => x).take(15);

  // #docregion use-map
  // Double the integer in each event.
  var doubleCounterStream = counterStream.map((int x) => x * 2);
  doubleCounterStream.forEach(print);
  // #enddocregion use-map
}

void useWhere() {
  var counterStream =
      Stream<int>.periodic(const Duration(seconds: 1), (x) => x).take(15);

  var mappedStream = counterStream
          // #docregion use-where
          .where((int x) => x.isEven) // Retain only even integer events.
          .expand((var x) => [x, x]) // Duplicate each event.
          .take(5) // Stop after the first five events.
      // #enddocregion use-where
      ;

  mappedStream.forEach(print);
}

void useTransform() async {
  // #docregion use-transform
  Stream<List<int>> content = File('someFile.txt').openRead();
  List<String> lines =
      await content.transform(utf8.decoder).transform(LineSplitter()).toList();
  // #enddocregion use-transform

  print(lines);
}

late StreamSubscription<int> subscription;

void handleInt(int number) {
  if (number == 3) {
    print('Found $number!');
    subscription.cancel();
  } else {
    print(number);
  }
}

void useGenerator() {
  var generatedStream = timedCounterGenerator(const Duration(seconds: 1), 15);
  subscription = generatedStream.listen(handleInt);
}

void useStreamFromFutureGenerator() {
  var futures = [Future.value(1), Future.value(2), Future.value(3)];
  var generatedStream = streamFromFutures(futures);
  generatedStream.listen(print);
}

void useExpand() {
  var counterStream2 = timedCounterGenerator(const Duration(seconds: 1), 15)
      .expand((var x) => [x, x]); // Duplicate each event.
  counterStream2.listen(print);
}

void useTake() {
  var counterStream2 = timedCounterGenerator(const Duration(seconds: 1), 15)
      .take(5); // Stop after the first five events.
  counterStream2.listen(print);
}
