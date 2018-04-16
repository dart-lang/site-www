// ignore_for_file: type_annotate_public_apis, unused_element, unused_local_variable
// #docplaster

import 'dart:async';
import 'dart:collection';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:dartlang_examples_util/ellipsis.dart';

typedef Func1<S, T> = S Function(T _);

dynamic element, key, value;
ByteBuffer bytes;
DateTime dateTime;
List list;
Map map;
String string;
StreamSubscription subscription;

void miscDeclAnalyzedButNotTested() {
  (Iterable errors, Iterable<Monster> monsters) {
    // #docregion code-like-prose
    // "If errors is empty..."
    if (errors.isEmpty) {/*-...-*/}

    // "Hey, subscription, cancel!"
    subscription.cancel();

    // "Get the monsters where the monster has claws."
    monsters.where((monster) => monster.hasClaws);
    // #enddocregion code-like-prose
  };

  (Func1 entryPoint, message, Iterable elements, String pattern) {
    // #docregion omit-verb-for-bool-param
    Isolate.spawn(entryPoint, message, paused: false);
    var copy = new List.from(elements, growable: true);
    var regExp = new RegExp(pattern, caseSensitive: false);
    // #enddocregion omit-verb-for-bool-param
  };

  (Queue queue, window, connection) {
    // #docregion verb-for-func-with-side-effect
    list.add("element");
    queue.removeFirst();
    window.refresh();
    // #enddocregion verb-for-func-with-side-effect
  };

  (bool Function(dynamic) test) {
    // #docregion noun-for-func-returning-value
    var element = list.elementAt(3);
    var first = list.firstWhere(test);
    var char = string.codeUnitAt(4);
    // #enddocregion noun-for-func-returning-value
  };

  (database, packageGraph) {
    // #docregion verb-for-func-with-work
    var table = database.downloadData();
    var packageVersions = packageGraph.solveConstraints();
    // #enddocregion verb-for-func-with-work
  };

  (stackTrace) {
    // #docregion to___
    list.toSet();
    stackTrace.toString();
    dateTime.toLocal();
    // #enddocregion to___
  };

  () {
    dynamic table;
    // #docregion as___
    var map = table.asMap();
    var list = bytes.asFloat32List();
    var future = subscription.asFuture();
    // #enddocregion as___
  };

  () {
    // #docregion avoid-desc-param-in-func
    list.add(element);
    map.remove(key);
    // #enddocregion avoid-desc-param-in-func
  };

  () {
    // #docregion desc-param-in-func-ok
    map.containsKey(key);
    map.containsValue(value);
    // #enddocregion desc-param-in-func-ok
  };

  () {
    // #docregion class-only-static
    DateTime mostRecent(List<DateTime> dates) {
      return dates.reduce((a, b) => a.isAfter(b) ? a : b);
    }

    const _favoriteMammal = 'weasel';
    // #enddocregion class-only-static
  };

  (Socket socket, Database database) {
    // #docregion positive
    if (socket.isConnected && database.hasData) {
      socket.write(database.read());
    }
    // #enddocregion positive
  };

  () {
    // #docregion cascades
    var buffer = new StringBuffer() //!<br>
      ..write('one')
      ..write('two')
      ..write('three');
    // #enddocregion cascades
  };

  <PackageId>() {
    // #docregion type_annotate_public_apis
    Future<bool> install(PackageId id, String destination) => ellipsis();
    // #enddocregion type_annotate_public_apis

    // #docregion inferred
    const screenWidth = 640; // Inferred as int.
    // #enddocregion inferred
  };

  () {
    // #docregion func-expr-no-param-type
    var names = people.map((person) => person.name);
    // #enddocregion func-expr-no-param-type
  };

  {
    // #docregion omit-types-on-locals
    List<List<Ingredient>> possibleDesserts(Set<Ingredient> pantry) {
      var desserts = <List<Ingredient>>[];
      for (var recipe in cookbook) {
        if (pantry.containsAll(recipe)) {
          desserts.add(recipe);
        }
      }

      return desserts;
    }
    // #enddocregion omit-types-on-locals
  }

  (AstNode node) {
    // #docregion uninitialized-local
    List<AstNode> parameters;
    if (node is Constructor) {
      parameters = node.signature;
    } else if (node is Method) {
      parameters = node.parameters;
    }
    // #enddocregion uninitialized-local
  };

  () {
    // #docregion prefer-dynamic
    dynamic mergeJson(dynamic original, dynamic changes) => ellipsis();
    // #enddocregion prefer-dynamic
  };

  // #docregion avoid-Function
  bool isValid(String value, bool Function(String string) test) => ellipsis();
  // #enddocregion avoid-Function

  // #docregion function-arity
  void handleError(void Function() operation, Function errorHandler) {
    try {
      operation();
    } catch (err, stack) {
      if (errorHandler is Function(Object)) {
        errorHandler(err);
      } else if (errorHandler is Function(Object, Object)) {
        errorHandler(err, stack);
      }
    }
  }
  // #enddocregion function-arity

  () {
    // #docregion Object-vs-dynamic
    void log(Object object) {
      print(object.toString());
    }

    /// Returns a Boolean representation for [arg], which must
    /// be a String or bool.
    bool convertToBool(dynamic arg) {
      if (arg is bool) return arg;
      if (arg is String) return arg == 'true';
      throw new ArgumentError('Cannot convert $arg to a bool.');
    }
    // #enddocregion Object-vs-dynamic
  };

  () {
    // #docregion avoid-positional-bool-param
    new Task.oneShot();
    new Task.repeating();
    new ListBox(scroll: true, showScrollbars: true);
    new Button(ButtonState.enabled);
    // #enddocregion avoid-positional-bool-param
  };

  (int start) {
    // #docregion avoid-mandatory-param
    var rest = string.substring(start);
    // #enddocregion avoid-mandatory-param
  };
}

