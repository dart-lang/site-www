// ignore_for_file: unused_element, type_annotate_public_apis, prefer_function_declarations_over_variables
// ignore_for_file: always_declare_return_types
import 'package:examples/language_tour/function_equality.dart'
    as function_equality;
import 'package:test/test.dart';
import 'package:examples_util/print_matcher.dart' as m;

void main() {
  test('optional-positional-parameters', () {
    // #docregion optional-positional-parameters
    String say(String from, String msg, [String? device]) {
      var result = '$from says $msg';
      if (device != null) {
        result = '$result with a $device';
      }
      return result;
    }

    // #enddocregion optional-positional-parameters
    // #docregion call-without-optional-param
    assert(say('Bob', 'Howdy') == 'Bob says Howdy');
    // #enddocregion call-without-optional-param
    // #docregion call-with-optional-param
    assert(say('Bob', 'Howdy', 'smoke signal') ==
        'Bob says Howdy with a smoke signal');
    // #enddocregion call-with-optional-param
  });

  test('optional-positional-param-default', () {
    // #docregion optional-positional-param-default
    String say(String from, String msg, [String device = 'carrier pigeon']) {
      var result = '$from says $msg with a $device';
      return result;
    }

    assert(say('Bob', 'Howdy') == 'Bob says Howdy with a carrier pigeon');
    // #enddocregion optional-positional-param-default
  });

  test('main-args', () {
    // #docregion main-args
    // Run the app like this: dart args.dart 1 test
    void main(List<String> arguments) {
      print(arguments);

      assert(arguments.length == 2);
      assert(int.parse(arguments[0]) == 1);
      assert(arguments[1] == 'test');
    }

    // #enddocregion main-args
    final args = ['1', 'test'];
    expect(() => main(args), m.prints('[1, test]'));
  });

  test('function-as-var', () {
    // #docregion function-as-var
    var loudify = (msg) => '!!! ${msg.toUpperCase()} !!!';
    assert(loudify('hello') == '!!! HELLO !!!');
    // #enddocregion function-as-var
  });

  const indexedFruit = '''APPLES: 6
BANANAS: 7
ORANGES: 7
''';

  test('anonymous-function', () {
    void testForEachAnonymousFunction() {
      // #docregion anonymous-function-main
      void main() {
        // #docregion anonymous-function
        const list = ['apples', 'bananas', 'oranges'];
        list.map((item) {
          return item.toUpperCase();
        }).forEach((item) {
          print('$item: ${item.length}');
        });
        // #enddocregion anonymous-function
      }
      // #enddocregion anonymous-function-main

      main();
    }

    expect(testForEachAnonymousFunction, prints(indexedFruit));
  });

  test('anon-func', () {
    void testAnonymousFunction() {
      const list = ['apples', 'bananas', 'oranges'];
      // #docregion anon-func
      list
          .map((item) => item.toUpperCase())
          .forEach((item) => print('$item: ${item.length}'));
      // #enddocregion anon-func
    }

    expect(testAnonymousFunction, prints(indexedFruit));
  });

  test('nested-functions', () {
    // #docregion nested-functions
    bool topLevel = true;

    void main() {
      var insideMain = true;

      void myFunction() {
        var insideFunction = true;

        void nestedFunction() {
          var insideNestedFunction = true;

          assert(topLevel);
          assert(insideMain);
          assert(insideFunction);
          assert(insideNestedFunction);
        }
      }
    }
    // #enddocregion nested-functions
  });

  test('function-closure', () {
    // #docregion function-closure
    /// Returns a function that adds [addBy] to the
    /// function's argument.
    Function makeAdder(int addBy) {
      return (int i) => addBy + i;
    }

    void main() {
      // Create a function that adds 2.
      var add2 = makeAdder(2);

      // Create a function that adds 4.
      var add4 = makeAdder(4);

      assert(add2(3) == 5);
      assert(add4(3) == 7);
    }

    // #enddocregion function-closure
    main();
  });

  test('function-equality', () => function_equality.main());

  test('implicit-return-null', () {
    // #docregion implicit-return-null
    foo() {}

    assert(foo() == null);
    // #enddocregion implicit-return-null
  });
}
