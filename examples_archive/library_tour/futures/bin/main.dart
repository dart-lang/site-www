import 'dart:async';

// fake methods to make the below examples work

Future<int> getFuture() async {
  return 0;
}

void handleValue(int value) {
  print('value is $value');
}

void handleError(int error) {
  print('error is $error');
}

Future dbQuery(String query) async {
  return true;
}

Future expensiveWork() async {
  return true;
}

Future lengthyComputation() async {
  return true;
}

Future costlyQuery() async {
  // Uncomment the throw and comment the return to see error handling.
//  throw 'costlyQuery failed!!!';
  return true;
}

Future deleteLotsOfFiles() async {
  return true;
}

Future copyLotsOfFiles() async {
  return true;
}

Future checksumLotsOfOtherFiles() async {
  return true;
}

// end fake methods

Future longExpensiveSearch() {
  // Do some setup.
  // Perform an exhaustive search.
  return dbQuery('select * from table');
}

Future runSearch() async {
  try {
    var results = await longExpensiveSearch();
    print('Here are the results: $results');
  } catch (e) {
    print("Oops! Encountered $e");
  }
}

Future runQuery() async {
  try {
    await costlyQuery();
    await expensiveWork();
    await lengthyComputation();
    print('done!');
  } catch (_) {
    print('DOH!');
  }
}

Future wait() async {
  Future deleteDone = deleteLotsOfFiles();
  Future copyDone = copyLotsOfFiles();
  Future checksumDone = checksumLotsOfOtherFiles();

  await Future.wait([deleteDone, copyDone, checksumDone]);
  print('Done with all the long steps');
}

Future main() async {
  Future<int> future = getFuture();
  var value = await future;
  try {
    handleValue(value);
  } catch (e) {
    handleError(e);
  }

  runSearch();
  runQuery();
  wait();
}
