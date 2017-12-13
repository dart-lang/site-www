// ignore_for_file: annotate_overrides, type_annotate_public_apis, unused_element, unused_local_variable
import 'dart:async';
import 'dart:math';

void miscDeclAnalyzedButNotTested() {
  {
    // #docregion misc-names
    var item;

    HttpRequest httpRequest;

    void align(bool clearItems) {
      // ...
    }
    // #enddocregion misc-names
    align(item == httpRequest); // Avoid unused variable warnings
  }

  {
    var uiHandler;
    print([
      // #docregion acronyms-and-abbreviations
      HttpConnection,
      uiHandler,
      IOStream,
      HttpRequest,
      Id,
      DB,
      // #enddocregion acronyms-and-abbreviations
    ]);
  }

  {
    var isWeekDay;
    // #docregion curly-braces
    if (isWeekDay) {
      print('Bike to work!');
    } else {
      print('Go dancing or read a book!');
    }
    // #enddocregion curly-braces
  }

  {
    var arg, defaultValue;
    // #docregion one-line-if
    if (arg == null) return defaultValue;
    // #enddocregion one-line-if
  }

  {
    var parameter, limit, defaultValue;
    // #docregion one-line-if-expr
    if (parameter > limit) parameter = defaultValue;
    // #enddocregion one-line-if-expr
  }

  {
    var first, second, statement;
    // #docregion newline-after-decl
    main() {
      first(statement);
      second(statement);
    }

    anotherDeclaration() {/* ... */}
    // #enddocregion newline-after-decl
  }

  {
    var a, b, average, largest, obj;
    // #docregion bin-op
    average = (a + b) / 2;
    largest = a > b ? a : b;
    if (obj is! SomeType) print('not SomeType');
    // #enddocregion bin-op
  }

  {
    var function, a, b, c, some, list, map, literal;
    var x = [
      // #docregion space-after-comma-etc
      function(a, b, named: c),
      [some, list, literal],
      {map: literal},
      // #enddocregion space-after-comma-etc
    ];
  }

  {
    var condition,
        index,
        x = [
      // #docregion unary-op
      !condition,
      index++
      // #enddocregion unary-op
    ];
  }

  {
    var collection;
    // #docregion for-in-etc
    for (var i = 0; i < 100; i++) {/* ... */}

    for (final item in collection) {/* ... */}
    // #enddocregion for-in-etc
  }

  {
    var foo;
    // #docregion flow-keyword
    while (foo) {/* ... */}

    try {
      // ...
    } catch (e) {
      // ...
    }
    // #enddocregion flow-keyword
  }

  {
    // #docregion parentheses-etc
    var numbers = <int>[1, 2, (3 + 4)];
    // #enddocregion parentheses-etc
  }

  {
    // #docregion open-curly-brace-space-after
    getEmptyFn(a) {
      return () {};
    }
    // #enddocregion open-curly-brace-space-after
  }

  {
    var hasWhippedCreamAndStrawberries;
    var isDeepFried, hasPieCrust, vegan, containsBacon;
    // #docregion multi-bin-op
    var bobLikesIt = isDeepFried || //!
        (hasPieCrust && !vegan) || //!
        containsBacon;

    // #docregion four-spaces-for-arrow
    bobLikes() => //!
        isDeepFried || (hasPieCrust && !vegan) || containsBacon;
    // #enddocregion four-spaces-for-arrow, multi-bin-op
  }

  ternaryOp() {
    var someCondition, whenTrue, whenFalse;
    // #docregion ternary-op
    return someCondition //!
        ? whenTrue //!
        : whenFalse;
    // #enddocregion ternary-op
  }

  {
    var someVeryLongVariableName, args;
    // #docregion multi-dot
    someVeryLongVariableName.withAVeryLongPropertyName
        .aReallyLongMethodName(args);
    // #enddocregion multi-dot
  }

  {
    var mapInsideList;
    // #docregion collection-literal
    mapInsideList([
      {
        'a': 'b', //!
        'c': 'd' //!
      },
      {
        'a': 'b', //!
        'c': 'd' //!
      },
    ]);
    // #enddocregion collection-literal
  }

  {
    var condition, buckminsterfullerene, dodecahedrane, olympiadane;
    // #docregion block-and-collections
    if (condition) {
      print('hi');
    }

    var compoundsWithLongNames = [
      buckminsterfullerene,
      dodecahedrane,
      olympiadane
    ];
    // #enddocregion block-and-collections
  }

  {
    var fruit;
    // #docregion switch
    switch (fruit) {
      case 'apple':
        print('delish');
        break;

      case 'durian':
        print('stinky');
        break;
    }
    // #enddocregion switch
  }

  {
    var buffer, name;
    // #docregion cascade
    buffer
      ..write('Hello, ') //!
      ..write(name)
      ..write('!');
    // #enddocregion cascade
  }

  {
    var someVeryLongVariableName, arg, anotherArg, wrappedToNextLine;
    // #docregion four-spaces
    someVeryLongVariableName.aReallyLongMethodName(
        arg, anotherArg, wrappedToNextLine);
    // #enddocregion four-spaces
  }

  {
    var args;
    // #docregion exceptions-to-four-spaces
    new Future.delayed(const Duration(seconds: 1), () {
      print('I am a callback');
    });

    args.addAll([
      '--mode', //!
      'release', //!
      '--checked'
    ]);

    // #enddocregion exceptions-to-four-spaces
  }
}

//----------------------------------------------------------------------------

class DB {}

class HttpConnection {}

class Id {}

class IOStream {}

class SomeType {}

//----------------------------------------------------------------------------

// #docregion type-names
class SliderMenu {/* ... */}

class HttpRequest {/* ... */}

typedef bool Predicate<T>(T value);
// #enddocregion type-names

//----------------------------------------------------------------------------

const Null anArg = null;

// #docregion annotation-type-names
class Foo {
  const Foo([arg]);
}

@Foo(anArg)
class A {/* ... */}

@Foo()
class B {/* ... */}
// #enddocregion annotation-type-names

//----------------------------------------------------------------------------

// #docregion annotation-const
const foo = const Foo();

@foo
class C {/* ... */}
// #enddocregion annotation-const

//----------------------------------------------------------------------------

// #docregion const-names
const pi = 3.14;
const defaultTimeout = 1000;
final urlScheme = new RegExp('^([a-z]+):');

class Dice {
  static final numberGenerator = new Random();
}
// #enddocregion const-names

//----------------------------------------------------------------------------

class Args {
  dynamic ellipsis;
  // #docregion args-etc-no-spaces
  log(arg) {/* ... */}
  // #docregion space-after-operator
  bool operator ==(other) => ellipsis;
  // #enddocregion space-after-operator
  set contents(value) {/* ... */}
  // #enddocregion args-etc-no-spaces
  @override
  int hashCode() => 0;
}

//----------------------------------------------------------------------------

bool someCondition;

// #docregion open-curly-brace-same-line
class Foo2 {
  method() {
    if (someCondition) {
      // ...
    } else {
      // ...
    }
  }
}
// #enddocregion open-curly-brace-same-line

//----------------------------------------------------------------------------

class MyClass {
  var firstField, secondField, thirdField;
  // #docregion ctr-field-init
  MyClass()
      : firstField = 'some value',
        secondField = 'another',
        thirdField = 'last' {
    // ...
  }
// #enddocregion ctr-field-init
}
