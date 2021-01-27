// ignore_for_file: unused_element, unused_local_variable, unawaited_futures
typedef Async0 = Future Function();
typedef Async1 = Future Function(dynamic);
typedef Async2 = Future Function(dynamic, dynamic);

Future miscDeclAnalyzedButNotTested() async {
  // #docregion async-lookUpVersion
  Future<String> lookUpVersion() async => '1.0.0';
  // #enddocregion async-lookUpVersion

  {
    // #docregion await-lookUpVersion
    await lookUpVersion();
    // #enddocregion await-lookUpVersion
  }

  {
    // #docregion checkVersion
    Future checkVersion() async {
      var version = await lookUpVersion();
      // Do something with version
    }
    // #enddocregion checkVersion
  }

  {
    var version;
    // #docregion try-catch
    try {
      version = await lookUpVersion();
    } catch (e) {
      // React to inability to look up the version
    }
    // #enddocregion try-catch
  }

  {
    // #docregion sync-lookUpVersion
    String lookUpVersion() => '1.0.0';
    // #enddocregion sync-lookUpVersion
  }

  {
    Async0 findEntrypoint = () async => Never;
    Async1 flushThenExit = (_) async => Never;
    Async2 runExecutable = (_, __) async => Never;
    var args;
    // #docregion repeated-await
    var entrypoint = await findEntrypoint();
    var exitCode = await runExecutable(entrypoint, args);
    await flushThenExit(exitCode);
    // #enddocregion repeated-await
  }

  {
    Future checkVersion() async {}
    // #docregion main
    Future main() async {
      checkVersion();
      print('In main: version is ${await lookUpVersion()}');
    }
    // #enddocregion main
  }

  {
    // Excerpt from dart-tutorials-samples/httpserver/number_thinker.dart
    Stream requestServer = Stream.empty();
    Async1 handleRequest = (_) async => Never;
    // #docregion number_thinker
    Future main() async {
      // ...
      await for (var request in requestServer) {
        handleRequest(request);
      }
      // ...
    }
    // #enddocregion number_thinker
  }

  <varOrType>(Stream<varOrType> expression) async {
    // #docregion await-for
    await for (varOrType identifier in expression) {
      // Executes each time the stream emits a value.
    }
    // #enddocregion await-for
  };
}
