// ignore_for_file: unused_element, unused_local_variable, unawaited_futures

Future<void> miscDeclAnalyzedButNotTested() async {
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
    Future<void> checkVersion() async {
      var version = await lookUpVersion();
      // Do something with version
    }
    // #enddocregion checkVersion
  }

  {
    String version;
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
    Future<dynamic> findEntryPoint() async => Never;
    Future<dynamic> flushThenExit(_) async => Never;
    Future<dynamic> runExecutable(_, dynamic) async => Never;
    dynamic args;
    // #docregion repeated-await
    var entrypoint = await findEntryPoint();
    var exitCode = await runExecutable(entrypoint, args);
    await flushThenExit(exitCode);
    // #enddocregion repeated-await
  }

  {
    Future<void> checkVersion() async {}
    // #docregion main
    void main() async {
      checkVersion();
      print('In main: version is ${await lookUpVersion()}');
    }
    // #enddocregion main
  }

  {
    Stream<dynamic> requestServer = Stream.empty();
    Future<dynamic> handleRequest(_) async => Never;
    // #docregion number_thinker
    void main() async {
      // ...
      await for (final request in requestServer) {
        handleRequest(request);
      }
      // ...
    }
    // #enddocregion number_thinker
  }

  <varOrType>(Stream<varOrType> expression) async {
    // #docregion await-for
    // ignore: prefer_final_in_for_each
    await for (varOrType identifier in expression) {
      // Executes each time the stream emits a value.
    }
    // #enddocregion await-for
  };
}
