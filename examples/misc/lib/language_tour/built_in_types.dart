// ignore_for_file: unused_local_variable, type_annotate_public_apis
// #docplaster

void miscDeclAnalyzedButNotTested() {
  {
    // #docregion integer-literals
    int x = 1;
    int hex = 0xDEADBEEF;
    // ignore_for_file: 2, integer_literal_out_of_range
    int bigInt = 34653465834652437659238476592374958739845729;
    // #enddocregion integer-literals
  }

  {
    // #docregion double-literals
    double y = 1.1;
    double exponents = 1.42e5;
    // #enddocregion double-literals
  }

  {
    // #docregion const-num
    const msPerSecond = 1000;
    const secondsUntilRetry = 5;
    const msUntilRetry = secondsUntilRetry * msPerSecond;
    // #enddocregion const-num
  }

  {
    // #docregion quoting
    var s1 = 'Single quotes work well for string literals.';
    var s2 = "Double quotes work just as well.";
    var s3 = 'It\'s easy to escape the string delimiter.';
    var s4 = "It's even easier to use the other delimiter.";
    // #enddocregion quoting
  }

  {
    // #docregion raw-strings
    var s = r"In a raw string, even \n isn't special.";
    // #enddocregion raw-strings
  }

  {
    // #docregion string-literals
    // These work in a const string.
    const aConstNum = 0;
    const aConstBool = true;
    const aConstString = 'a constant string';

    // These do NOT work in a const string.
    var aNum = 0;
    var aBool = true;
    var aString = 'a string';
    const aConstList = const [1, 2, 3];

    const validConstString = '$aConstNum $aConstBool $aConstString';
    // const invalidConstString = '$aNum $aBool $aString $aConstList';
    // #enddocregion string-literals
  }

  {
    // #docregion strictly-boolean
    var name = 'Bob';
    // #enddocregion strictly-boolean
    /*
    // #docregion strictly-boolean
    if (name) {
    // #enddocregion strictly-boolean
    */
    if (name != null && name.isNotEmpty) {
      // #docregion strictly-boolean
      // Prints in JavaScript, not in Dart.
      print('You have a name!');
    }
    // #enddocregion strictly-boolean
  }

  {
    var c = true;
    /*
    // #docregion if-one
    if (1) {
    // #enddocregion if-one
    */
    if (c) {
      // #docregion if-one
      print('JS prints this line.');
    } else {
      print('Dart in production mode prints this line.');
      // However, in checked mode, if (1) throws an
      // exception because 1 is not boolean.
    }
    // #enddocregion if-one
  }

  {
    // #docregion list-literal
    var list = [1, 2, 3];
    // #enddocregion list-literal
  }

  {
    // #docregion const-list
    var constantList = const [1, 2, 3];
    // constantList[1] = 1; // Uncommenting this causes an error.
    // #enddocregion const-list
  }

  {
    // #docregion map-literal
    var gifts = {
      // Key:    Value
      'first': 'partridge',
      'second': 'turtledoves',
      'fifth': 'golden rings'
    };

    var nobleGases = {
      2: 'helium',
      10: 'neon',
      18: 'argon',
    };
    // #enddocregion map-literal
  }

  {
    // #docregion map-constructor
    var gifts = new Map();
    gifts['first'] = 'partridge';
    gifts['second'] = 'turtledoves';
    gifts['fifth'] = 'golden rings';

    var nobleGases = new Map();
    nobleGases[2] = 'helium';
    nobleGases[10] = 'neon';
    nobleGases[18] = 'argon';
    // #enddocregion map-constructor
  }

  {
    // #docregion map-add-item
    var gifts = {'first': 'partridge'};
    gifts['fourth'] = 'calling birds'; // Add a key-value pair
    // #enddocregion map-add-item
  }

  {
    // #docregion const-map
    final constantMap = const {
      2: 'helium',
      10: 'neon',
      18: 'argon',
    };

    // constantMap[2] = 'Helium'; // Uncommenting this causes an error.
    // #enddocregion const-map
  }
}

// #docregion triple-quotes
var s1 = '''
You can create
multi-line strings like this one.
''';

var s2 = """This is also a
multi-line string.""";
// #enddocregion triple-quotes

class RunesExample {
  // #docregion runes
  void main() {
    var clapping = '\u{1f44f}';
    print(clapping);
    print(clapping.codeUnits);
    print(clapping.runes.toList());

    Runes input = new Runes(
        '\u2665  \u{1f605}  \u{1f60e}  \u{1f47b}  \u{1f596}  \u{1f44d}');
    print(new String.fromCharCodes(input));
  }
// #enddocregion runes
}

class SymbolExampleNotUsedYet {
  // #docregion symbols
  // MOVE TO library tour?

  void main() {
    print(Function.apply(int.parse, ['11']));
    print(Function.apply(int.parse, ['11'], {#radix: 16}));
    print(Function.apply(int.parse, ['11a'], {#onError: handleError}));
    print(Function
        .apply(int.parse, ['11a'], {#radix: 16, #onError: handleError}));
  }

  int handleError(String source) {
    return 0;
  }
// #enddocregion symbols
}
