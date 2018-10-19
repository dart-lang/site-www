// ignore_for_file: avoid_init_to_null, empty_constructor_bodies, final_not_initialized_constructor_1, prefer_is_not_empty, sort_constructors_first, type_annotate_public_apis, type_init_formals, unnecessary_brace_in_string_interps, unnecessary_getters_setters, unused_element, unused_local_variable, prefer_equal_for_default_values, use_rethrow_when_possible
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'usage_good.dart';

void miscDeclAnalyzedButNotTested() {
  {
    // #docregion adjacent-strings-literals
    raiseAlarm('ERROR: Parts of the spaceship are on fire. Other ' +
        'parts are overrun by martians. Unclear which are which.');
    // #enddocregion adjacent-strings-literals
  }

  (String name, num year, num birth) {
    // #docregion string-interpolation
    'Hello, ' + name + '! You are ' + (year - birth).toString() + ' y...';
    // #enddocregion string-interpolation
  };

  (name, decade) {
    return
        // #docregion string-interpolation-avoid-curly
        'Hi, ${name}!'
        "Wear your wildest ${decade}'s outfit."
        // #enddocregion string-interpolation-avoid-curly
        ;
  };

  {
    // #docregion collection-literals
    var points = List();
    var addresses = Map();
    // #enddocregion collection-literals
  }

  {
    // #docregion generic-collection-literals
    var points = List<Point>();
    var addresses = Map<String, Address>();
    // #enddocregion generic-collection-literals
  }

  (Iterable lunchBox, Iterable words) {
    // #docregion dont-use-length
    if (lunchBox.length == 0) return 'so hungry...';
    if (!words.isEmpty) return words.join(' ');
    // #enddocregion dont-use-length
  };

  (Iterable people) {
    // #docregion avoid-forEach
    people.forEach((person) {
      /*...*/
    });

    // #enddocregion avoid-forEach
  };

  {
    // #docregion where-type
    var objects = [1, "a", 2, "b", 3];
    var ints = objects.where((e) => e is int);
    // #enddocregion where-type
  }

  {
    // #docregion cast-list
    var stuff = <dynamic>[1, 2];
    var ints = stuff.toList().cast<int>();
    // #enddocregion cast-list
  }

  {
    // #docregion cast-map
    var stuff = <dynamic>[1, 2];
    var reciprocals = stuff.map((n) => 1 / (n as int)).cast<double>();
    // #enddocregion cast-map
  }

  // #docregion cast-at-create
  List<int> singletonList(int value) {
    var list = []; // List<dynamic>.
    list.add(value);
    return list.cast<int>();
  }
  // #enddocregion cast-at-create

  // #docregion cast-iterate
  void printEvens(List<Object> objects) {
    // We happen to know the list only contains ints.
    for (var n in objects.cast<int>()) {
      if (n.isEven) print(n);
    }
  }
  // #enddocregion cast-iterate

  // #docregion cast-from
  int median(List<Object> objects) {
    // We happen to know the list only contains ints.
    var ints = objects.cast<int>();
    ints.sort();
    return ints[ints.length ~/ 2];
  }
  // #enddocregion cast-from

  {
    // #docregion where-type-2
    var objects = [1, "a", 2, "b", 3];
    var ints = objects.where((e) => e is int).cast<int>();
    // #enddocregion where-type-2
  }

  {
    // #docregion func-decl
    void main() {
      var localFunction = () {
        /*...*/
      };
    }
    // #enddocregion func-decl
  }

  (Iterable names) {
    // #docregion use-tear-off
    names.forEach((name) {
      print(name);
    });
    // #enddocregion use-tear-off
  };

  {
    // #docregion default-separator
    void insert(Object item, {int at: 0}) {/* ... */}
    // #enddocregion default-separator
  }

  {
    // #docregion default-value-null
    void error([String message = null]) {
      stderr.write(message ?? '\n');
    }
    // #enddocregion default-value-null
  }

  {
    // #docregion rethrow
    try {
      somethingRisky();
    } catch (e) {
      if (!canHandle(e)) throw e;
      handle(e);
    }
    // #enddocregion rethrow
  }

  {
    // #docregion unnecessary-async
    Future afterTwoThings(Future first, Future second) async {
      return Future.wait([first, second]);
    }
    // #enddocregion unnecessary-async
  }

  {
    // #docregion avoid-completer
    Future<bool> fileContainsBear(String path) {
      var completer = Completer<bool>();

      File(path).readAsString().then((contents) {
        completer.complete(contents.contains('bear'));
      });

      return completer.future;
    }
    // #enddocregion avoid-completer
  }

  // #docregion test-future-or
  Future<T> logValue<T>(FutureOr<T> value) async {
    if (value is T) {
      print(value);
      return value;
    } else {
      var result = await value;
      print(result);
      return result;
    }
  }
  // #enddocregion test-future-or

  (Map<Chest, Treasure> _opened) {
    // #docregion arrow-long
    Treasure openChest(Chest chest, Point where) =>
        _opened.containsKey(chest) ? null : _opened[chest] = Treasure(where)
          ..addAll(chest.contents);
    // #enddocregion arrow-long
  };
}

