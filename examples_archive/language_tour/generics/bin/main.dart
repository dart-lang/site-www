// ignore_for_file: unused_local_variable
// #docregion ObjectCache
abstract class ObjectCache {
  Object getByKey(String key);
  void setByKey(String key, Object value);
}
// #enddocregion ObjectCache

// #docregion StringCache
abstract class StringCache {
  String getByKey(String key);
  void setByKey(String key, String value);
}
// #enddocregion StringCache

// #docregion Cache
abstract class Cache<T> {
  T getByKey(String key);
  void setByKey(String key, T value);
}
// #enddocregion Cache

class View {}

void main() {
  whyUseGenerics();
  usingCollectionLiterals();
  usingConstructors();
  genericCollections();
}

void whyUseGenerics() {
  // #docregion why
  var names = new List<String>();
  names.addAll(['Seth', 'Kathy', 'Lars']);
  // #enddocregion why
  /*
  // #docregion why
  names.add(42); // Fails in checked mode (succeeds in production mode).
  // #enddocregion why
  */
}

void usingCollectionLiterals() {
  // #docregion collection-literals
  var names = <String>['Seth', 'Kathy', 'Lars'];
  var pages = <String, String>{
    'index.html': 'Homepage',
    'robots.txt': 'Hints for web robots',
    'humans.txt': 'We are people, not machines'
  };
  // #enddocregion collection-literals
}

void usingConstructors() {
  // #docregion constructor-1
  var names = new List<String>();
  names.addAll(['Seth', 'Kathy', 'Lars']);
  var nameSet = new Set<String>.from(names);
  // #enddocregion constructor-1

  // #docregion constructor-2
  var views = new Map<int, View>();
  // #enddocregion constructor-2
}

void genericCollections() {
  // #docregion generic-collections
  var names = new List<String>();
  names.addAll(['Seth', 'Kathy', 'Lars']);
  print(names is List<String>); // true
  // #enddocregion generic-collections
}

// #docregion method
T first<T>(List<T> ts) {
  // ...Do some initial work or error checking, then...
  T tmp = ts[0];
  // ...Do some additional checking or processing...
  return tmp;
}
