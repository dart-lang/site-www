// ignore_for_file: unused_local_variable, dead_code, unreachable_switch_case

class Point {
  final int x;
  final int y;

  Point(this.x, this.y);
}

dynamic miscDeclAnalyzedButNotTested() {
  var pair = [1, 2];

  {
    bool isRaining() => true;
    bool isSnowing() => true;
    dynamic car, you;
    // #docregion if-else
    if (isRaining()) {
      you.bringRainCoat();
    } else if (isSnowing()) {
      you.wearJacket();
    } else {
      car.putTopDown();
    }
    // #enddocregion if-else
  }

  {
    // #docregion if-case
    if (pair case [int x, int y]) return Point(x, y);
    // #enddocregion if-case
  }

  {
    // #docregion if-case-else
    if (pair case [int x, int y]) {
      print('Was coordinate array $x,$y');
    } else {
      throw FormatException('Invalid coordinates.');
    }
    // #enddocregion if-case-else
  }

  void executeClosed() {}
  void executePending() {}
  void executeApproved() {}
  void executeDenied() {}
  void executeOpen() {}
  void executeUnknown() {}
  void executeNowClosed() {}

  {
    // #docregion switch
    var command = 'OPEN';
    switch (command) {
      case 'CLOSED':
        executeClosed();
      case 'PENDING':
        executePending();
      case 'APPROVED':
        executeApproved();
      case 'DENIED':
        executeDenied();
      case 'OPEN':
        executeOpen();
      default:
        executeUnknown();
    }
    // #enddocregion switch
  }

  {
    var command = 'OPEN';
    // #docregion switch-empty
    switch (command) {
      case 'OPEN':
        executeOpen();
        continue newCase; // Continues executing at the newCase label.

      case 'DENIED': // Empty case falls through.
      case 'CLOSED':
        executeClosed(); // Runs for both DENIED and CLOSED,

      newCase:
      case 'PENDING':
        executeNowClosed(); // Runs for both OPEN and PENDING.
    }
    // #enddocregion switch-empty
  }

  {
  // #docregion syntax-label
    labelName:
    for (/* condition */) {
    // code
    }
    // #enddocregion syntax-label
  }

  {
    // #docregion label-for-loop-break
    void main() {
    outerLoop:
    for (int i = 1; i <= 3; i++) {
      for (int j = 1; j <= 3; j++) {
        print("i = $i, j = $j");
        if (i == 2 && j == 2) {
          break outerLoop;
        }
      }
    }
    print("outerLoop exited");
    }
    // #enddocregion label-for-loop-break
  }

  {
    // #docregion label-for-loop-continue
    void main() {
    outerLoop:
    for (int i = 1; i <= 3; i++) {
      for (int j = 1; j <= 3; j++) {
        if (i == 2 && j == 2) {
          continue outerLoop;
        }
        print("i = $i, j = $j");
        }
      }
    }
    // #enddocregion label-for-loop-continue
  }

  {
    // #docregion label-while-loop-break
   void main() {
    int i = 1;
    outerLoop:
    while (i <= 3) {
      int j = 1;
      while (j <= 3) {
        print("i = $i, j = $j");
        if (i == 2 && j == 2) {
          break outerLoop; 
        }
        j++;
      }
      i++;
    }
    print("outerLoop exited");
    }
    // #enddocregion label-while-loop-break
  }

  {
    // #docregion label-while-loop-continue
    void main() {
    int i = 1;
    
    outerLoop:
    while (i <= 3) {
      int j = 1;
      while (j <= 3) {
        if (i == 2 && j == 2) {
          i++; 
          continue outerLoop;
        }
        print("i = $i, j = $j");
        j++;
        }
        i++;
      }
    }
    // #enddocregion label-while-loop-continue
  }

  {
    // #docregion label-do-while-loop-break
    
    void main() {
      int i = 1;
      outerLoop:
      do {
        int j = 1;
        do {
          print("i = $i, j = $j");
          if (i == 2 && j == 2) {
            break outerLoop;
          }
          j++;
        } while (j <= 3);
        i++;
      } while (i <= 3);
    
      print("outerLoop exited");
    }
   // #enddocregion label-do-while-loop-break
  }

  {
    // #docregion label-do-while-loop-continue
    void main() {
      int i = 1;
    
      outerLoop:
      do {
        int j = 1;
        do {
          if (i == 2 && j == 2) {
            i++; 
            continue outerLoop;
          }
          print("i = $i, j = $j");
          j++;
        } while (j <= 3);
        i++;
      } while (i <= 3);
    }
   // #enddocregion label-do-while-loop-continue
  }

  {
    dynamic charCode;
    const slash = '/';
    const star = '*';
    const plus = '+';
    const minus = '-';
    const comma = ',';
    const semicolon = ',';
    const int digit0 = 0;
    const int digit9 = 9;
    Object? token;

    dynamic operator(dynamic x) {}
    dynamic punctuation(dynamic x) {}
    dynamic number() {}

    // #docregion switch-stmt
    // Where slash, star, comma, semicolon, etc., are constant variables...
    switch (charCode) {
      case slash || star || plus || minus: // Logical-or pattern
        token = operator(charCode);
      case comma || semicolon: // Logical-or pattern
        token = punctuation(charCode);
      case >= digit0 && <= digit9: // Relational and logical-and patterns
        token = number();
      default:
        throw FormatException('Invalid');
    }
    // #enddocregion switch-stmt

    // #docregion switch-exp
    token = switch (charCode) {
      slash || star || plus || minus => operator(charCode),
      comma || semicolon => punctuation(charCode),
      >= digit0 && <= digit9 => number(),
      _ => throw FormatException('Invalid'),
    };
    // #enddocregion switch-exp
  }

  {
    bool? nullableBool = false;
    // #docregion exh-bool
    // Non-exhaustive switch on bool?, missing case to match null possibility:
    switch (nullableBool) {
      case true:
        print('yes');
      case false:
        print('no');
    }
    // #enddocregion exh-bool
  }

  {
    final pair = (1, 2);
    // #docregion guard
    switch (pair) {
      case (int a, int b):
        if (a > b) print('First element greater');
      // If false, prints nothing and exits the switch.
      case (int a, int b) when a > b:
        // If false, prints nothing but proceeds to next case.
        print('First element greater');
      case (int a, int b):
        print('First element not greater');
    }
    // #enddocregion guard
  }
}
