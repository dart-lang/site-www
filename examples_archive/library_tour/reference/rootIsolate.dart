//import 'dart:isolate';
//
//childIsolate() {
//  port.receive((msg, replyTo) {
//    print('doing some work');
//    if (replyTo != null) replyTo.send('shutdown');
//  });
//}
//
//main() {
//  var sender = spawnFunction(childIsolate);
//  var receiver = new ReceivePort();
//  receiver.receive((msg, _) {
//    if (msg == 'shutdown') {
//      print('shutting down');
//      receiver.close();
//    }
//  });
//  sender.send('do work please', receiver.toSendPort());
//}
