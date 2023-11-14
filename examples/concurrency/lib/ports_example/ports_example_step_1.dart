// ignore_for_file: unused_field, unused_element

// #docregion main
import 'dart:async';
import 'dart:isolate';

class BackgroundWorker {
  BackgroundWorker();

  late Isolate _isolate;

  // This method will create the worker isolate
  Future<void> _initIsolate() async {}

  // This method will handle messages that are sent from the worker isolate back to the main isolate
  void _handleMessageToMainIsolate(dynamic message) {}

  // This method will handle messages that are sent from the main isolate to the worker
  static void _workerIsolateEntryPoint(dynamic message) {}
}
// #enddocregion main
