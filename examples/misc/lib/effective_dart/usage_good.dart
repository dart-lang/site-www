// ignore_for_file: type_annotate_public_apis, unused_element, unused_local_variable
import 'dart:async';
import 'dart:io';
import 'dart:math';

typedef Func0<T> = T Function();
typedef Func1<S, T> = S Function(T _);

Func0<Future> longRunningCalculation;
Func0 somethingRisky;
Func1 raiseAlarm, handle;
Func1<bool, dynamic> canHandle, verifyResult;

void miscDeclAnalyzedButNotTested() {
  {
    // #docregion adjacent-strings-literals
    raiseAlarm(
        'ERROR: Parts of the spaceship are on fire. Other '
        'parts are overrun by martians. Unclear which are which.');
    // #enddocregion adjacent-strings-literals
  }

  (String name, num year, num birth) {
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
    var points = [];
    var addresses = {};
    // #enddocregion collection-literals
  }

  {
    // #docregion generic-collection-literals
    var points = <Point>[];
    var addresses = <String, Address>{};
    // #enddocregion generic-collection-literals
  }

  (Iterable lunchBox, Iterable words) {
    // #docregion dont-use-length
    if (lunchBox.isEmpty) return 'so hungry...';
    if (words.isNotEmpty) return words.join(' ');
    // #enddocregion dont-use-length
  };

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
    // #docregion omit-types-on-locals
    Map<int, List<Person>> groupByZip(Iterable<Person> people) {
      var peopleByZip = <int, List<Person>>{};
      for (var person in people) {
        peopleByZip.putIfAbsent(person.zip, () => <Person>[]);
        peopleByZip[person.zip].add(person);
      }
      return peopleByZip;
    }
    // #enddocregion omit-types-on-locals
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
    Future afterTwoThings(Future first, Future second) {
      return Future.wait([first, second]);
    }
    // #enddocregion unnecessary-async
  }

  {
    // ignore_for_file: only_throw_errors
    // #docregion async
    Future usesAwait(Future later) async {
      print(await later);
    }

    Future asyncError() async {
      throw 'Error!';
    }

    Future asyncValue() async => 'value';
    // #enddocregion async
  }

  {
    // #docregion avoid-completer
    Future<bool> fileContainsBear(String path) {
      return new File(path).readAsString().then((contents) {
        return contents.contains('bear');
      });
    }
    // #enddocregion avoid-completer
  }

  {
    // #docregion avoid-completer-alt
    Future<bool> fileContainsBear(String path) async {
      var contents = await new File(path).readAsString();
      return contents.contains('bear');
    }
    // #enddocregion avoid-completer-alt
  }
}

//----------------------------------------------------------------------------

class Address {}

class Animal {
  String name;
  bool isAquatic;
}

class Person {
  int zip;
}

//----------------------------------------------------------------------------

class Player {
  bool get isActive => false;
}

class Team {
  Future<List<Player>> get roster => null;
  Future<Team> downloadTeam(String name) => null;
  dynamic get log => null;

  // #docregion async-await
  Future<int> countActivePlayers(String teamName) async {
    try {
      var team = await downloadTeam(teamName);
      if (team == null) return 0;

      var players = await team.roster;
      return players.map((player) => player.isActive).length;
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
  num radius;

  Circle(this.radius);

  num get area => pi * radius * radius;
  num get circumference => pi * 2.0 * radius;
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

class Point {
  Point(this.x, this.y);
  int x;
  int y;
}

class Chest {
  List<String> get contents => null;
}

class Treasure {
  void addAll(List<String> what) {}
}

class C {
  double left, right, top, bottom, minTime;
  Point position;

  // #docregion use-arrow
  double get area => (right - left) * (bottom - top);

  bool isReady(num time) => minTime == null || minTime <= time;

  String capitalize(String name) =>
      "${name[0].toUpperCase()}${name.substring(1)}";
  // #enddocregion use-arrow

  // #docregion arrow-setter
  int get x => center.x;
  void set x(int value) => center = new Point(value, center.y);
  // #enddocregion arrow-setter

  // #docregion arrow-long
  Treasure openChest(Chest chest, Point where) {
    if (_opened.containsKey(chest)) return null;

    var treasure = new Treasure(where);
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
class Point {
  num x, y;
  Point(this.x, this.y);
}
// #enddocregion field-init-as-param

//----------------------------------------------------------------------------

// #docregion dont-type-init-formals
class Point1 {
  int x, y;
  Point1(this.x, this.y);
}
// #enddocregion dont-type-init-formals

//----------------------------------------------------------------------------

// #docregion semicolon-for-empty-body
class Point2 {
  int x, y;
  Point2(this.x, this.y);
}
// #enddocregion semicolon-for-empty-body

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
