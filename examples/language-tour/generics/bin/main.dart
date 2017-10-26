//Why Use Generics?
abstract class ObjectCache {
  Object getByKey(String key);
  void setByKey(String key, Object value);
}

abstract class StringCache {
  String getByKey(String key);
  void setByKey(String key, String value);
}

abstract class Cache<T> {
  T getByKey(String key);
  void setByKey(String key, T value);
}

class View {}

void main() {
  whyUseGenerics();
  usingCollectionLiterals();
  usingConstructors();
  genericCollections();
}

void whyUseGenerics() {
  var names = new List<String>();
  names.addAll(['Seth', 'Kathy', 'Lars']);
  // ...
  /*names.add(42);*/ // Fails in checked mode (succeeds in production mode).
}

void usingCollectionLiterals() {
  var names = <String>['Seth', 'Kathy', 'Lars'];
  var pages = <String, String>{
    'index.html': 'Homepage',
    'robots.txt': 'Hints for web robots',
    'humans.txt': 'We are people, not machines'
  };
}

void usingConstructors() {
  var names = new List<String>();
  names.addAll(['Seth', 'Kathy', 'Lars']);
  var nameSet = new Set<String>.from(names);

  var views = new Map<int, View>();
}

void genericCollections() {
  var names = new List<String>();
  names.addAll(['Seth', 'Kathy', 'Lars']);
  print(names is List<String>); // true
}
