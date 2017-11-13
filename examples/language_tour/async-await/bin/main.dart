import 'dart:async';

const String expectedVersion = '1.0.0';
const bool dev = true;

// #docregion async-lookUpVersion
Future<String> lookUpVersion() async => '1.0.0';
// #enddocregion async-lookUpVersion

class Sync {
  // #docregion sync-lookUpVersion
  String lookUpVersion() => '1.0.0';
  // #enddocregion sync-lookUpVersion
}

Future loadFromServer() async => '1.0.0';

// #docregion checkVersion
Future checkVersion() async {
  var version = await lookUpVersion();
  // Do something with version
  // #enddocregion checkVersion
  if (version == expectedVersion) {
    print(expectedVersion);
  } else {
    print('Unexpected version: $version');
  }
  // #docregion checkVersion
}
// #enddocregion checkVersion

class ElideBodies {
  // #docregion checkVersion-lookUpVersion
  Future checkVersion() async {/* ... */}

  Future lookUpVersion() async {/* ... */}
  // #enddocregion checkVersion-lookUpVersion
}

// #docregion main
Future main() async {
  checkVersion();
  print('In main: version is ${await lookUpVersion()}');
}
// #enddocregion main

Future devLookUpVersion() async {
  if (dev) return 'dev-' + await loadFromServer();
  return '1.0.0';
}

// Specialized code excerpts used in the prose below this point:
Future notCalled() async {
  // #docregion
  await lookUpVersion()
      // #enddocregion
      ;

  var version;
  // #docregion try-catch
  try {
    version = await lookUpVersion();
  } catch (e) {
    // React to inability to look up the version
  }
  // #enddocregion try-catch
  return version;
}
