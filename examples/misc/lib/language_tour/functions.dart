// ignore_for_file: unused_element, type_annotate_public_apis
// #docplaster

void miscDeclAnalyzedButNotTested() {
  var _nobleGases = {};

  {
    // #docregion function
    bool isNoble(int atomicNumber) {
      return _nobleGases[atomicNumber] != null;
    }
    // #enddocregion function
  }

  {
    // #docregion function-omitting-types
    isNoble(atomicNumber) {
      return _nobleGases[atomicNumber] != null;
    }
    // #enddocregion function-omitting-types
  }

  {
    // #docregion function-shorthand
    bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;
    // #enddocregion function-shorthand
  }

  {
    // #docregion specify-named-parameters
    /// Sets the [bold] and [hidden] flags ...
    void enableFlags({bool bold, bool hidden}) {
      // ...
    }
    // #enddocregion specify-named-parameters

    // #docregion use-named-parameters
    enableFlags(bold: true, hidden: false);
    // #enddocregion use-named-parameters
  }

  {
    // #docregion named-parameter-default-values
    /// Sets the [bold] and [hidden] flags ...
    void enableFlags({bool bold = false, bool hidden = false}) {
      // ...
    }

    // bold will be true; hidden will be false.
    enableFlags(bold: true);
    // #enddocregion named-parameter-default-values
  }

  {
    // #docregion list-map-default-function-param
    void doStuff(
        {List<int> list = const [1, 2, 3],
        Map<String, String> gifts = const {
          'first': 'paper',
          'second': 'cotton',
          'third': 'leather'
        }}) {
      print('list:  $list');
      print('gifts: $gifts');
    }
    // #enddocregion list-map-default-function-param
  }

  {
    // #docregion function-as-param
    void printElement(int element) {
      print(element);
    }

    var list = [1, 2, 3];

    // Pass printElement as a parameter.
    list.forEach(printElement);
    // #enddocregion function-as-param
  }
}
