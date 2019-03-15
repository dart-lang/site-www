// ignore_for_file: unused_local_variable, type_annotate_public_apis

void miscDeclAnalyzedButNotTested() {
  {
    // #docregion integer-literals
    var x = 1;
    var hex = 0xDEADBEEF;
    // #enddocregion integer-literals
  }

  {
    // #docregion double-literals
    var y = 1.1;
    var exponents = 1.42e5;
    // #enddocregion double-literals
  }

  {
    // #docregion int-to-double
    double z = 1; // Equivalent to double z = 1.0.
    // #enddocregion int-to-double
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
    var s = r'In a raw string, not even \n gets special treatment.';
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
    const aConstList = [1, 2, 3];

    const validConstString = '$aConstNum $aConstBool $aConstString';
    // const invalidConstString = '$aNum $aBool $aString $aConstList';
    // #enddocregion string-literals
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
    // #docregion set-literal
    var halogens = {'fluorine', 'chlorine', 'bromine', 'iodine', 'astatine'};
    // #enddocregion set-literal

    // #docregion set-vs-map
    var names = <String>{};
    // Set<String> names = {}; // This works, too.
    // var names = {}; // Creates a map, not a set.
    // #enddocregion set-vs-map

    // #docregion set-add-items
    var elements = <String>{};
    elements.add('fluorine');
    elements.addAll(halogens);
    // #enddocregion set-add-items
  }

  {
    // #docregion const-set
    final constantSet = const {
      'fluorine',
      'chlorine',
      'bromine',
      'iodine',
      'astatine',
    };
    // constantSet.add('helium'); // Uncommenting this causes an error.
    // #enddocregion const-set
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
    var gifts = Map();
    gifts['first'] = 'partridge';
    gifts['second'] = 'turtledoves';
    gifts['fifth'] = 'golden rings';

    var nobleGases = Map();
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

    Runes input =
        Runes('\u2665  \u{1f605}  \u{1f60e}  \u{1f47b}  \u{1f596}  \u{1f44d}');
    print(String.fromCharCodes(input));
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
    print(Function.apply(
        int.parse, ['11a'], {#radix: 16, #onError: handleError}));
  }

  int handleError(String source) {
    return 0;
  }
// #enddocregion symbols
}
