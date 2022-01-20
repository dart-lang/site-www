// #docregion
class Logger {
  final String name;
  bool mute = false;

  // _cache is library-private, thanks to
  // the _ in front of its name.
  static final Map<String, Logger> _cache = <String, Logger>{};

  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }

  factory Logger.fromJson(Map<String, Object> json) {
    return Logger(json['name'].toString());
  }

  Logger._internal(this.name);

  void log(String msg) {
    if (!mute) print(msg);
  }
}
// #enddocregion

void main() {
  // #docregion logger
  var logger = Logger('UI');
  logger.log('Button clicked');

  var logMap = {'name': 'UI'};
  var loggerJson = Logger.fromJson(logMap);
  // #enddocregion logger

  var l1 = Logger('log1');
  var l2 = Logger('log1');
  var l3 = Logger('log2');

  assert(identical(l1, l2));
  assert(l1 != l3);

  l1.log('${l1.name}: This is l1.');
  l2.log('${l2.name}: This is l1_2.');
  l3.log('${l3.name}: This is l2.');
  logger.log('${logger.name}: This is logger.');
  loggerJson.log('${loggerJson.name}: This is loggerJson.');
}
