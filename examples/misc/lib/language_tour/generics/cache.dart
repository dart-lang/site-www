// #docregion object-cache
abstract class ObjectCache {
  Object getByKey(String key);
  void setByKey(String key, Object value);
}
// #enddocregion object-cache

// #docregion string-cache
abstract class StringCache {
  String getByKey(String key);
  void setByKey(String key, String value);
}
// #enddocregion string-cache

// #docregion cache
abstract class Cache<T> {
  T getByKey(String key);
  void setByKey(String key, T value);
}
// #enddocregion cache
