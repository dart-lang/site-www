import 'print.dart';

/// Logs print output. We're using it to log print method output.
///
/// This class is setup as a (simplified) singleton, with a static helper method
/// to initialize the global [$print] to [it].print.
class PrintLog {
  final List<String> _log = [];

  List<String> get log => new List.from(_log);

  void clear() => _log.clear();
  void print(Object o) => _log.add(o.toString());

  @override
  String toString() => _log.join('\n');

  static final PrintLog it = new PrintLog();

  /// (Re-)sets [$print] to `it.print`.
  static void set$print() {
    if ($print != it.print) {
      $print = it.print;
    }
  }
}
