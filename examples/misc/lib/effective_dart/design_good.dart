// ignore_for_file: type_annotate_public_apis, unused_element, unused_local_variable, sort_constructors_first

import 'dart:async';
import 'dart:collection';
import 'dart:isolate';
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
    var copy = List.from(elements, growable: true);
    var regExp = RegExp(pattern, caseSensitive: false);
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
    var buffer = StringBuffer() //!<br>
      ..write('one')
      ..write('two')
      ..write('three');
    // #enddocregion cascades
  };

  // #docregion annotate-declaration
  bool isEmpty(String parameter) {
    bool result = parameter.isEmpty;
    return result;
  }
  // #enddocregion annotate-declaration

  {
    // #docregion annotate-invocation
    var lists = <num>[1, 2];
    lists.addAll(List<num>.filled(3, 4));
    lists.cast<int>();
    // #enddocregion annotate-invocation
  }

  {
    // #docregion annotate-type-arg
    List<int> ints = [1, 2];
    // #enddocregion annotate-type-arg
  }

  <PackageId>() {
    // #docregion type_annotate_public_apis
    Future<bool> install(PackageId id, String destination) => ellipsis();
    // #enddocregion type_annotate_public_apis

    // #docregion inferred
    const screenWidth = 640; // Inferred as int.
    // #enddocregion inferred
  };

  {
    // #docregion func-expr-no-param-type
    var names = people.map((person) => person.name);
    // #enddocregion func-expr-no-param-type
  }

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

  // #docregion inferred-wrong
  num highScore(List<num> scores) {
    num highest = 0;
    for (var score in scores) {
      if (score > highest) highest = score;
    }
    return highest;
  }
  // #enddocregion inferred-wrong

  {
    // #docregion redundant
    Set<String> things = Set();
    // #enddocregion redundant
  }

  {
    // #docregion explicit
    var things = Set<String>();
    // #enddocregion explicit
  }

  {
    // #docregion prefer-dynamic
    dynamic mergeJson(dynamic original, dynamic changes) => ellipsis();
    // #enddocregion prefer-dynamic
  }

  // #docregion avoid-Function
  bool isValid(String value, bool Function(String) test) => ellipsis();
  // #enddocregion avoid-Function

  // #docregion function-arity
  void handleError(void Function() operation, Function errorHandler) {
    try {
      operation();
    } catch (err, stack) {
      if (errorHandler is Function(Object)) {
        errorHandler(err);
      } else if (errorHandler is Function(Object, StackTrace)) {
        errorHandler(err, stack);
      } else {
        throw ArgumentError("errorHandler has wrong signature.");
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
      throw ArgumentError('Cannot convert $arg to a bool.');
    }
    // #enddocregion Object-vs-dynamic
  };

  // #docregion future-or
  Future<int> triple(FutureOr<int> value) async => (await value) * 3;
  // #enddocregion future-or

  // #docregion future-or-contra
  Stream<S> asyncMap<T, S>(
      Iterable<T> iterable, FutureOr<S> Function(T) callback) async* {
    for (var element in iterable) {
      yield await callback(element);
    }
  }
  // #enddocregion future-or-contra

  () {
    // #docregion avoid-positional-bool-param
    Task.oneShot();
    Task.repeating();
    ListBox(scroll: true, showScrollbars: true);
    Button(ButtonState.enabled);
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
  Iterable<T> where(bool Function(T) predicate) => ellipsis();
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
typedef Comparison<T> = int Function(T, T);
// #enddocregion new-typedef

// #docregion new-typedef-param-name
typedef Comparison2<T> = int Function(T a, T b);
// #enddocregion new-typedef-param-name

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
typedef Predicate<E> = bool Function(E element);
// #enddocregion one-member-abstract-class

//----------------------------------------------------------------------------

class C<Foo> {
  // #docregion avoid_return_types_on_setters
  set foo(Foo value) {/* ... */}
// #enddocregion avoid_return_types_on_setters
}

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
      {int days = 0,
      int hours = 0,
      int minutes = 0,
      int seconds = 0,
      int milliseconds = 0,
      int microseconds = 0});
  // #enddocregion omit-optional-positional
}

//----------------------------------------------------------------------------
// ignore_for_file: annotate_overrides

// #docregion eq-dont-check-for-null
class Person {
  final String name;
  // #enddocregion eq-dont-check-for-null
  Person(this.name);
  // #docregion eq-dont-check-for-null
  bool operator ==(other) => other is Person && name == other.name;

  int get hashCode => name.hashCode;
}
// #enddocregion eq-dont-check-for-null
