// ignore_for_file: type_annotate_public_apis, unused_element, unused_local_variable, sort_constructors_first
import 'dart:async';
import 'dart:io';
import 'dart:math';

typedef Func0<T> = T Function();
typedef Func1<S, T> = S Function(T _);

Func0<Future> longRunningCalculation = () => Future.value();
Func0 somethingRisky = () {};
Func1 raiseAlarm = (_) {}, handle = (_) {};
Func1<bool, dynamic> canHandle = (_) => false,
    verifyResult = (_) => false;

void miscDeclAnalyzedButNotTested() {
  {
    dynamic optionalThing;
    // #docregion convert-null-aware
    // If you want null to be false:
    optionalThing?.isEnabled ?? false;

    // If you want null to be true:
    optionalThing?.isEnabled ?? true;
    // #enddocregion convert-null-aware
  }

  {
    // #docregion adjacent-strings-literals
    raiseAlarm(
        'ERROR: Parts of the spaceship are on fire. Other '
        'parts are overrun by martians. Unclear which are which.');
    // #enddocregion adjacent-strings-literals
  }

  (String name, int year, int birth) {
    // #docregion string-interpolation
    'Hello, $name! You are ${year - birth} years old.';
    // #enddocregion string-interpolation
  };

  (name, decade) {
    return
        // #docregion string-interpolation-avoid-curly
        'Hi, $name!'
            "Wear your wildest $decade's outfit."
            'Wear your wildest ${decade}s outfit.'
        // #enddocregion string-interpolation-avoid-curly
        ;
  };

  {
    // #docregion collection-literals
    var points = <Point>[];
    var addresses = <String, Address>{};
    var counts = <int>{};
    // #enddocregion collection-literals
  }

  (Iterable lunchBox, Iterable words) {
    // #docregion dont-use-length
    if (lunchBox.isEmpty) return 'so hungry...';
    if (words.isNotEmpty) return words.join(' ');
    // #enddocregion dont-use-length
    return 'foo';
  };

  {
    // #docregion cast-list
    var stuff = <dynamic>[1, 2];
    var ints = List<int>.from(stuff);
    // #enddocregion cast-list
  }

  {
    // #docregion cast-map
    var stuff = <dynamic>[1, 2];
    var reciprocals = stuff.map<double>((n) => 1 / (n as int));
    // #enddocregion cast-map
  }

  // #docregion cast-at-create
  List<int> singletonList(int value) {
    var list = <int>[];
    list.add(value);
    return list;
  }
  // #enddocregion cast-at-create

  // #docregion cast-iterate
  void printEvens(List<Object> objects) {
    // We happen to know the list only contains ints.
    for (var n in objects) {
      if ((n as int).isEven) print(n);
    }
  }
  // #enddocregion cast-iterate

  // #docregion cast-from
  int median(List<Object> objects) {
    // We happen to know the list only contains ints.
    var ints = List<int>.from(objects);
    ints.sort();
    return ints[ints.length ~/ 2];
  }
  // #enddocregion cast-from

  (Iterable<Animal> animals) {
    // #docregion use-higher-order-func
    var aquaticNames = animals
        .where((animal) => animal.isAquatic)
        .map((animal) => animal.name);
    // #enddocregion use-higher-order-func
  };

  (Iterable people) {
    // #docregion avoid-forEach
    for (var person in people) {
      /*...*/
    }
    // #enddocregion avoid-forEach
    // #docregion forEach-over-func
    people.forEach(print);
    // #enddocregion forEach-over-func
  };

  {
    // #docregion func-decl
    void main() {
      localFunction() {
        /*...*/
      }
    }
    // #enddocregion func-decl
  }

  (Iterable names) {
    // #docregion use-tear-off
    names.forEach(print);
    // #enddocregion use-tear-off
  };

  {
    // #docregion default-separator
    void insert(Object item, {int at = 0}) {/* ... */}
    // #enddocregion default-separator
  }

  {
    // #docregion default-value-null
    void error([String message]) {
      stderr.write(message ?? '\n');
    }
    // #enddocregion default-value-null
  }

  {
    // #docregion rethrow
    try {
      somethingRisky();
    } catch (e) {
      if (!canHandle(e)) rethrow;
      handle(e);
    }
    // #enddocregion rethrow
  }

  {
    // #docregion unnecessary-async
    Future<void> afterTwoThings(
        Future<void> first, Future<void> second) {
      return Future.wait([first, second]);
    }
    // #enddocregion unnecessary-async
  }

  {
    // ignore_for_file: only_throw_errors
    // #docregion async
    Future<void> usesAwait(Future<String> later) async {
      print(await later);
    }

    Future<void> asyncError() async {
      throw 'Error!';
    }

    Future<void> asyncValue() async => 'value';
    // #enddocregion async
  }

  {
    // #docregion avoid-completer
    Future<bool> fileContainsBear(String path) {
      return File(path).readAsString().then((contents) {
        return contents.contains('bear');
      });
    }
    // #enddocregion avoid-completer
  }

  // #docregion test-future-or
  Future<T> logValue<T>(FutureOr<T> value) async {
    if (value is Future<T>) {
      var result = await value;
      print(result);
      return result;
    } else {
      print(value);
      return value as T;
    }
  }
  // #enddocregion test-future-or

  {
    // #docregion avoid-completer-alt
    Future<bool> fileContainsBear(String path) async {
      var contents = await File(path).readAsString();
      return contents.contains('bear');
    }
    // #enddocregion avoid-completer-alt
  }

  {
    // #docregion no-const
    const primaryColors = [
      Color("red", [255, 0, 0]),
      Color("green", [0, 255, 0]),
      Color("blue", [0, 0, 255]),
    ];
    // #enddocregion no-const
  }
}

