import 'dart:async';

handleFirstMessage() { print("handled first"); }
handleSecondMessage() { print("handled second"); }
handleAllOtherMessages(x) { print("handling: $x"); }

main() {
  var stream = new Stream.fromIterable([499, 42, 3.14, 0]);
  var bstream = stream.asBroadcastStream();
  bstream.first.then((x) {
    handleFirstMessage();
    return bstream.first;
  }).then((x) {
    handleSecondMessage();
    bstream.listen(handleAllOtherMessages);
  });
}
