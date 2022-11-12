// ignore_for_file: unused_element, type_annotate_public_apis, always_declare_return_types
// ignore_for_file: no_leading_underscores_for_local_identifiers

void miscDeclAnalyzedButNotTested() {
  final _nobleGases = {};

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
    void enableFlags({bool? bold, bool? hidden}) {/*...*/}
    // #enddocregion specify-named-parameters

    // #docregion use-named-parameters
    enableFlags(bold: true, hidden: false);
    // #enddocregion use-named-parameters

    void repeat(Function func, {int times = 1}) {}

    // #docregion named-arguments-anywhere
    repeat(times: 2, () {
      /*...*/
    });
    // #enddocregion named-arguments-anywhere
  }

  {
    // #docregion named-parameter-default-values
    /// Sets the [bold] and [hidden] flags ...
    void enableFlags({bool bold = false, bool hidden = false}) {/*...*/}

    // bold will be true; hidden will be false.
    enableFlags(bold: true);
    // #enddocregion named-parameter-default-values
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

class Key {}

abstract class Widget {
  const Widget({Key? key});
}

class Scrollbar extends Widget {
  // #docregion required-named-parameters
  const Scrollbar({super.key, required Widget child});
  // #enddocregion required-named-parameters
}

class ScrollbarTwo extends Widget {
  // #docregion required-named-parameters-nullable
  const ScrollbarTwo({super.key, required Widget? child});
  // #enddocregion required-named-parameters-nullable
}