//----------------------------------------------------------------------------

class BadTeam extends Team {
  @override
  dynamic get log => null;

  @override
  // #docregion async-await
  Future<int> countActivePlayers(String teamName) {
    return downloadTeam(teamName).then((team) {
      if (team == null) return Future.value(0);

      return team.roster.then((players) {
        return players.where((player) => player.isActive).length;
      });
    }).catchError((e) {
      log.error(e);
      return 0;
    });
  }
  // #enddocregion async-await
}

//----------------------------------------------------------------------------

// #docregion no-null-init
int _nextId = null;

class LazyId {
  int _id = null;

  int get id {
    if (_nextId == null) _nextId = 0;
    if (_id == null) _id = _nextId++;

    return _id;
  }
}
// #enddocregion no-null-init

//----------------------------------------------------------------------------

// #docregion cacl-vs-store1
class Circle1 {
  num radius;
  num area;
  num circumference;

  Circle1(num radius)
      : radius = radius,
        area = pi * radius * radius,
        circumference = pi * 2.0 * radius;
}
// #enddocregion cacl-vs-store1

//----------------------------------------------------------------------------

// #docregion cacl-vs-store2
class Circle2 {
  num _radius;
  num get radius => _radius;
  set radius(num value) {
    _radius = value;
    _recalculate();
  }

  num _area;
  num get area => _area;

  num _circumference;
  num get circumference => _circumference;

  Circle2(this._radius) {
    _recalculate();
  }

  void _recalculate() {
    _area = pi * _radius * _radius;
    _circumference = pi * 2.0 * _radius;
  }
}
// #enddocregion cacl-vs-store2

//----------------------------------------------------------------------------

// #docregion dont-wrap-field
class Box {
  var _contents;
  get contents => _contents;
  set contents(value) {
    _contents = value;
  }
}
// #enddocregion dont-wrap-field

//----------------------------------------------------------------------------

// #docregion final
class Box1 {
  var _contents;
  get contents => _contents;
}
// #enddocregion final

//----------------------------------------------------------------------------

// #docregion this-dot
class Box2 {
  var value;

  void clear() {
    this.update(null);
  }

  void update(value) {
    this.value = value;
  }
}
// #enddocregion this-dot

//----------------------------------------------------------------------------

// #docregion field-init-at-decl
class Folder {
  final String name;
  final List<Document> contents;

  Folder(this.name) : contents = [];
  Folder.temp() : name = 'temporary'; // Oops! Forgot contents.
}
// #enddocregion field-init-at-decl

//----------------------------------------------------------------------------

// #docregion field-init-as-param
class Point0 {
  num x, y;
  Point0(num x, num y) {
    this.x = x;
    this.y = y;
  }
}
// #enddocregion field-init-as-param

//----------------------------------------------------------------------------

// #docregion dont-type-init-formals
class Point1 {
  int x, y;
  Point1(int this.x, int this.y);
}
// #enddocregion dont-type-init-formals

//----------------------------------------------------------------------------

// #docregion semicolon-for-empty-body
class Point2 {
  int x, y;
  Point2(this.x, this.y) {}
}
// #enddocregion semicolon-for-empty-body

//----------------------------------------------------------------------------
// ignore_for_file: super_goes_last, strong_mode_invalid_super_invocation

class View extends ViewBase {
  var _children;
  get children => _children;
  // #docregion super-first
  View(Style style, List children)
      : super(style),
        _children = children;
  // #enddocregion super-first
}

//----------------------------------------------------------------------------
// ignore_for_file: unnecessary_const, unnecessary_new

void unnecessaryNewOrConst() {
  // #docregion no-new
  Widget build(BuildContext context) {
    return new Row(
      children: [
        new RaisedButton(
          child: new Text('Increment'),
        ),
        new Text('Click!'),
      ],
    );
  }
  // #enddocregion no-new

  {
    // #docregion no-const
    const primaryColors = const [
      const Color("red", const [255, 0, 0]),
      const Color("green", const [0, 255, 0]),
      const Color("blue", const [0, 0, 255]),
    ];
    // #enddocregion no-const
  }
}
