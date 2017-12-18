// ignore_for_file: type_annotate_public_apis, unused_element, unused_local_variable

import 'dart:math';
import 'package:dartlang_examples_util/ellipsis.dart';
import 'design_good.dart';

void miscDeclAnalyzedButNotTested() {
  (errors, monsters, subscription) {
    // #docregion code-like-prose
    // Telling errors to empty itself, or asking if it is?
    if (errors.empty) {/*-...-*/}

    // Toggle what? To what?
    subscription.toggle();

    // Filter the monsters with claws *out* or include *only* those?
    monsters.filter((monster) => monster.hasClaws);
    // #enddocregion code-like-prose

    Iterable theCollectionOfErrors;
    // #docregion code-like-prose-overdone
    if (theCollectionOfErrors.isEmpty) {/*-...-*/}

    monsters.producesANewSequenceWhereEach((monster) => monster.hasClaws);
    // #enddocregion code-like-prose-overdone
  };

  () {
    // #docregion cascades
    var buffer = new StringBuffer0() //!
        .write('one')
        .write('two')
        .write('three');
    // #enddocregion cascades
  };

  () {
    // #docregion type_annotate_public_apis
    install(id, destination) => ellipsis;
    // #enddocregion type_annotate_public_apis
  };

  () {
    // #docregion func-expr-no-param-type
    var names = people.map((Person person) {
      return person.name;
    });
    // #enddocregion func-expr-no-param-type
  };

  () {
    // #docregion avoid-dynamic
    dynamic lookUpOrDefault(String name, Map map, dynamic defaultValue) {
      var value = map[name];
      if (value != null) return value;
      return defaultValue;
    }
    // #enddocregion avoid-dynamic
  };

  // #docregion avoid-Function
  bool isValidString(String value, Function predicate) => ellipsis;
  // #enddocregion avoid-Function

  (int start) =>
      // #docregion avoid-mandatory-param
      string.substring(start, null);
  // #enddocregion avoid-mandatory-param
}

//----------------------------------------------------------------------------

class StringBuffer0 {
  StringBuffer0 write(dynamic _) => null;
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

// #docregion named-ctr
class Point {
  num x, y;
  Point(this.x, this.y);
  static Point polar(num theta, num radius) =>
      new Point(radius * cos(theta), radius * sin(theta));
}
// #enddocregion named-ctr

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
  int get hashCode => ellipsis;
  // #docregion eq-dont-check-for-null
  operator ==(other) => other != null && ellipsis;
}
// #enddocregion eq-dont-check-for-null
