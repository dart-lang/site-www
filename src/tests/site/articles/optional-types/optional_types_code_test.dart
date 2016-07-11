
class Point {
  final num x, y;
  Point(this.x, this.y);
  Point operator +(Point other) {
    return new Point(x+other.x, y+other.y);
  }
  String toString() {
    return "x: $x, y: $y";
  }
}

main() {
  var p1 = new Point(0, 0);
  var p2 = new Point(10, 10);

//  int n = p1 + p2;

//  print(n);
}

var pearTree;
class Partridge {}
class TurtleDove {}
class Drummer {}

a() {
Object lookup(String key) { /* ... */ } // a lookup method in a heterogenous table
String s = lookup('Frankenstein');  
}

b() {


Map<String, dynamic> m = {
    'one': new Partridge(),
    'two': new TurtleDove(),
    /* ..., */
    'twelve': new Drummer()};

pearTree = m['one'].container();    

new List();

new List<String>();

new List();

new List<dynamic>();

bool isTrue;

isTrue = new List<String>() is List<Object>;  // true: every string is an object
isTrue = new List<Object>() is List<String>;  // false: not all objects are strings

isTrue = new List<String>() is List<int>;     // false
isTrue = new List<String>() is List;          // true
isTrue = new List<String>() is List<dynamic>; // same as line above
isTrue = new List() is List<dynamic>;         // true, these are exactly the same

isTrue = new List() is List<String>;          // true as well!

String s = new Object();

<int>[0,1, 1][2] = new Object(); // fails in checked mode

//bar(3.2); // returns 6.4 in production, but fails in checked mode
}

c() {
  String s = foo();
}

Object foo() {
  return "x";
}

bar(int n) {
  return n *2;
}


my_add(s1, s2) {
  return s1 + s2;
}

f() {
my_add(3, 4); // 7
my_add(new Point(3, 3), new Point(4, 4)); // Point(7, 7)
}