//----------------------------------------------------------------------------

class Address {}

class Animal {
  String name = '';
  bool isAquatic = false;
}

class Person {
  int zip = 12345;
}

class Color {
  const Color(String name, List<int> channels);
}

//----------------------------------------------------------------------------

class Player {
  bool get isActive => false;
}

class Team {
  Future<List<Player>> get roster => Future.value([]);
  Future<Team> downloadTeam(String name) => Future.value(Team());
  dynamic get log => null;

  // #docregion async-await
  Future<int> countActivePlayers(String teamName) async {
    try {
      var team = await downloadTeam(teamName);
      if (team == null) return 0;

      var players = await team.roster;
      return players.where((player) => player.isActive).length;
    } catch (e) {
      log.error(e);
      return 0;
    }
  }
  // #enddocregion async-await
}

//----------------------------------------------------------------------------

// #docregion no-null-init
int _nextId;

class LazyId {
  int _id;

  int get id {
    if (_nextId == null) _nextId = 0;
    if (_id == null) _id = _nextId++;

    return _id;
  }
}
// #enddocregion no-null-init

//----------------------------------------------------------------------------

// #docregion cacl-vs-store
class Circle {
  double radius;

  Circle(this.radius);

  double get area => pi * radius * radius;
  double get circumference => pi * 2.0 * radius;
}
// #enddocregion cacl-vs-store

//----------------------------------------------------------------------------

// #docregion dont-wrap-field
class Box {
  var contents;
}
// #enddocregion dont-wrap-field

//----------------------------------------------------------------------------

// #docregion final
class Box1 {
  final contents = [];
}
// #enddocregion final

//----------------------------------------------------------------------------

class Chest {
  List<String> get contents => [];
}

class Treasure {
  Treasure(Point where);

  void addAll(List<String> what) {}
}

class C {
  double left = 0.0,
      right = 0.0,
      top = 0.0,
      bottom = 0.0,
      minTime = 0.0;
  Point center = Point(0.0, 0.0);
  Map<Chest, Treasure> _opened = {};

  // #docregion use-arrow
  double get area => (right - left) * (bottom - top);

  bool isReady(double time) =>
      minTime == null || minTime <= time;

  String capitalize(String name) =>
      '${name[0].toUpperCase()}${name.substring(1)}';
  // #enddocregion use-arrow

  // #docregion arrow-setter
  num get x => center.x;
  set x(num value) => center = Point(value, center.y);
  // #enddocregion arrow-setter

  // #docregion arrow-long
  Treasure openChest(Chest chest, Point where) {
    if (_opened.containsKey(chest)) return null;

    var treasure = Treasure(where);
    treasure.addAll(chest.contents);
    _opened[chest] = treasure;
    return treasure;
  }
  // #enddocregion arrow-long
}

//----------------------------------------------------------------------------

// #docregion this-dot
class Box2 {
  var value;

  void clear() {
    update(null);
  }

  void update(value) {
    this.value = value;
  }
}
// #enddocregion this-dot

//----------------------------------------------------------------------------

// #docregion this-dot-constructor
class ShadeOfGray {
  final int brightness;

  ShadeOfGray(int val) : brightness = val;

  ShadeOfGray.black() : this(0);

  // But now it will!
  ShadeOfGray.alsoBlack() : this.black();
}
// #enddocregion this-dot-constructor

//----------------------------------------------------------------------------

class BaseBox {
  BaseBox(_);
}

// #docregion param-dont-shadow-field-ctr-init
class Box3 extends BaseBox {
  var value;

  Box3(value)
      : value = value,
        super(value);
}
// #enddocregion param-dont-shadow-field-ctr-init

//----------------------------------------------------------------------------

class Document {}

// #docregion field-init-at-decl
class Folder {
  final String name;
  final List<Document> contents = [];

  Folder(this.name);
  Folder.temp() : name = 'temporary';
}
// #enddocregion field-init-at-decl

//----------------------------------------------------------------------------

// #docregion field-init-as-param
class Point0 {
  double x, y;
  Point0(this.x, this.y);
}
// #enddocregion field-init-as-param

//----------------------------------------------------------------------------

// #docregion dont-type-init-formals
class Point1 {
  double x, y;
  Point1(this.x, this.y);
}
// #enddocregion dont-type-init-formals

//----------------------------------------------------------------------------

// #docregion semicolon-for-empty-body
class Point2 {
  double x, y;
  Point2(this.x, this.y);
}
// #enddocregion semicolon-for-empty-body

class Widget {}

class BuildContext {}

class Row extends Widget {
  Row({children});
}

class RaisedButton {
  RaisedButton({child});
}

class Text {
  Text(String text);
}

// #docregion no-new
Widget build(BuildContext context) {
  return Row(
    children: [
      RaisedButton(
        child: Text('Increment'),
      ),
      Text('Click!'),
    ],
  );
}
// #enddocregion no-new

//----------------------------------------------------------------------------

class Style {}

class ViewBase {
  ViewBase(_);
}

class View extends ViewBase {
  var _children;
  // #docregion super-first
  View(Style style, List children)
      : _children = children,
        super(style);
  // #enddocregion super-first
  get children => _children;
}
