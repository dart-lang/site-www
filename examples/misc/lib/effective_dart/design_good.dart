// ignore_for_file: close_sinks, type_annotate_public_apis, unused_element
// ignore_for_file: unused_local_variable, strict_raw_type, use_function_type_syntax_for_parameters
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:collection';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:examples_util/ellipsis.dart';

typedef Func1<S, T> = S Function(T _);

dynamic element, key, value;
ByteBuffer bytes = Int8List(0).buffer;
DateTime dateTime = DateTime.now();
List list = [];
Map map = {};
String string = '';
StreamSubscription subscription = Stream.empty().listen((_) {});

class BuildContext {}

class Widget {}

class Text extends Widget {
  Text(String label);
}

class EdgeInsets {
  static double all(double value) => value;
}

class Padding extends Widget {
  Padding({required double padding, required Widget child});
}

class Key {}

class StatelessWidget {
  final Key? key;
  StatelessWidget({this.key});
}

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
    list.add('element');
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
    // #docregion non-inferred-type-args
    var playerScores = <String, int>{};
    final events = StreamController<Event>();
    // #enddocregion non-inferred-type-args
  }

  {
    // #docregion omit-types-on-locals
    List<List<Ingredient>> possibleDesserts(Set<Ingredient> pantry) {
      var desserts = <List<Ingredient>>[];
      for (final recipe in cookbook) {
        if (pantry.containsAll(recipe)) {
          desserts.add(recipe);
        }
      }

      return desserts;
    }
    // #enddocregion omit-types-on-locals
  }

  {
    var applyPadding = true;

    // #docregion upcast-local
    Widget build(BuildContext context) {
      Widget result = Text('You won!');
      if (applyPadding) {
        result = Padding(padding: EdgeInsets.all(8.0), child: result);
      }
      return result;
    }
    // #enddocregion upcast-local
  }

  {
    // #docregion annotate-return-types
    String makeGreeting(String who) {
      return 'Hello, $who!';
    }
    // #enddocregion annotate-return-types
  }

  {
    // #docregion annotate-parameters
    void sayRepeatedly(String message, {int count = 2}) {
      for (var i = 0; i < count; i++) {
        print(message);
      }
    }
    // #enddocregion annotate-parameters
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
    for (final score in scores) {
      if (score > highest) highest = score;
    }
    return highest;
  }
  // #enddocregion inferred-wrong

  {
    // #docregion explicit
    var items = Future.value([1, 2, 3]);
    // #enddocregion explicit
  }

  {
    // #docregion incomplete-generic
    List<num> numbers = [1, 2, 3];
    var completer = Completer<Map<String, int>>();
    // #enddocregion incomplete-generic
  }

  {
    // #docregion prefer-dynamic
    dynamic mergeJson(dynamic original, dynamic changes) => ellipsis();
    // #enddocregion prefer-dynamic
  }

  {
    // #docregion infer-dynamic
    Map<String, dynamic> readJson() => ellipsis();

    void printUsers() {
      var json = readJson();
      var users = json['users'];
      print(users);
    }
    // #enddocregion infer-dynamic
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
        throw ArgumentError('errorHandler has wrong signature.');
      }
    }
  }
  // #enddocregion function-arity

  () {
    // #docregion Object-vs-dynamic
    /// Returns a Boolean representation for [arg], which must
    /// be a String or bool.
    bool convertToBool(Object arg) {
      if (arg is bool) return arg;
      if (arg is String) return arg.toLowerCase() == 'true';
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
    for (final element in iterable) {
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

//----------------------------------------------------------------------------

// #docregion dont-type-init-formals
class Point1 {
  double x, y;
  Point1(this.x, this.y);
}

class MyWidget extends StatelessWidget {
  MyWidget({super.key});
}
// #enddocregion dont-type-init-formals

//----------------------------------------------------------------------------

// #docregion inferred-type-args
class Downloader {
  final Completer<String> response = Completer();
}
// #enddocregion inferred-type-args

//----------------------------------------------------------------------------

// #docregion redundant
class Downloader1 {
  final Completer<String> response = Completer();
}
// #enddocregion redundant

//----------------------------------------------------------------------------

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

  void Function(Event)? notify(Event event) {
    if (!_predicate(event)) return null;

    void Function(Event)? last;
    for (final observer in _observers) {
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
  List<AstNode> get signature => [];
}

class Method extends AstNode {
  List<AstNode> get parameters => [];
}

class Socket {
  bool get isConnected => false;
  bool get isDisconnected => false;
  void write(String data) {}
}

class Database {
  bool get hasData => false;
  bool get isEmpty => false;
  String read() => '';
}

class Monster {
  bool hasClaws = false;
}

List<Person> people = [];

class ListBox {
  ListBox({required bool scroll, required bool showScrollbars});
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

final List<List<Ingredient>> cookbook = [];

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

class Control {}

// #docregion mixin
mixin ClickableMixin implements Control {
  bool _isDown = false;

  void click();

  void mouseDown() {
    _isDown = true;
  }

  void mouseUp() {
    if (_isDown) click();
    _isDown = false;
  }
}
// #enddocregion mixin

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
  String0.fromCharCodes(Iterable<int> charCodes, [int start = 0, int? end]);

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
  int get hashCode => name.hashCode;
  Person(this.name);
  // #docregion eq-dont-check-for-null

  bool operator ==(Object other) => other is Person && name == other.name;
}
// #enddocregion eq-dont-check-for-null
