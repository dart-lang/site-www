import 'dart:async';

const String expectedVersion = '1.0.0';
const bool dev = true;

String lookUpVersionSync() => '1.0.0';
Future<String> lookUpVersionAsync() async => '1.0.0';

Future lookUpVersion() async {
  if (dev) return 'dev-' + await loadFromServer();
  return '1.0.0';
}

Future loadFromServer() async => '1.0.0';

Future checkVersion() async {
  var version = await lookUpVersion();
  if (version == expectedVersion) {
    print(expectedVersion);
  } else {
    print('Unexpected version: $version');
  }
}

Future main() async {
  checkVersion();
  print('In main: version is ${await lookUpVersion()}');
}
