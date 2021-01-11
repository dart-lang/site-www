/// A simple logger
class Logger {
  final List<String> _log = [];

  List<String> get log => List.from(_log);
  void clear() => _log.clear();
  void print(Object o) => _log.add(o.toString());

  @override
  String toString() => _log.join('\n');
}
