<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>

<div id="try-dart-examples" style="display:none" markdown="1">

### Hello, World!

{:#try-dart-hello-world}
<?code-excerpt "misc/test/samples_test.dart (hello-world)" replace="/void //g"?>
```dart
main() {
  print('Hello, World!');
}
```

### Functions

{:#try-dart-functions}
<?code-excerpt "misc/bin/try_dart/functions.dart"?>
```dart
// A function declaration.
int timesTwo(int x) {
  return x * 2;
}

// Arrow syntax is shorthand for `{ return expr; }`.
int timesFour(int x) => timesTwo(timesTwo(x));

// Functions are objects.
int runTwice(int x, Function f) {
  for (var i = 0; i < 2; i++) {
    x = f(x);
  }
  return x;
}

main() {
  print("4 times two is ${timesTwo(4)}");
  print("4 times four is ${timesFour(4)}");
  print("2 x 2 x 2 is ${runTwice(2, timesTwo)}");
}
```

### Control flow

{:#try-dart-control-flow}
<?code-excerpt "misc/bin/try_dart/control_flow.dart"?>
```dart
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
    // A single-line if statement.
    if (isEven(i)) evenNumbers.add(i);
  }

  return evenNumbers;
}

main() {
  var numbers = List.generate(10, (i) => i);
  print(getEvenNumbers(numbers));
}
```

### Strings

{:#try-dart-strings}
<?code-excerpt "misc/bin/try_dart/strings.dart"?>
```dart
main() {
  print('a single quoted string');
  print("a double quoted string");

  // Strings can be combined with the + operator.
  print('cat' + 'dog');

  // Triple quotes define a multi-line string.
  print('''triple quoted strings
are for multiple lines''');

  // Dart supports string interpolation.
  const pi = 3.14;
  print('pi is $pi');
  print('tau is ${2 * pi}');
}
```

### Collection literals

{:#try-dart-collection-literals}
<?code-excerpt "misc/bin/try_dart/collection_literals.dart"?>
```dart
// A list literal.
var lostNumbers = [4, 8, 15, 16, 23, 42];

// A map literal.
var nobleGases = {
  'He': 'Helium',
  'Ne': 'Neon',
  'Ar': 'Argon',
};

// A set literal.
var frogs = {
  'Tree',
  'Poison dart',
  'Glass',
};

main() {
  print(lostNumbers.last);
  print(nobleGases['Ne']);
  print(frogs.difference({'Poison dart'}));
}
```

### Classes

{:#try-dart-classes}
<?code-excerpt "misc/bin/try_dart/classes.dart"?>
```dart
// Abstract classes can't be instantiated.
abstract class Item {
  use();
}

// Classes can implement other classes.
class Chest<T> implements Item {
  List<T> contents;

  // Constructors can assign arguments to instance variables using `this`.
  Chest(this.contents);

  use() => print("$this has ${contents.length} items.");
}

class Sword implements Item {
  int damage = 5;

  use() => print("$this dealt $damage damage.");
}

// Classes can extend other classes.
class DiamondSword extends Sword {
  int damage = 50;
}

main() {
  // The 'new' keyword is optional.
  var chest = Chest<Item>([
    DiamondSword(),
    Sword(),
  ]);

  chest.use();

  for (var item in chest.contents) {
    item.use();
  }
}
```

### Compute π

{:#try-dart-compute-pi}
<?code-excerpt "misc/lib/pi_monte_carlo.dart (try-dart)" plaster="none" remove="/output|window/" replace="/numIterations/100/g; /\n *\/\/!.*\n/\n/g; / *\/\/!.*\n/\n/g"?>
```dart
import 'dart:math' show Random;

main() async {
  print('Compute π using the Monte Carlo method.');
  await for (var estimate in computePi().take(100)) {
    print('π ≅ $estimate');
  }
}

/// Generates a stream of increasingly accurate estimates of π.
Stream<double> computePi({int batch = 100000}) async* {
  var total = 0;
  var count = 0;
  while (true) {
    var points = generateRandom().take(batch);
    var inside = points.where((p) => p.isInsideUnitCircle);
    total += batch;
    count += inside.length;
    var ratio = count / total;
    // Area of a circle is A = π⋅r², therefore π = A/r².
    // So, when given random points with x ∈ <0,1>,
    // y ∈ <0,1>, the ratio of those inside a unit circle
    // should approach π / 4. Therefore, the value of π
    // should be:
    yield ratio * 4;
  }
}

Iterable<Point> generateRandom([int seed]) sync* {
  final random = Random(seed);
  while (true) {
    yield Point(random.nextDouble(), random.nextDouble());
  }
}

class Point {
  final double x, y;
  const Point(this.x, this.y);
  bool get isInsideUnitCircle => x * x + y * y <= 1;
}
```


<div>
