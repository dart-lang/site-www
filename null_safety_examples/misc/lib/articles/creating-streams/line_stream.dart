// ignore_for_file: use_function_type_syntax_for_parameters
import 'dart:async';

/// Combines incoming strings into a single stream and outputs its lines.
class LineStream extends Stream<String> {
  /// Input stream.
  final Stream<String> _source;

  /// Subscription on [_source] while subscribed.
  StreamSubscription<String>? _subscription;

  /// Controller for output stream.
  late final StreamController<String> _controller;

  /// Count of lines sent out so far.
  int _lineCount = 0;

  /// The part of a string seen so far that didn't end with a newline.
  String _remainder = '';

  /// Creates a stream of lines from a stream of string parts.
  LineStream(Stream<String> source) : _source = source {
    _controller = StreamController<String>(
        onListen: _onListen,
        onPause: _onPause,
        onResume: _onResume,
        onCancel: _onCancel);
  }

  /// The number of lines that have been output by this stream.
  int get lineCount => _lineCount;

  @override
  StreamSubscription<String> listen(void onData(String line)?,
      {Function? onError, void onDone()?, bool? cancelOnError}) {
    return _controller.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  void _onListen() {
    _subscription =
        _source.listen(_onData, onError: _controller.addError, onDone: _onDone);
  }

  void _onCancel() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _onPause() {
    _subscription?.pause();
  }

  void _onResume() {
    _subscription?.resume();
  }

  void _onData(String input) {
    // Split the input, combine it with a leftover line prefix from
    // the last input, and put all the complete lines into the pending queue.
    var splits = input.split('\n');
    splits[0] = _remainder + splits[0];
    _remainder = splits.removeLast();
    // While adding each individual line the stream could become paused. If
    // there are still lines remaining they need to be buffered. Instead of
    // buffering ourselves we just send the lines to the controller and let it
    // buffer them for us.
    _lineCount += splits.length;
    splits.forEach(_controller.add);
  }

  void _onDone() {
    if (_remainder.isNotEmpty) _controller.add(_remainder);
    _controller.close();
  }
}

void main() {
  const part1 = '''
Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium
doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore
veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim
ipsam voluptatem quia voluptas sit ''';
  const part2 = '''
aspernatur aut odit aut fugit, sed quia
consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.
Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur,
adipisci velit, sed quia non numquam eius modi tempora ''';
  const part3 = '''
incidunt ut labore et
dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis
nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid
ex ea commodi consequatur?
''';

  var text = StreamController<String>();
  var lines = LineStream(text.stream);
  int lineCount = 0;
  // StreamSubscription<String> sub;
  /* sub = */ lines.listen((String line) {
    lineCount++;
    print('$lineCount: $line');
  }, onDone: () {
    print('Lines received: $lineCount, lines sent: ${lines.lineCount}');
  });
  text.add(part1);
  text.add(part2);
  text.add(part3);
  text.close();
}
