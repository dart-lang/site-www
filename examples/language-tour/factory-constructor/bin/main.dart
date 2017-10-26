// BEGIN(factory_constructor)
class Logger {
  final String name;
  bool mute = false;

  // _cache is library-private, thanks to the _ in front
  // of its name.
  static final Map<String, Logger> _cache = <String, Logger>{};

  factory Logger(String name) {
    if (_cache.containsKey(name)) {
      return _cache[name];
    } else {
      final logger = new Logger._internal(name);
      _cache[name] = logger;
      return logger;
    }
  }

  Logger._internal(this.name);

  void log(String msg) {
    if (!mute) {
      print(msg);
    }
  }
}
// END(factory_constructor)

void main() {
  //BEGIN
  var logger = new Logger('UI');
  logger.log('Button clicked');
  //END

  var l1 = new Logger('log1');
  var l2 = new Logger('log1');
  var l3 = new Logger('log2');

  assert(identical(l1, l2));
  assert(l1 != l3);

  l1.log('${l1.name}: This is l1.');
  l2.log('${l2.name}: This is l1_2.');
  l3.log('${l3.name}: This is l2.');
}
