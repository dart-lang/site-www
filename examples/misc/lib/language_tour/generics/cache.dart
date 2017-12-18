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
