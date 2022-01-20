// ignore_for_file: unused_element, type_annotate_public_apis, strict_raw_type
// #docregion import
import 'dart:async';
// #enddocregion import

void miscDeclAnalyzedButNotTested() {
  final args = <String>[];
  Future<String> findEntryPoint() async => 'entrypoint';
  Future<int> runExecutable(String entryPoint, List<String> args) async => 0;
  Future<int> flushThenExit(int exitCode) async => 0;

  {
    // #docregion runUsingFuture
    void runUsingFuture() {
      // ...
      findEntryPoint().then((entryPoint) {
        return runExecutable(entryPoint, args);
      }).then(flushThenExit);
    }
    // #enddocregion runUsingFuture
  }

  {
    // #docregion runUsingAsyncAwait
    Future<void> runUsingAsyncAwait() async {
      // ...
      var entryPoint = await findEntryPoint();
      var exitCode = await runExecutable(entryPoint, args);
      await flushThenExit(exitCode);
    }
    // #enddocregion runUsingAsyncAwait
  }

  {
    Future<void> catchExample() async {
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
  Future<dynamic> costlyQuery(String url) async {}
  Future<void> expensiveWork(dynamic value) async {}
  Future<void> lengthyComputation() async {}

  {
    Future<void> f() {
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
    Future<void> f() async {
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
    Future<void> f() async {
      // #docregion wait
      Future<void> deleteLotsOfFiles() async => elideBody;
      Future<void> copyLotsOfFiles() async => elideBody;
      Future<void> checksumLotsOfOtherFiles() async => elideBody;

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
