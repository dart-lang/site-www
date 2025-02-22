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
  // #docregion switch-break
  void main() {
  String grade = 'B';
  switch (grade) {
    case 'A':
      print('Excellent!');
      break;
    case 'B':
      print('Good Job!');
      break; 
    case 'C':
      print('Needs Improvement');
      break;
    default:
      print('Invalid Grade');
      }
    }
    // #enddocregion switch-break
  }

  {
    // #docregion for-loop-break
    void main() {
    for (int i = 1; i <= 5; i++) {
      if (i == 3) {
        print('Breaking at i = $i');
        break; 
          }
      print(i);
        }
    print('Loop ended.');
      }
    // #enddocregion for-loop-break
  }

  {
    // #docregion while-loop-break
    void main() {
    int i = 1;
    while (i <= 5) {
      if (i == 4) {
        print('Breaking at i = $i');
        break;
      }
      print(i);
      i++;
      }
    }
    // #enddocregion while-loop-break
  }

  {
    // #docregion do-while-loop-break
    void main() {
    int i = 1;
  
    do {
      print('Iteration: $i');
  
      if (i == 3) {
        print('Breaking the loop at i = $i');
        break; 
      }
  
      i++;
    } while (i <= 5);
  
    print('Loop ended.');
    }
    // #enddocregion do-while-loop-break
  }

  {
    // #docregion nested-while-loop-break
    void main() {
    int i = 1;
  
    while (i <= 3) {
      int j = 1;
      while (j <= 3) {
        if (j == 2) {
          break; 
        }
        print('i = $i, j = $j');
        j++;
      }
      i++;
      print('');
      }
    }
    // #enddocregion nested-while-loop-break
  }

  {
    // #docregion for-loop-continue
    void main() {
    for (int i = 1; i <= 5; i++) {
      if (i == 3) {
        continue; 
      }
      print('Iteration: $i');
      }
    }
   // #enddocregion for-loop-continue
  }

  {
    // #docregion while-loop-continue
    void main() {
    int i = 0;
  
    while (i < 5) {
      i++;
      if (i == 3) {
        continue; 
      }
  
      print('Iteration: $i');
      }
    }
   // #enddocregion while-loop-continue
  }

  {
    // #docregion do-while-loop-continue
    void main() {
    int i = 0;
  
    do {
      i++;
  
      if (i == 3) {
        continue; 
      }
  
      print('Iteration: $i');
      } while (i < 5);
    }
   // #enddocregion do-while-loop-continue
  }

  {
    // #docregion nested-while-loop-continue
    void main() {
    int i = 1;
  
    while (i <= 3) {
      int j = 1;
      while (j <= 3) {
        if (j == 2) {
          j++;
          continue;
        }
        print('i = $i, j = $j');
        j++;
      }
      print(''); 
      i++;
      }
    }
   // #enddocregion nested-while-loop-continue
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
