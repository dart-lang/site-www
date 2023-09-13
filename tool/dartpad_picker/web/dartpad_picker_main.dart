// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:html';
import 'package:dartpad_picker/dartpad_picker.dart';

void main() {
  if (isMobile()) {
    querySelector('.dash-dartpad')?.style.display = 'none';
    return;
  }

  final dartPadHost = querySelector('#dartpad-host');
  final select = querySelector('#dartpad-select');

  if (dartPadHost == null || select is! SelectElement) {
    return;
  }

  const snippets = [
    Snippet('Hello world', helloWorld),
    Snippet('Functions', functions),
    Snippet('Control flow', controlFlow),
    Snippet('Strings', strings),
    Snippet('Collection literals', collectionLiterals),
    Snippet('Classes', classes),
    Snippet('Compute Pi', piMonteCarlo),
  ];

  DartPadPicker(dartPadHost, select, snippets, frameId: 'try-dart-pad');
}

// Mobile browser detection

final RegExp _mobileRegex =
    RegExp(r'Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini');

bool isMobile() => _mobileRegex.hasMatch(window.navigator.userAgent);

// Snippets

const helloWorld = r'''
void main() {
  print('Hello, World!');
}''';

const functions = r'''
// A function declaration.
int timesTwo(int x) {
  return x * 2;
}

// Arrow syntax is shorthand for `{ return expr; }`.
int timesFour(int x) => timesTwo(timesTwo(x));

// Functions are objects.
int runTwice(int x, int Function(int) f) {
  for (var i = 0; i < 2; i++) {
    x = f(x);
  }
  return x;
}

void main() {
  print('4 times two is ${timesTwo(4)}');
  print('4 times four is ${timesFour(4)}');
  print('2 x 2 x 2 is ${runTwice(2, timesTwo)}');
}''';

const controlFlow = r'''
bool isEven(int x) {
  // An if-else statement.
  if (x % 2 == 0) {
    return true;
  } else {
    return false;
  }
}

List<int> getEvenNumbers(Iterable<int> numbers) {
  var evenNumbers = <int>[];

  // A for-in loop.
  for (var i in numbers) {
    // A single line if statement.
    if (isEven(i)) {
      evenNumbers.add(i);
    }
  }

  return evenNumbers;
}

void main() {
  var numbers = List.generate(10, (i) => i);
  print(getEvenNumbers(numbers));
}''';

const strings = '''
import 'dart:math' as math;

void main() {
  print('a single quoted string');
  print("a double quoted string");

  // Strings can be combined by placing them adjacent to each other.
  print('cat' 'dog');

  // Triple quotes define a multi-line string.
  print(\'''triple quoted strings
are for multiple lines\''');

  // Dart supports string interpolation.
  final pi = math.pi;
  print('pi is \$pi');
  print('tau is \${2 * pi}');
}''';

const collectionLiterals = r'''
// A list literal.
const lostNumbers = [4, 8, 15, 16, 23, 42];

// A map literal.
const nobleGases = {
  'He': 'Helium',
  'Ne': 'Neon',
  'Ar': 'Argon',
};

// A set literal.
const frogs = {
  'Tree',
  'Poison dart',
  'Glass',
};

void main() {
  print(lostNumbers.last);
  print(nobleGases['Ne']);
  print(frogs.difference({'Poison dart'}));
}''';

const classes = r'''
// Abstract classes can't be instantiated.
abstract class Item {
  void use();
}

// Classes can implement other classes.
class Chest<T> implements Item {
  final List<T> contents;

  // Constructors can assign arguments to instance variables using `this`.
  Chest(this.contents);

  @override
  void use() => print('$this has ${contents.length} items.');
}

class Sword implements Item {
  int get damage => 5;

  @override
  void use() => print('$this dealt $damage damage.');
}

// Classes can extend other classes.
class DiamondSword extends Sword {
  @override
  final int damage = 50;
}

void main() {
  // The 'new' keyword is optional.
  var chest = Chest<Item>([
    DiamondSword(),
    Sword(),
  ]);

  chest.use();

  for (final item in chest.contents) {
    item.use();
  }
}''';

const piMonteCarlo = r'''
import 'dart:math' show Random;

void main() async {
  print('Compute π using the Monte Carlo method.');
  await for (final estimate in computePi().take(100)) {
    print('π ≅ $estimate');
  }
}

/// Generates a stream of increasingly accurate estimates of π.
Stream<double> computePi({int batch = 100000}) async* {
  var total = 0; // Inferred to be of type int
  var count = 0;
  while (true) {
    final points = generateRandom().take(batch);
    final inside = points.where((p) => p.isInsideUnitCircle);

    total += batch;
    count += inside.length;
    final ratio = count / total;

    // Area of a circle is A = π⋅r², therefore π = A/r².
    // So, when given random points with x ∈ <0,1>,
    // y ∈ <0,1>, the ratio of those inside a unit circle
    // should approach π / 4. Therefore, the value of π
    // should be:
    yield ratio * 4;
  }
}

Iterable<Point> generateRandom([int? seed]) sync* {
  final random = Random(seed);
  while (true) {
    yield Point(random.nextDouble(), random.nextDouble());
  }
}

class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);

  bool get isInsideUnitCircle => x * x + y * y <= 1;
}''';
