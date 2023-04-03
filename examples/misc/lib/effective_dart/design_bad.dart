// ignore_for_file: close_sinks, type_annotate_public_apis, unused_element, unused_local_variable, avoid_types_as_parameter_names
// ignore_for_file: type_init_formals, unused_field, always_declare_return_types, strict_raw_type, prefer_typing_uninitialized_variables
// ignore_for_file: use_function_type_syntax_for_parameters, prefer_generic_function_type_aliases, avoid_null_checks_in_equality_operators
// ignore_for_file: non_nullable_equals_parameter

import 'dart:async';

import 'package:examples_util/ellipsis.dart';

import 'design_good.dart';

class Key {}

class StatelessWidget {
  final Key? key;
  StatelessWidget({this.key});
}

void miscDeclAnalyzedButNotTested() {
  (errors, monsters, subscription) {
    // #docregion code-like-prose
    // Telling errors to empty itself, or asking if it is?
    if (errors.empty as bool) {/*-...-*/}

    // Toggle what? To what?
    subscription.toggle();

    // Filter the monsters with claws *out* or include *only* those?
    monsters.filter((monster) => monster.hasClaws);
    // #enddocregion code-like-prose

    Iterable theCollectionOfErrors = [];
    // #docregion code-like-prose-overdone
    if (theCollectionOfErrors.isEmpty) {/*-...-*/}

    monsters.producesANewSequenceWhereEach((monster) => monster.hasClaws);
    // #enddocregion code-like-prose-overdone
  };

  (Socket socket, Database database) {
    // #docregion positive
    if (!socket.isDisconnected && !database.isEmpty) {
      socket.write(database.read());
    }
    // #enddocregion positive
  };

  {
    // #docregion cascades
    var buffer = StringBuffer0() //!<br>
        .write('one')
        .write('two')
        .write('three');
    // #enddocregion cascades
  }

  {
    // #docregion type_annotate_public_apis
    install(id, destination) => ellipsis();
    // #enddocregion type_annotate_public_apis
  }

  {
    // #docregion func-expr-no-param-type
    var names = people.map((Person person) => person.name);
    // #enddocregion func-expr-no-param-type
  }

  {
    // #docregion omit-types-on-locals
    List<List<Ingredient>> possibleDesserts(Set<Ingredient> pantry) {
      List<List<Ingredient>> desserts = <List<Ingredient>>[];
      for (final List<Ingredient> recipe in cookbook) {
        if (pantry.containsAll(recipe)) {
          desserts.add(recipe);
        }
      }

      return desserts;
    }
    // #enddocregion omit-types-on-locals
  }

  {
    // #docregion annotate-return-types
    makeGreeting(String who) {
      return 'Hello, $who!';
    }
    // #enddocregion annotate-return-types
  }

  {
    // Hack. The `(count as num)` is replaced with `count` when the excerpt is
    // included to workaround no implicit casts in the examples.
    // #docregion annotate-parameters
    void sayRepeatedly(message, {count = 2}) {
      for (var i = 0; i < (count as num); i++) {
        print(message);
      }
    }
    // #enddocregion annotate-parameters
  }

  (AstNode node) {
    // #docregion uninitialized-local
    var parameters;
    if (node is Constructor) {
      parameters = node.signature;
    } else if (node is Method) {
      parameters = node.parameters;
    }
    // #enddocregion uninitialized-local
  };

  {
    // #docregion non-inferred-type-args
    var playerScores = {};
    final events = StreamController();
    // #enddocregion non-inferred-type-args
  }

  {
    // #docregion explicit
    var items = Future<List<int>>.value(<int>[1, 2, 3]);
    // #enddocregion explicit
  }

  {
    // #docregion incomplete-generic
    List numbers = [1, 2, 3];
    var completer = Completer<Map>();
    // #enddocregion incomplete-generic
  }

  {
    // #docregion prefer-dynamic
    mergeJson(original, changes) => ellipsis();
    // #enddocregion prefer-dynamic
  }

  // #docregion avoid-Function
  bool isValid(String value, Function test) => ellipsis();
  // #enddocregion avoid-Function

  // #docregion future-or
  FutureOr<int> triple(FutureOr<int> value) {
    if (value is int) return value * 3;
    return value.then((v) => v * 3);
  }
  // #enddocregion future-or

  (int start) {
    // #docregion avoid-mandatory-param
    var rest = string.substring(start, null);
    // #enddocregion avoid-mandatory-param
  };
}

class MyIterable<T> {
  // #docregion function-type-param
  Iterable<T> where(bool predicate(T element)) => ellipsis();
  // #enddocregion function-type-param
}

//----------------------------------------------------------------------------

// #docregion dont-type-init-formals
class Point1 {
  double x, y;
  Point1(double this.x, double this.y);
}

class MyWidget extends StatelessWidget {
  MyWidget({Key? super.key});
}
// #enddocregion dont-type-init-formals

//----------------------------------------------------------------------------

// #docregion inferred-type-args
class Downloader {
  final response = Completer();
}
// #enddocregion inferred-type-args

//----------------------------------------------------------------------------

// #docregion redundant
class Downloader1 {
  final Completer<String> response = Completer<String>();
}
// #enddocregion redundant

//----------------------------------------------------------------------------

// #docregion old-typedef
typedef int Comparison<T>(T a, T b);
// #enddocregion old-typedef

// #docregion typedef-param
typedef bool TestNumber(num);
// #enddocregion typedef-param

//----------------------------------------------------------------------------

class StringBuffer0 {
  StringBuffer0 write(dynamic _) => this;
}

//----------------------------------------------------------------------------
// ignore_for_file: one_member_abstracts

// #docregion one-member-abstract-class
abstract class Predicate<E> {
  bool test(E element);
}
// #enddocregion one-member-abstract-class

//----------------------------------------------------------------------------

// #docregion class-only-static
class DateUtils {
  static DateTime mostRecent(List<DateTime> dates) {
    return dates.reduce((a, b) => a.isAfter(b) ? a : b);
  }
}

class _Favorites {
  static const mammal = 'weasel';
}
// #enddocregion class-only-static

//----------------------------------------------------------------------------

// #docregion class-only-static-exception
class Color {
  static const red = '#f00';
  static const green = '#0f0';
  static const blue = '#00f';
  static const black = '#000';
  static const white = '#fff';
}
// #enddocregion class-only-static-exception

//----------------------------------------------------------------------------
// ignore_for_file: avoid_return_types_on_setters

class C<Foo> {
  // #docregion avoid_return_types_on_setters
  void set foo(Foo value) {/* ... */}
  // #enddocregion avoid_return_types_on_setters
}

//----------------------------------------------------------------------------
// ignore_for_file: annotate_overrides

// #docregion eq-dont-check-for-null
class Person1 {
  final String name;
  // #enddocregion eq-dont-check-for-null
  Person1(this.name);
  int get hashCode => ellipsis();
  // ignore_for_file: unnecessary_null_comparison
  // #docregion eq-dont-check-for-null

  bool operator ==(Object? other) =>
      other != null && other is Person && name == other.name;
}
// #enddocregion eq-dont-check-for-null
