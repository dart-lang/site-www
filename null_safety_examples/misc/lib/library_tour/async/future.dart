// ignore_for_file: unused_element, type_annotate_public_apis
// #docregion import
import 'dart:async';
// #enddocregion import

void miscDeclAnalyzedButNotTested() {
  final args = <String>[];
  Future<String> findEntryPoint() async => 'entrypoint';
  Future<int> runExecutable(
          String entryPoint, List<String> args) async =>
      0;
  Future<int> flushThenExit(int exitCode) async => 0;

  {
    // #docregion runUsingFuture
    runUsingFuture() {
      // ...
      findEntryPoint().then((entryPoint) {
        return runExecutable(entryPoint, args);
      }).then(flushThenExit);
    }
    // #enddocregion runUsingFuture
  }

  {
    // #docregion runUsingAsyncAwait
    runUsingAsyncAwait() async {
      // ...
      var entryPoint = await findEntryPoint();
      var exitCode = await runExecutable(entryPoint, args);
      await flushThenExit(exitCode);
    }
    // #enddocregion runUsingAsyncAwait
  }

  {
    Future catchExample() async {
      // #docregion catch
      var entryPoint = await findEntryPoint();
      try {
        var exitCode = await runExecutable(entryPoint, args);
        await flushThenExit(exitCode);
      } catch (e) {
        // Handle the error...
      }
      // #enddocregion catch
    }
  }

  final url = 'humans.txt';
  Future costlyQuery(String url) async {}
  Future expensiveWork(dynamic value) async {}
  Future lengthyComputation() async {}

  {
    Future f() {
      // #docregion then-chain
      Future result = costlyQuery(url);
      result
          .then((value) => expensiveWork(value))
          .then((_) => lengthyComputation())
          .then((_) => print('Done!'))
          .catchError((exception) {
        /* Handle exception... */
      });
      // #enddocregion then-chain
      return Future.value();
    }
  }

  {
    Future f() async {
      // #docregion then-chain-as-await
      try {
        final value = await costlyQuery(url);
        await expensiveWork(value);
        await lengthyComputation();
        print('Done!');
      } catch (e) {
        /* Handle exception... */
      }
      // #enddocregion then-chain-as-await
    }
  }

  bool elideBody = true;
  {
    Future f() async {
      // #docregion wait
      Future deleteLotsOfFiles() async => elideBody;
      Future copyLotsOfFiles() async => elideBody;
      Future checksumLotsOfOtherFiles() async => elideBody;

      await Future.wait([
        deleteLotsOfFiles(),
        copyLotsOfFiles(),
        checksumLotsOfOtherFiles(),
      ]);
      print('Done with all the long steps!');
      // #enddocregion wait
    }
  }
}
