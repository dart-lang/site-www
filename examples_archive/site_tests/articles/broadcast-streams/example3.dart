import 'dart:async';

handleFirstMessage() { print("handled first"); }
handleSecondMessage() { print("handled second"); }
handleAllOtherMessages(x) { print("handling: $x"); }

main() {
  var stream = new Stream.fromIterable([499, 42, 3.14, 0]);
  StreamSubscription subscription = stream.listen(null);
  subscription.onData((x) {
    handleFirstMessage();
    subscription.onData((x) {
      handleSecondMessage();
      subscription.onData(handleAllOtherMessages);
    });
  });
}