class MyIterable<T> {
  // #docregion function-type-param
  Iterable<T> where(bool Function(T element) predicate) => ellipsis();
  // #enddocregion function-type-param
}

class Event {}

// #docregion function-type
class FilteredObservable {
  final bool Function(Event) _predicate;
  final List<void Function(Event)> _observers;

  FilteredObservable(this._predicate, this._observers);

  void Function(Event) notify(Event event) {
    if (!_predicate(event)) return null;

    void Function(Event) last;
    for (var observer in _observers) {
      observer(event);
      last = observer;
    }

    return last;
  }
}
// #enddocregion function-type

//----------------------------------------------------------------------------

// #docregion new-typedef
typedef Comparison = int Function<T>(T, T);
// #enddocregion new-typedef

//----------------------------------------------------------------------------
// Supporting declarations

class AstNode {}

class Constructor extends AstNode {
  List<AstNode> get signature => null;
}

class Method extends AstNode {
  List<AstNode> get parameters => null;
}

class Socket {
  bool get isConnected => false;
  bool get isDisconnected => false;
  void write(String data) {}
}

class Database {
  bool get hasData => false;
  bool get isEmpty => false;
  String read() => null;
}

class Monster {
  bool hasClaws;
}

List<Person> people;

class ListBox {
  ListBox({bool scroll, bool showScrollbars});
}

class Button {
  Button(ButtonState _);
}

enum ButtonState { enabled }

class Task {
  Task.oneShot();
  Task.repeating();
}

class Ingredient {}

final List<List<Ingredient>> cookbook = null;

//----------------------------------------------------------------------------

// #docregion type-parameter-e
class IterableBase1<E> {}

class List1<E> {}

class HashSet1<E> {}

class RedBlackTree<E> {}
// #enddocregion type-parameter-e

// #docregion type-parameter-k-v
class Map1<K, V> {}

class Multimap<K, V> {}

class MapEntry1<K, V> {}
// #enddocregion type-parameter-k-v

class BinaryExpression {}

class LiteralExpression {}

class UnaryExpression {}

// #docregion type-parameter-r
abstract class ExpressionVisitor<R> {
  R visitBinary(BinaryExpression node);
  R visitLiteral(LiteralExpression node);
  R visitUnary(UnaryExpression node);
}
// #enddocregion type-parameter-r

// #docregion type-parameter-t
class Future1<T> {
  Future<S> then<S>(FutureOr<S> onValue(T value)) => ellipsis();
}
// #enddocregion type-parameter-t

// #docregion type-parameter-graph
class Graph<N, E> {
  final List<N> nodes = [];
  final List<E> edges = [];
}

class Graph1<Node, Edge> {
  final List<Node> nodes = [];
  final List<Edge> edges = [];
}
// #enddocregion type-parameter-graph

//----------------------------------------------------------------------------

// #docregion one-member-abstract-class
typedef Predicate = bool Function<E>(E element);
// #enddocregion one-member-abstract-class

//----------------------------------------------------------------------------

// #docregion named-ctr
class Point {
  num x, y;
  Point(this.x, this.y);
  Point.polar(num theta, num radius)
      : x = radius * cos(theta),
        y = radius * sin(theta);
}
// #enddocregion named-ctr

//----------------------------------------------------------------------------

class C<Foo> {
  // #docregion avoid_return_types_on_setters
  set foo(Foo value) {/* ... */}
// #enddocregion avoid_return_types_on_setters
}

//----------------------------------------------------------------------------

class Expression {}

class SourceVisitor {}

// #docregion type-private
class CallChainVisitor {
  final SourceVisitor _visitor;
  final Expression _target;
  // #enddocregion type-private

  CallChainVisitor(this._target, this._visitor);

  SourceVisitor get visitor => _visitor; // to avoid unused_field hint
  Expression get target => _target; // to avoid unused_field hint
  // #docregion type-private
  // ···
  void _writeCall(Expression call) {/* ... */}
}
// #enddocregion type-private

//----------------------------------------------------------------------------

class String0 {
  // #docregion omit-optional-positional
  String0.fromCharCodes(Iterable<int> charCodes, [int start = 0, int end]);

  // #enddocregion omit-optional-positional
}

class DateTime0 {
  // #docregion omit-optional-positional
  DateTime0(int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0]);

  // #enddocregion omit-optional-positional
}

class Duration0 {
  // #docregion omit-optional-positional
  Duration0(
      {int days: 0,
      int hours: 0,
      int minutes: 0,
      int seconds: 0,
      int milliseconds: 0,
      int microseconds: 0});
  // #enddocregion omit-optional-positional
}

//----------------------------------------------------------------------------
// ignore_for_file: annotate_overrides

// #docregion eq-dont-check-for-null
class Person {
  final String name;
  // ...
  // #enddocregion eq-dont-check-for-null
  Person(this.name);
  // #docregion eq-dont-check-for-null
  operator ==(other) => other is Person && name == other.name;

  int get hashCode => name.hashCode;
}
// #enddocregion eq-dont-check-for-null
