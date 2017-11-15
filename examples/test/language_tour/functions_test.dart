// ignore_for_file: unused_element, type_annotate_public_apis
import 'package:test/test.dart';

import 'package:examples/language_tour/function_equality.dart'
    as function_equality;
import 'package:examples/language_tour/util/logging_printer.dart';
import 'package:examples/language_tour/util/print.dart';

void main() {
  final printLog = PrintLog.it;

  setUpAll(() => PrintLog.set$print());
  setUp(() => printLog.clear());

  test('optional-positional-parameters', () {
    // #docregion optional-positional-parameters
    String say(String from, String msg, [String device]) {
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
    String say(String from, String msg,
        [String device = 'carrier pigeon', String mood]) {
      var result = '$from says $msg';
      if (device != null) {
        result = '$result with a $device';
      }
      if (mood != null) {
        result = '$result (in a $mood mood)';
      }
      return result;
    }

    assert(say('Bob', 'Howdy') ==
        'Bob says Howdy with a carrier pigeon');
    // #enddocregion optional-positional-param-default
  });

  test('main-args', () {
    // #docregion main-args
    // Run the app like this: dart args.dart 1 test
    void main(List<String> arguments) {
      $print(arguments);

      assert(arguments.length == 2);
      assert(int.parse(arguments[0]) == 1);
      assert(arguments[1] == 'test');
    }

    // #enddocregion main-args
    final args = ['1', 'test'];
    main(args);
    expect(printLog.toString(), args.toString());
  });

  test('function-as-var', () {
    // #docregion function-as-var
    var loudify = (msg) => '!!! ${msg.toUpperCase()} !!!';
    assert(loudify('hello') == '!!! HELLO !!!');
    // #enddocregion function-as-var
  });

  final indexedFruit = '''0: apples
1: bananas
2: oranges''';

  test('anonymous-function', () {
    // #docregion anonymous-function
    var list = ['apples', 'bananas', 'oranges'];
    list.forEach((item) {
      $print('${list.indexOf(item)}: $item');
    });
    // #enddocregion anonymous-function
    expect(printLog.toString(), indexedFruit);
  });

  test('anon-func', () {
    var list = ['apples', 'bananas', 'oranges'];
    // #docregion anon-func
    list.forEach(
        (item) => $print('${list.indexOf(item)}: $item'));
    // #enddocregion anon-func
    expect(printLog.toString(), indexedFruit);
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
    Function makeAdder(num addBy) {
      return (num i) => addBy + i;
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
