// ignore_for_file: unused_local_variable

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
      _ => throw FormatException('Invalid')
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
      case (int a, int b) when a > b:
        print('First element greater');
      case (int a, int b):
        print('First element not greater');
    }
    // #enddocregion guard
  }
}
