//import 'dart:isolate';
//
//echo() {
//  port.receive((msg, reply) {
//    print('I received: $msg');
//  });
//}
//
//main() {
//  var sendPort = spawnFunction(echo);
//  sendPort.send('Hello from main');
//
//  // Note: incomplete.
//  // Use a ReceivePort (details below) to keep the root isolate alive
//  // long enough for echo() to perform its work.
//}
