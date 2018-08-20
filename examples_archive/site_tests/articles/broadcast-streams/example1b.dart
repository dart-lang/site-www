import 'dart:io';
import 'dart:async';

main() {
  ServerSocket.bind("localhost", 4999).then((socket) {
    socket
       .map((x) { print("new request"); return x; })
       .asBroadcastStream()  // <== asBroadcastStream.
       .map((x) { throw "oops, my mistake"; })
       .listen(print)
       .asFuture()  // Automatically cancels on error.
       .catchError((_) { print("caught error"); });
  });
  print("connect to http://localhost:4999 to trigger error");
}
