import 'dart:math' show Random;        // Import a class from a library.

void main() {                          // This is where the app starts executing.
  print(new Die(n: 12).roll());         // Print a new object's value. Chain method calls.
}

class Die {                            // Define a class.
  static Random shaker = new Random(); // Define a class variable.
  int sides, value;                    // Define instance variables.

  String toString() => '$value';       // Define a method using shorthand syntax.

  Die({int n: 6}) {                    // Define a constructor.
    if (4 <= n && n <= 20) {
      sides = n;
    } else {
      throw new ArgumentError(/* */);  // Support for errors and exceptions.
    }
  }
  int roll() {                         // Define an instance method.
    return value = shaker.nextInt(sides); // Get a random number.
  }
}
