// ignore_for_file: annotate_overrides, type_annotate_public_apis, unused_element, unused_local_variable, sdk_version_extension_methods
import 'dart:io';
import 'dart:math';

void miscDeclAnalyzedButNotTested() {
  {
    // #docregion misc-names
    var count = 3;

    HttpRequest httpRequest;

    void align(bool clearItems) {
      // ...
    }
    // #enddocregion misc-names
  }

  <IOStream, Id, DBIOPort, TVVcr>(uiHandler) => [
        // #docregion acronyms-and-abbreviations
        HttpConnectionInfo,
        uiHandler,
        IOStream,
        HttpRequest,
        Id,
        DBIOPort,
        TVVcr
        // #enddocregion acronyms-and-abbreviations
      ];

  (bool isWeekDay) {
    // #docregion curly-braces
    if (isWeekDay) {
      print('Bike to work!');
    } else {
      print('Go dancing or read a book!');
    }
    // #enddocregion curly-braces
  };

  (arg, defaultValue) {
    // #docregion one-line-if
    if (arg == null) return defaultValue;
    // #enddocregion one-line-if
  };

  (dynamic overflowChars, dynamic other) {
    // #docregion one-line-if-wrap
    if (overflowChars != other.overflowChars) {
      return overflowChars < other.overflowChars;
    }
    // #enddocregion one-line-if-wrap
  };
}

//----------------------------------------------------------------------------

class SomeType {}

//----------------------------------------------------------------------------

// #docregion type-names
class SliderMenu {/* ... */}

class HttpRequest {/* ... */}

typedef Predicate<T> = bool Function(T value);
// #enddocregion type-names

//----------------------------------------------------------------------------

const anArg = null;

// #docregion annotation-type-names
class Foo {
  const Foo([Object? arg]);
}

@Foo(anArg)
class A {/* ... */}

@Foo()
class B {/* ... */}
// #enddocregion annotation-type-names

//----------------------------------------------------------------------------

// #docregion annotation-const
const foo = Foo();

@foo
class C {/* ... */}
// #enddocregion annotation-const

//----------------------------------------------------------------------------

// #docregion const-names
const pi = 3.14;
const defaultTimeout = 1000;
final urlScheme = RegExp('^([a-z]+):');

class Dice {
  static final numberGenerator = Random();
}
// #enddocregion const-names

//----------------------------------------------------------------------------

void unusedCallbackParams() {
  var futureOfVoid = Future<void>.value();
  // #docregion unused-callback-params
  futureOfVoid.then((_) {
    print('Operation complete.');
  });
  // #enddocregion unused-callback-params
}

//----------------------------------------------------------------------------

// #docregion extension-names
extension MyFancyList<T> on List<T> {/* ... */}

extension SmartIterable<T> on Iterable<T> {/* ... */}
// #enddocregion extension-names
